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
	import mx.rpc.Responder;
	
	public class MoveNextCommand
	{
        [Listen(properties="jobID,stepID,returnCode,moveToNext,answerLabel,notes")]
        public function moveNextHandler(jobID:int, stepID:int, returnCode:int, 
			moveToNext:Boolean = true, answerLabel:String = null, notes:String = null):void
        {
        	Model.instance.isStepExecuting = true;
			
			if (answerLabel != null)
			{
				// Log a comment with the question response
				var comment:String;
				if (notes && notes.length > 0)
				{
					comment = Model.resource("QuestionResponseWithNotes", [answerLabel, notes]);
				}
				else
				{
					comment = Model.resource("QuestionResponse", [answerLabel]);
				}
				Model.instance.jobTask.logAction(jobID, Model.instance.commentActivityId, comment, 
					Model.instance.currentUserInfo.userName,
					new Responder(moveNext, moveNext));
			}
			else
			{
				moveNext();
			}
			
			function moveNext(ignore:Object = null):void
			{
				if (moveToNext)
				{
					// move to the next step
					Model.instance.workflowTask.moveToNextStep(jobID, stepID, returnCode,
						Model.instance.currentUserInfo.userName,
						new Responder(onResult, onFault));
				}
				else
				{
					// nothing left to do, reset flag and return
					Model.instance.isStepExecuting = false;
				}
			}
			function onResult(data:Object):void
			{
	        	Model.instance.isStepExecuting = false;
				CentralDispatcher.dispatchEvent(new SelectedJobWorkflowEvent(jobID));
			}
			function onFault(data:Object):void
			{
	        	Model.instance.isStepExecuting = false;
				Alert.show(Model.resource("ErrorMoveNextStep") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
			}
        }
	}
}
