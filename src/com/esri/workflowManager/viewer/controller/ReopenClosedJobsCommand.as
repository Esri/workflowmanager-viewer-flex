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
	import com.esri.workflowManager.viewer.events.JobQueryEvent;
	import com.esri.workflowManager.viewer.model.Model;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;
	
	public class ReopenClosedJobsCommand
	{
		[Listen(properties="jobIDs")]
		/**
		 * Reopen the closed jobs specified by the job IDs.
		 */
		public function reopenClosedJobsHandler(jobIDs:Array):void
		{
			Model.instance.jobTask.reopenClosedJobs(jobIDs, 
				Model.instance.currentUserInfo.userName, 
				new AsyncResponder(onResult, onFault));
			
			function onResult(data:Object, token:Object=null):void
			{   
				for each (var jobID:int in jobIDs)
				{
					if (Model.instance.selectedJob && (jobID == Model.instance.selectedJob.id))
					{
						// clear out the current job if it was one of the jobs reopened
						Model.instance.selectedJob = null;
					}
				}
				CentralDispatcher.dispatchEvent(new JobQueryEvent(Model.instance.jobTableTitle, Model.instance.lastJobSearch));
			}
			function onFault(data:Object, token:Object=null):void
			{
				Alert.show(Model.resource("ErrorReopeningClosedJobs") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
			}
		}
	}
}
