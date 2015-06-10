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
	import com.esri.workflowManager.viewer.events.SelectedJobAOIEvent;
	import com.esri.workflowManager.viewer.model.Model;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;
	
	public class DeleteJobsCommand
	{
        [Listen(properties="jobIDs")]
		/**
		 * Delete the job specified by the job ID.
		 */
        public function deleteJobsHandler(jobIDs:Array):void
        {
        	Model.instance.jobTask.deleteJobs(jobIDs, true, 
        									Model.instance.currentUserInfo.userName, 
        									new AsyncResponder(onResult, onFault));
			
        	function onResult(data:Object, token:Object=null):void
        	{   
				for each (var jobID:int in jobIDs)
				{
					if (Model.instance.selectedJob && (jobID == Model.instance.selectedJob.id))
					{
						// clear out the current job if it was one of the jobs deleted
						// and dispatch an event to clear out the currently selected AOI
						Model.instance.selectedJob = null;
						CentralDispatcher.dispatchEvent(new SelectedJobAOIEvent(jobID));
					}
				}
				CentralDispatcher.dispatchEvent(new JobQueryEvent(Model.instance.jobTableTitle, Model.instance.lastJobSearch));
        	}
        	function onFault(data:Object, token:Object=null):void
        	{
				Alert.show(Model.resource("ErrorDeleteJobs") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
        	}
        }
	}
}
