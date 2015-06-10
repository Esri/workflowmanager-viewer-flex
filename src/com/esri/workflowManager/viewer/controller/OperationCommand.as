////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2010 ESRI
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
	import com.esri.workflowManager.viewer.events.CloseJobEvent;
	import com.esri.workflowManager.viewer.events.DeleteJobsEvent;
	import com.esri.workflowManager.viewer.events.ReopenClosedJobsEvent;
	import com.esri.workflowManager.viewer.model.Model;
	import com.esri.workflowManager.viewer.model.OperationType;
	import com.esri.workflowManager.viewer.view.AssignJobBox;
	import com.esri.workflowManager.tasks.supportClasses.JobStageEnum;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	public class OperationCommand
	{
        [Listen(properties="operationType")]
        public function operationHandler(operationType:int):void
        {	
			var jobIds:Array = [];
			
			for each (var jobObject:Object in Model.instance.jobList)
			{
				if (jobObject.selected)
				{
					jobIds.push(jobObject[Model.instance.jobIdField]);
				}
			}
			
			if (jobIds.length == 1 && Model.instance.selectedJob != null && Model.instance.selectedJob.id == jobIds[0])
			{
				var isJobClosed:Boolean = Model.instance.selectedJob.stage == JobStageEnum.CLOSED;
				
				if (operationType == OperationType.CLOSE && isJobClosed)
				{
					// selected job is already closed
					Alert.show(Model.resource("SelectedJobAlreadyClosed"), 
						Model.resource("CloseJobTip"), 
						Alert.OK);
					return;
				}
				else if (operationType == OperationType.REOPEN && !isJobClosed) 
				{
					// selected job is already open
					Alert.show(Model.resource("SelectedJobAlreadyOpen"), 
						Model.resource("ReopenClosedJobTip"), 
						Alert.OK);
					return;
				}
			}

			if (jobIds.length > 0)
			{			
				switch (operationType)
				{
					case OperationType.ASSIGN:
						var assignJobBox:AssignJobBox = PopUpManager.createPopUp(FlexGlobals.topLevelApplication.parentDocument, AssignJobBox, true) as AssignJobBox;
						assignJobBox.jobIds = jobIds;
						PopUpManager.centerPopUp(assignJobBox);
						break;
					case OperationType.CLOSE:						
						Alert.show(Model.resource("ConfirmCloseJobs"), 
							Model.resource("CloseJobTip"), 
							Alert.YES | Alert.NO,
							null, 
							closeJobsAlertListener, 
							null, 
							Alert.NO);
						break;
					case OperationType.REOPEN:						
						Alert.show(Model.resource("ConfirmReopenClosedJobs"), 
							Model.resource("ReopenClosedJobTip"), 
							Alert.YES | Alert.NO,
							null, 
							reopenClosedJobsAlertListener, 
							null, 
							Alert.NO);
						break;
					case OperationType.DELETE:
						Alert.show(Model.resource("ConfirmDeleteJobs"), 
							Model.resource("DeleteJobTip"), 
							Alert.YES | Alert.NO,
							null, 
							deleteJobsAlertListener, 
							null, 
							Alert.NO);
						break;
				}
			}
			
			function closeJobsAlertListener(event:CloseEvent):void
			{
				if (event.detail == Alert.YES)
				{
					for (var i:int = 0; i < jobIds.length; i++)
					{
						CentralDispatcher.dispatchEvent(new CloseJobEvent(jobIds[i], true));
					}
				}
			}
			function reopenClosedJobsAlertListener(event:CloseEvent):void
			{
				if (event.detail == Alert.YES)
				{
					for (var i:int = 0; i < jobIds.length; i++)
					{
						CentralDispatcher.dispatchEvent(new ReopenClosedJobsEvent(jobIds[i]));
					}
				}
			}
			function deleteJobsAlertListener(event:CloseEvent):void
			{
				if (event.detail == Alert.YES)
				{
					CentralDispatcher.dispatchEvent(new DeleteJobsEvent(jobIds));
				}
			}
        }
	}
}
