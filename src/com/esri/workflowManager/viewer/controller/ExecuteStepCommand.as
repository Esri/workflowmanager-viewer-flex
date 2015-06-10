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
	import com.esri.workflowManager.tasks.supportClasses.ExecuteInfo;
	import com.esri.workflowManager.viewer.events.CloseJobEvent;
	import com.esri.workflowManager.viewer.events.SelectedJobWorkflowEvent;
	import com.esri.workflowManager.viewer.model.Model;
	import com.esri.workflowManager.viewer.view.MarkDoneOptionsBox;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncResponder;
	
	public class ExecuteStepCommand
	{
        [Listen(properties="jobID,stepID,closeJobAfter")]
		/**
		 * Executes a step specified by the step ID on the job 
		 * specified by the job ID.
		 */
        public function executeStepHandler(jobID:int, stepID:int, closeJobAfter:Boolean):void
        {
        	Model.instance.isStepExecuting = true;
			Model.instance.workflowTask.executeSteps(jobID, [stepID], true, 
											   Model.instance.currentUserInfo.userName,
											   new AsyncResponder(onResult, onFault));
			
			function onResult(executeInfos:Array, token:Object):void
			{
				Model.instance.isStepExecuting = false;
				
				if (executeInfos.length > 0)
				{
					var executeInfo:ExecuteInfo = executeInfos[0] as ExecuteInfo;
					if (executeInfo.hasConflicts && executeInfo.conflicts != null)
					{
						var markDoneOptionsBox:MarkDoneOptionsBox = PopUpManager.createPopUp(FlexGlobals.topLevelApplication.parentDocument, MarkDoneOptionsBox, true) as MarkDoneOptionsBox;
						PopUpManager.centerPopUp(markDoneOptionsBox);
						markDoneOptionsBox.conflicts = executeInfo.conflicts;
					}
				}
				
				if (closeJobAfter)
				{
					// The CloseJob event eventually leads to a SelectedJobWorkflow event being dispatched
					CentralDispatcher.dispatchEvent(new CloseJobEvent(jobID));
				}
				else
				{
					CentralDispatcher.dispatchEvent(new SelectedJobWorkflowEvent(jobID));
				}
			}
			function onFault(data:Object, token:Object):void
			{
				Model.instance.isStepExecuting = false;
				Alert.show(Model.resource("ErrorExecuteStep") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
			}
		}
	}
}
