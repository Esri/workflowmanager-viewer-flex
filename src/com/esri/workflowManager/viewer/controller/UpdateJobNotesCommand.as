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
	import com.esri.workflowManager.viewer.events.SelectJobEvent;
	import com.esri.workflowManager.viewer.model.Model;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;

	public class UpdateJobNotesCommand
	{
		[Listen(properties="jobId,notes")]
		public function updateJobNotesHandler(jobId:int, notes:String):void
		{
			Model.instance.jobTask.updateNotes(jobId, notes, Model.instance.currentUserInfo.userName, 
												  new AsyncResponder(onResult, onFault));
			
			function onResult(data:Object, token:Object=null):void
			{
				CentralDispatcher.dispatchEvent(new SelectJobEvent(jobId));
			}
			function onFault(data:Object, token:Object=null):void
			{
				Alert.show(Model.resource("ErrorUpdateJobNotes") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
			}
		}
	}
}