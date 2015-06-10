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
	import com.esri.workflowManager.tasks.supportClasses.WorkflowDisplayDetails;
	import com.esri.workflowManager.viewer.model.Model;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;

	public class SelectedJobWorkflowCommand
	{
		[Listen(properties="jobID")]
        public function selectedJobWorkflowHandler(jobID:int):void
        {
			var counter:int = 3;
        	Model.instance.isWorkflowLoading = true;
			
			// Fire off the various workflow REST requests
			Model.instance.workflowTask.getWorkflowDisplayDetails(jobID, new AsyncResponder(onWorkflowDetailsResult, onWorkflowDetailsFault));
			Model.instance.workflowTask.getCurrentSteps(jobID, new AsyncResponder(onJobCurrentStepsResult, onJobCurrentStepsFault));
			loadWorkflowImage();
			
			function decrementCounter():void
			{
				counter = counter - 1;
				if (counter <= 0)
				{
					Model.instance.isWorkflowLoading = false;
				}
			}
			
			function loadWorkflowImage():void
			{
	        	var loader:Loader = new Loader();
	        	loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
	        	loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
	        	var url:String = Model.instance.configModel.workflowServiceURL + "/jobs/"+jobID+"/workflow";
	        	var urlRequest:URLRequest = new URLRequest(url);
	        	var urlVariables:URLVariables = new URLVariables();
	        	urlVariables.f = "image";
	        	if (Model.instance.configModel.tokenAuthenticationEnabled)
	        	{
		        	urlVariables.token = Model.instance.token;
		        }
	        	urlRequest.data = urlVariables;
	        	urlRequest.method = URLRequestMethod.POST;
	        	loader.load(urlRequest);
        	}
			
			function loaderCompleteHandler(event:Event):void
			{
				decrementCounter();
				Model.instance.workflowImageSource = event.currentTarget.content;
			}
			function loaderIOErrorHandler(event:IOErrorEvent):void
			{
				decrementCounter();
				Model.instance.workflowImageSource = null;
			}
			function onWorkflowDetailsResult(workflowInfo:WorkflowDisplayDetails, token:Object=null):void
			{
				decrementCounter();
				Model.instance.selectedJobDisplaySteps = workflowInfo.steps;
				Model.instance.selectedJobDisplayPaths = workflowInfo.paths;
			}
			function onWorkflowDetailsFault(data:Object, token:Object=null):void
			{
				decrementCounter();
				Alert.show(Model.resource("ErrorLoadingWorkflowInfo") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
			}
			function onJobCurrentStepsResult(data:Object, token:Object=null):void
			{
				decrementCounter();
				Model.instance.selectedJobCurrentSteps = data as Array;
			}
        	function onJobCurrentStepsFault(data:Object, token:Object=null):void
        	{
				decrementCounter();
				Alert.show(Model.resource("ErrorLoadingWorkflowInfo") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
        	}
		}
	}
}
