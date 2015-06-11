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
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	import com.esri.holistic.CentralDispatcher;
	import com.esri.workflowManager.viewer.events.SelectJobEvent;
	import com.esri.workflowManager.viewer.model.Model;
	import com.esri.workflowManager.viewer.view.InfoWindowRenderer;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;
	
	public class AOIMapClickCommand
	{
        [Listen(properties="mapPoint")]
		/**
		 * Triggers when the map is clicked. A query is run to match the clicked map point, and 
		 * results are returned. If one result is found, the corresponding job is selected and the map 
		 * zooms to that AOI. If more than one result is found, an info window is displayed with 
		 * the job IDs of the jobs found. The user can then select the job ID from there.
		 */
        public function aoiMapClickHandler(mapPoint:MapPoint):void
        {
        	var jobIds:Array = [];
        	for each (var jobObject:Object in Model.instance.jobList)
        	{
        		jobIds.push(jobObject[Model.instance.jobIdField]);
        	}
        	if (jobIds.length == 0)
        	{
        		return;
        	}

        	var queryTask:QueryTask = new QueryTask(Model.instance.configModel.aoiMapServiceQueryLayer);
        	if (Model.instance.configModel.tokenAuthenticationEnabled)
        	{
        		queryTask.token = Model.instance.token;
        	}
        	queryTask.disableClientCaching = true;
			queryTask.showBusyCursor = true;
        	var query:Query = new Query();
        	query.outFields = [Model.instance.configModel.aoiMapServiceJobIdField];
        	query.geometry = mapPoint;
        	query.returnGeometry = false;
        	query.where = Model.instance.configModel.aoiMapServiceJobIdField + " IN (" + jobIds.join(",") + ")"
        	query.outSpatialReference = Model.instance.map.spatialReference;
        	queryTask.execute(query, new AsyncResponder(onResult, onFault));
			
        	function onResult(featureSet:FeatureSet, token:Object = null):void
        	{
       			var graphic:Graphic;
        		if (featureSet.features.length == 1)
        		{
					Model.instance.map.infoWindow.hide();
        			graphic = featureSet.features[0] as Graphic;
        			if (graphic.attributes[Model.instance.configModel.aoiMapServiceJobIdField])
        			{
        				CentralDispatcher.dispatchEvent(new SelectJobEvent(graphic.attributes[Model.instance.configModel.aoiMapServiceJobIdField]));
        			}
        		}
        		else if (featureSet.features.length > 1)
        		{
        			var resultIds:Array = [];
        			for each (graphic in featureSet.features)
        			{
        				if (graphic.attributes[Model.instance.configModel.aoiMapServiceJobIdField])
        				{
	        				resultIds.push(graphic.attributes[Model.instance.configModel.aoiMapServiceJobIdField]);
	        			}
        			}
		        	var infoWindowContent:InfoWindowRenderer = new InfoWindowRenderer();
		        	infoWindowContent.jobs = resultIds;
		        	Model.instance.map.infoWindowContent = infoWindowContent;
		        	Model.instance.map.infoWindow.show(mapPoint);
        		}
        	}   
        	function onFault(info:Object, token:Object = null):void                
        	{                    
				Alert.show(Model.resource("ErrorQueryAOILayer") + "\n\n" + info.toString(), Model.resource("ErrorTitle"));
        	}
        }
	}
}
