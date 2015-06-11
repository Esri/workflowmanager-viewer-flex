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
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	import com.esri.workflowManager.viewer.model.Model;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;

	public class SelectedJobAOICommand
	{
		[Listen(properties="jobID")]
        public function selectedJobAOIHandler(jobID:int):void
        {
        	Model.instance.selectedGraphic = null;
        	var queryTask:QueryTask = new QueryTask(Model.instance.configModel.aoiMapServiceQueryLayer);
        	if (Model.instance.configModel.tokenAuthenticationEnabled)
        	{
        		queryTask.token = Model.instance.token;
        	}
        	queryTask.disableClientCaching = true;
			queryTask.showBusyCursor = true;
        	var query:Query = new Query();
        	query.returnGeometry = true;
        	query.where = Model.instance.configModel.aoiMapServiceJobIdField + "=" + jobID;
        	query.outSpatialReference = Model.instance.map.spatialReference;
        	queryTask.execute(query, new AsyncResponder(onResult, onFault));
			
        	function onResult(featureSet:FeatureSet, token:Object = null):void
        	{
        		if (featureSet.features.length > 0 && (featureSet.features[0] as Graphic).geometry != null)
        		{
		        	Model.instance.selectedGraphic = featureSet.features[0];
					Model.instance.map.extent = Model.instance.selectedGraphic.geometry.extent.expand(2);
		        }
        	}   
        	function onFault(info:Object, token:Object = null):void                
        	{                    
				Alert.show(Model.resource("ErrorLoadingJobAOI") + "\n\n" + info.toString(), Model.resource("ErrorTitle"));
        	}
        }
	}
}
