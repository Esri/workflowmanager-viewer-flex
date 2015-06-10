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
	import com.esri.workflowManager.viewer.events.SelectedJobAttachmentsEvent;
	import com.esri.workflowManager.viewer.model.Model;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;
	
	public class AddLinkedURLAttachmentCommand
	{
		[Listen(properties="jobId,url")]
		/**
		 * Add a linked URL attachment to the job.
		 */
        public function addLinkedURLAttachmentHandler(jobId:int, url:String):void
        {
			Model.instance.jobTask.addLinkedURLAttachment(jobId, url, Model.instance.currentUserInfo.userName,			
				new AsyncResponder(onResult, onFault));
			
			function onResult(data:Object, token:Object=null):void
			{				
				CentralDispatcher.dispatchEvent(new SelectedJobAttachmentsEvent(jobId));
			}
			function onFault(data:Object, token:Object=null):void
			{
				Alert.show(Model.resource("ErrorUploadJobAttachment") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
			}	
        }
	}
}
