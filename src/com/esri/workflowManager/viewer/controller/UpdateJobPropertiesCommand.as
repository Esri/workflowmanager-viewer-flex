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
	import com.esri.workflowManager.tasks.supportClasses.AuxRecordDescription;
	import com.esri.workflowManager.tasks.supportClasses.JobUpdateParameters;
	import com.esri.workflowManager.viewer.events.JobQueryEvent;
	import com.esri.workflowManager.viewer.events.PropertiesDirtyEvent;
	import com.esri.workflowManager.viewer.events.SelectJobEvent;
	import com.esri.workflowManager.viewer.model.Model;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;
	
	public class UpdateJobPropertiesCommand
	{
        [Listen(properties="updateParams,extendedProperties")]
        public function updateJobPropertiesHandler(updateParams:JobUpdateParameters, extendedProperties:Array/*of AuxRecordDescription*/):void
        {
			// Clone the array so we can freely modify it
			var remainingExtProps:Array = (extendedProperties == null ? [] : extendedProperties.concat());
			
			Model.instance.jobTask.updateJob(updateParams, Model.instance.currentUserInfo.userName,
				new AsyncResponder(onResult, onFault));
			
			function onResult(data:Object, token:Object=null):void
			{
				// Check if there are additional extended properties to save
				if (remainingExtProps.length > 0)
				{
					var record:AuxRecordDescription = remainingExtProps.shift();
					Model.instance.jobTask.updateRecord(updateParams.jobId, record, 
						Model.instance.currentUserInfo.userName, new AsyncResponder(onResult, onFault));
					return;
				}
				
				// All basic and extended properties have now been saved
				CentralDispatcher.dispatchEvent(new PropertiesDirtyEvent(false));
				if (Model.instance.lastJobSearch)
				{
					CentralDispatcher.dispatchEvent(new JobQueryEvent(null, Model.instance.lastJobSearch));
				}
				CentralDispatcher.dispatchEvent(new SelectJobEvent(updateParams.jobId));
			}
			function onFault(data:Object, token:Object=null):void
			{
				Alert.show(Model.resource("ErrorUpdateJobProperties") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
			}
        }
	}
}
