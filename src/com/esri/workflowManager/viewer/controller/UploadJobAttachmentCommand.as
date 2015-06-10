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
	import com.esri.workflowManager.viewer.events.SelectedJobAttachmentsEvent;
	import com.esri.workflowManager.viewer.model.Model;
	import com.esri.workflowManager.viewer.view.UploadAttachmentProgressBox;
	
	import flash.net.FileReference;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	import mx.rpc.Responder;
	
	public class UploadJobAttachmentCommand
	{
		[Listen(properties="jobId,file")]
        public function uploadJobAttachmentHandler(jobId:int, file:FileReference):void
        {
			var progressBox:UploadAttachmentProgressBox = PopUpManager.createPopUp(FlexGlobals.topLevelApplication.parentDocument, UploadAttachmentProgressBox, true) as UploadAttachmentProgressBox;
			PopUpManager.centerPopUp(progressBox);
			
			Model.instance.jobTask.addEmbeddedFileAttachment(jobId, file, Model.instance.currentUserInfo.userName,
				new Responder(onResult, onFault));
			
			function onResult(attachmentId:int):void
			{
				PopUpManager.removePopUp(progressBox);
				CentralDispatcher.dispatchEvent(new SelectedJobAttachmentsEvent(jobId));
				CentralDispatcher.dispatchEvent(new SelectJobEvent(jobId));
			}
			function onFault(fault:Object):void
			{
				PopUpManager.removePopUp(progressBox);
				Alert.show(Model.resource("ErrorUploadJobAttachment"), Model.resource("ErrorTitle"));
				//Alert.show(Model.resource("ErrorUploadJobAttachment") + "\n\n" + fault.toString(), Model.resource("ErrorTitle"));
			}
        }
	}
}
