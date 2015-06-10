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
	import com.esri.workflowManager.tasks.supportClasses.JobAssignmentTypeEnum;
	import com.esri.workflowManager.viewer.events.JobQueryEvent;
	import com.esri.workflowManager.viewer.model.Model;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;
	
	public class AssignJobsCommand
	{
        [Listen(properties="jobIDs,assignedType,assignedTo")]
		/**
		 * Assign the job specified by the assignedType and assignedTo.
		 */
        public function assignJobsHandler(jobIDs:Array, assignedType:int, assignedTo:String):void
        {
        	if (assignedType != JobAssignmentTypeEnum.UNASSIGNED)
			{			
				Model.instance.jobTask.assignJobs(jobIDs, assignedType, assignedTo, 
	        									Model.instance.currentUserInfo.userName, 
	        									new AsyncResponder(onResult, onFault));
			}
			else 
			{
				Model.instance.jobTask.unassignJobs(jobIDs, 
												Model.instance.currentUserInfo.userName, 
												new AsyncResponder(onResult, onFault));				
			}
        }
		
		private function onResult(data:Object, token:Object=null):void
		{   
			CentralDispatcher.dispatchEvent(new JobQueryEvent(Model.instance.jobTableTitle, Model.instance.lastJobSearch));
		}
		private function onFault(data:Object, token:Object=null):void
		{
			Alert.show(Model.resource("ErrorAssignJobs") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
		}
	}
}
