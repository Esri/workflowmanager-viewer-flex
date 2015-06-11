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
	import com.esri.workflowManager.tasks.supportClasses.JobUpdateParameters;
	import com.esri.workflowManager.viewer.events.SelectJobEvent;
	import com.esri.workflowManager.viewer.model.Model;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;
	
	public class UpdateJobAOICommand
	{
        [Listen(properties="updateParams")]
        public function updateJobAOIHandler(updateParams:JobUpdateParameters):void
        {
			Model.instance.jobTask.updateJob(updateParams, 
				Model.instance.currentUserInfo.userName, 
				new AsyncResponder(onResult, onFault));
			
			function onResult(data:Object, token:Object=null):void
			{
				CentralDispatcher.dispatchEvent(new SelectJobEvent(updateParams.jobId));
				Model.instance.aoiDynamicLayer.refresh();
			}
			function onFault(data:Object, token:Object=null):void
			{
				Alert.show(Model.resource("ErrorUpdateJobAOI") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
			}
        }
	}
}
