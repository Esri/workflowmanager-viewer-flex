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
	import com.esri.workflowManager.viewer.events.SelectedJobAttachmentsEvent;
	import com.esri.workflowManager.viewer.model.Model;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;

	public class DeleteJobAttachmentCommand
	{
		[Listen(properties="jobId,attachmentId")]
		/**
		 * Deletes an attachment specified by the attachment ID 
		 * from the job specified by the job ID.
		 */
        public function deleteJobAttachmentHandler(jobId:int, attachmentId:int):void
        {
			Model.instance.jobTask.deleteAttachment(jobId, attachmentId, 
				Model.instance.currentUserInfo.userName, 
				new AsyncResponder(onResult, onFault));
			
			function onResult(data:Object, token:Object=null):void
			{
				CentralDispatcher.dispatchEvent(new SelectedJobAttachmentsEvent(jobId));
			}
			function onFault(data:Object, token:Object=null):void
			{
				Alert.show(Model.resource("ErrorDeleteAttachment") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
			}
        }
	}
}
