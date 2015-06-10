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
	import com.esri.workflowManager.viewer.events.SelectJobEvent;
	import com.esri.workflowManager.viewer.model.Model;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;
	
	public class CloseJobCommand
	{
        [Listen(properties="jobID,isBulkOperation")]
		/**
		 * Closes the job specified by the job ID.
		 */
        public function closeJobHandler(jobID:int, isBulkOperation:Boolean):void
        {
        	Model.instance.jobTask.closeJob(jobID,
        									Model.instance.currentUserInfo.userName, 
        									new AsyncResponder(onResult, onFault));
			
        	function onResult(data:Object, token:Object=null):void
        	{
				if (!isBulkOperation)
				{
	        		CentralDispatcher.dispatchEvent(new SelectJobEvent(jobID));
				}
        	}
        	function onFault(data:Object, token:Object=null):void
        	{
				Alert.show(Model.resource("ErrorCloseJob") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
        	}
        }
	}
}
