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
	import com.esri.workflowManager.tasks.supportClasses.WorkflowOption;
	import com.esri.workflowManager.tasks.supportClasses.WorkflowStepInfo;
	import com.esri.workflowManager.viewer.events.SelectedJobWorkflowEvent;
	import com.esri.workflowManager.viewer.model.Model;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;
	
	public class ResolveConflictCommand
	{
        [Listen(properties="jobID,stepID,workflowOption")]
        public function resolveConflictHandler(jobID:int, stepID:int, workflowOption:WorkflowOption):void
        {
			var optionStepIds:Array = [];
			for each (var step:WorkflowStepInfo in workflowOption.steps)
			{
				optionStepIds.push(step.id);
			}
			
        	Model.instance.isMarkingStepAsDone = true;
			Model.instance.workflowTask.resolveConflict(jobID,
												   stepID,
												   workflowOption.returnCode,
												   optionStepIds,
												   Model.instance.currentUserInfo.userName,
												   new AsyncResponder(onResult, onFault));

			function onResult(data:Object, token:Object):void
			{
	        	Model.instance.isMarkingStepAsDone = false;
				CentralDispatcher.dispatchEvent(new SelectedJobWorkflowEvent(jobID));
			}
			
			function onFault(data:Object, token:Object):void
			{
	        	Model.instance.isMarkingStepAsDone = false;
				Alert.show(Model.resource("ErrorResolveConflict") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
			}
        }
	}
}
