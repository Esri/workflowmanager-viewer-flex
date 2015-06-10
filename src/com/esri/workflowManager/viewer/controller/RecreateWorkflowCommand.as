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
	import com.esri.workflowManager.viewer.events.SelectedJobWorkflowEvent;
	import com.esri.workflowManager.viewer.model.Model;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.rpc.AsyncResponder;
	
	public class RecreateWorkflowCommand
	{
		[Listen(properties="jobID")]
		/**
		 * Recreate the job workflow specified by the job ID.
		 */
		public function recreateWorkflowHandler(jobID:int):void
		{
			Alert.show(Model.resource("ConfirmRecreateWorkflow"), 
				Model.resource("RecreateWorkflow"), 
				Alert.YES | Alert.NO,
				null, 
				recreateWorkflowAlertListener, 
				null, 
				Alert.NO);
			
			function recreateWorkflowAlertListener(event:CloseEvent):void
			{
				if (event.detail == Alert.YES)
				{
					Model.instance.workflowTask.recreateWorkflow(jobID, 
						Model.instance.currentUserInfo.userName, 
						new AsyncResponder(onResult, onFault));
				}
				
				function onResult(data:Object, token:Object=null):void
				{   
					CentralDispatcher.dispatchEvent(new SelectedJobWorkflowEvent(jobID));
				}
				function onFault(data:Object, token:Object=null):void
				{
					Alert.show(Model.resource("ErrorRecreatingWorkflow") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
				}
			}
		}
	}
}
