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
	import com.esri.workflowManager.viewer.events.SelectedJobHistoryEvent;
	import com.esri.workflowManager.viewer.model.Model;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;

	public class LogActivityCommand
	{
		[Listen(properties="jobId,comments")]
		public function logActivityHandler(jobId:int, comments:String):void
        {
			if (Model.instance.commentActivityId > 0)
			{
	        	Model.instance.jobTask.logAction(jobId, Model.instance.commentActivityId, comments, 
					Model.instance.currentUserInfo.userName, 
        			new AsyncResponder(onResult, onFault));
			}
			
       		function onResult(data:Object, token:Object=null):void
			{
				CentralDispatcher.dispatchEvent(new SelectedJobHistoryEvent(jobId));
			}
			function onFault(data:Object, token:Object=null):void
			{
				Alert.show(Model.resource("ErrorAddComment") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
			}
        }
	}
}
