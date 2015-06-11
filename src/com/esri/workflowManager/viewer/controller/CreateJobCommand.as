////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2015 ESRI
//
// All rights reserved under the copyright laws of the United States.
// You may freely redistribute and use this software, with or
// without modification, provided you include the original copyright
// and use restrictions.  
//
////////////////////////////////////////////////////////////////////////////////

package com.esri.workflowManager.viewer.controller
{
	import com.esri.holistic.CentralDispatcher;
	import com.esri.workflowManager.tasks.supportClasses.JobCreationParameters;
	import com.esri.workflowManager.tasks.supportClasses.JobInfo;
	import com.esri.workflowManager.tasks.supportClasses.JobQueryParameters;
	import com.esri.workflowManager.tasks.supportClasses.JobUpdateParameters;
	import com.esri.workflowManager.viewer.events.JobQueryEvent;
	import com.esri.workflowManager.viewer.events.SelectJobEvent;
	import com.esri.workflowManager.viewer.model.JobSearch;
	import com.esri.workflowManager.viewer.model.Model;
	import com.esri.workflowManager.viewer.view.CreateJobProgressBox;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	import mx.rpc.Responder;
	
	public class CreateJobCommand
	{
		[Listen(properties="createParams,prefix,suffix")]
		/**
		 * Creates a job based on the parameters specified. 
		 */
		public function createJobHandler(createParams:JobCreationParameters, prefix:String, suffix:String):void
		{
			var progressBox:CreateJobProgressBox = PopUpManager.createPopUp(FlexGlobals.topLevelApplication.parentDocument, CreateJobProgressBox, true) as CreateJobProgressBox;
			PopUpManager.centerPopUp(progressBox);
			
			// Holder for future result
			var jobId:int = 0;
			
			Model.instance.jobTask.createJob(createParams, 
				Model.instance.currentUserInfo.userName,
				new Responder(onCreateResult, onCreateFault));
			
			function onCreateResult(jobIds:Array):void
			{
				if (jobIds.length > 0)
				{
					jobId = jobIds[0];
					if (prefix != "" || suffix != "")
					{						
						Model.instance.jobTask.getJob(jobId, new Responder(onJobResult, onJobFault));						
					}
					else
					{
						showCreatedResult();
					}
				}
			}
			function onCreateFault(data:Object):void
			{
				PopUpManager.removePopUp(progressBox);
				Alert.show(Model.resource("ErrorCreateJob") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
			}
			function onJobResult(data:JobInfo):void
			{
				var jobName:String = data.name;
				if (prefix)
				{
					jobName = prefix + jobName;
				}
				if (suffix)
				{
					jobName = jobName + suffix;
				}
				var updateParams:JobUpdateParameters = new JobUpdateParameters();
				updateParams.jobId = jobId;
				updateParams.name = jobName;
				Model.instance.jobTask.updateJob(updateParams, 
					Model.instance.currentUserInfo.userName,
					new Responder(showCreatedResult, onUpdateNameFault));
			}
			function onJobFault(data:Object):void
			{
				Alert.show(Model.resource("ErrorLoadingJobInfo") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
			}
			function showCreatedResult(ignore:Object = null):void
			{
				PopUpManager.removePopUp(progressBox);
				
				var params:JobQueryParameters = new JobQueryParameters();
				params.fields = ["JTX_JOBS.JOB_ID","JTX_JOBS.JOB_NAME","JTX_JOB_TYPES.JOB_TYPE_NAME","JTX_JOBS.ASSIGNED_TO","JTX_JOBS.DUE_DATE","JTX_JOBS.DESCRIPTION"];
				params.aliases = Model.resource("QueryFieldDescriptions").split(",");
				params.tables = ["JTX_JOBS","JTX_JOB_TYPES"];
				params.where = "JTX_JOBS.JOB_TYPE_ID=JTX_JOB_TYPES.JOB_TYPE_ID AND JTX_JOBS.JOB_ID=" + jobId;
				CentralDispatcher.dispatchEvent(new JobQueryEvent(Model.resource("NewJobCreated"), JobSearch.fromQueryParameters(params)));
				CentralDispatcher.dispatchEvent(new SelectJobEvent(jobId));
			}
			function onUpdateNameFault(data:Object):void
			{
				Alert.show(Model.resource("ErrorUpdateJobProperties") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
			}
		}
	}
}
