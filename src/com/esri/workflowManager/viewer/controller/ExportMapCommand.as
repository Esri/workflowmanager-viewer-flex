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
	import com.esri.ags.tasks.supportClasses.DataFile;
	import com.esri.ags.tasks.supportClasses.ExecuteResult;
	import com.esri.ags.tasks.supportClasses.JobInfo;
	import com.esri.ags.tasks.supportClasses.ParameterValue;
	import com.esri.ags.tasks.supportClasses.PrintParameters;
	import com.esri.holistic.CentralDispatcher;
	import com.esri.workflowManager.viewer.model.Model;
	import com.esri.workflowManager.viewer.view.ExportMapProgressBox;
	
	import flash.net.URLRequest;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	import mx.rpc.Responder;
	
	public class ExportMapCommand
	{
		[Listen(properties="printParameters")]
		/**
		 * Exports a map based on the parameters specified. 
		 */
		public function exportMapHandler(printParameters:PrintParameters):void
		{
			var progressBox:ExportMapProgressBox = PopUpManager.createPopUp(FlexGlobals.topLevelApplication.parentDocument, ExportMapProgressBox, true) as ExportMapProgressBox;
			PopUpManager.centerPopUp(progressBox);
			
			if (Model.instance.printTask.getServiceInfoLastResult.isServiceAsynchronous)
			{
				Model.instance.printTask.submitJob(
					printParameters, 
					new Responder(onSubmitJobComplete, onFault));
			}
			else
			{
				Model.instance.printTask.execute(printParameters, 
					new Responder(onExecuteComplete, onFault));
			}
			
			function onSubmitJobComplete(jobInfo:JobInfo, token:Object=null):void
			{
				if (jobInfo.jobStatus == JobInfo.STATUS_SUCCEEDED
					&& Model.instance.printTask.getServiceInfoLastResult.hasResultData)
				{
					Model.instance.printTask.getResultData(jobInfo.jobId,
						new Responder(onResultDataComplete, onFault));
				}
				else
				{
					Alert.show(Model.resource("ExportMapStatus") + "\n\n" + 
						jobInfo.jobStatus, Model.resource("ErrorTitle"));
				}
			}
			
			function onResultDataComplete (parameterValue:ParameterValue, token:Object=null):void
			{
				var dataFile:DataFile = parameterValue.value as DataFile;
				if (dataFile)
				{
					flash.net.navigateToURL(new URLRequest(dataFile.url));
				}
				PopUpManager.removePopUp(progressBox);
			}
			
			function onExecuteComplete(executeResult:ExecuteResult, token:Object=null):void
			{
				if (executeResult.results && executeResult.results.length > 0)
				{
					var paramValue:ParameterValue = executeResult.results[0];
					var dataFile:DataFile = paramValue.value as DataFile;
					if (dataFile)
					{
						flash.net.navigateToURL(new URLRequest(dataFile.url));
					}
				}
				else
				{
					Alert.show(Model.resource("ErrorExportingMap") + "\n\n" + 
						executeResult.results, Model.resource("ErrorTitle"));
				}
				PopUpManager.removePopUp(progressBox);
			}
			
			function onFault(data:Object, token:Object=null):void
			{
				Alert.show(Model.resource("ErrorExportingMap") + "\n\n" + 
					data.toString(), Model.resource("ErrorTitle"));
				PopUpManager.removePopUp(progressBox);
			}
		}
	}
}
