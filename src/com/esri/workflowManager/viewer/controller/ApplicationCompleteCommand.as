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
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.layers.ArcGISDynamicMapServiceLayer;
	import com.esri.ags.layers.ArcGISImageServiceLayer;
	import com.esri.ags.layers.ArcGISTiledMapServiceLayer;
	import com.esri.ags.layers.ArcIMSMapServiceLayer;
	import com.esri.ags.layers.Layer;
	import com.esri.ags.layers.OpenStreetMapLayer;
	import com.esri.ags.layers.WMSLayer;
	import com.esri.ags.tasks.GeometryService;
	import com.esri.ags.tasks.PrintTask;
	import com.esri.ags.virtualearth.VETiledLayer;
	import com.esri.holistic.CentralDispatcher;
	import com.esri.workflowManager.tasks.WMAOILayerTask;
	import com.esri.workflowManager.tasks.WMConfigurationTask;
	import com.esri.workflowManager.tasks.WMJobTask;
	import com.esri.workflowManager.tasks.WMReportTask;
	import com.esri.workflowManager.tasks.WMTokenTask;
	import com.esri.workflowManager.tasks.WMWorkflowTask;
	import com.esri.workflowManager.tasks.supportClasses.WorkflowManagerAOILayerInfo;
	import com.esri.workflowManager.utils.PrivilegeManager;
	import com.esri.workflowManager.viewer.events.BasemapEvent;
	import com.esri.workflowManager.viewer.events.LoginEvent;
	import com.esri.workflowManager.viewer.model.AuxListValueCache;
	import com.esri.workflowManager.viewer.model.Basemap;
	import com.esri.workflowManager.viewer.model.ChartingModel;
	import com.esri.workflowManager.viewer.model.ConfigModel;
	import com.esri.workflowManager.viewer.model.LoginViewType;
	import com.esri.workflowManager.viewer.model.MenuType;
	import com.esri.workflowManager.viewer.model.Model;
	import com.esri.workflowManager.viewer.model.ViewType;
	import com.esri.workflowManager.viewer.utils.MapUtil;
	import com.esri.workflowManager.viewer.utils.WMUtil;
	
	import flash.system.Security;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class ApplicationCompleteCommand
	{
		private var _configLoaded:Boolean = false;
		
        [Listen]
		/**
		 * Sets the defaults and loads the config file.
		 */
        public function applicationCompleteHandler():void
        {
        	setDefaults();
			
			// Only load the configuration once
			if (!_configLoaded)
			{
	        	loadConfig();
				_configLoaded = true;
			}
			else
			{
				// Reset the map state
				if (Model.instance.configModel.initialExtent)
				{
					Model.instance.map.extent = Model.instance.configModel.initialExtent;
				}
				for each (var basemap:Basemap in Model.instance.configModel.basemaps)
				{
					if (basemap.isInitialBasemap)
					{
						CentralDispatcher.dispatchEvent(new BasemapEvent(basemap));
						break;
					}
				}
				Model.instance.aoiDynamicLayerDefinitions = MapUtil.formatLayerDefinitions([
					MapUtil.layerDefinition(Model.instance.configModel.aoiMapServiceLayerId, "1=0")
				]);
				
				Model.instance.loginEnabled = true;
			}
        }
        
		/**
		 * Resets the Model properties to their default values. This is required to clear out 
		 * the properties when a user logs out and logs back in as the same or different 
		 * user. The application needs to return to the default startup state. 
		 */
        private function setDefaults():void
        {
			Model.instance.chartingModel = new ChartingModel();
			Model.instance.listValueCache = new AuxListValueCache();

			Model.instance.loginError = "";
			Model.instance.loginEnabled = false;

			Model.instance.token = null;

			Model.instance.isWorkflowLoading = false;
			Model.instance.isStepExecuting = false;
			Model.instance.isMarkingStepAsDone = false;
			Model.instance.isPropertiesDirty = false;

			Model.instance.loginViewType = LoginViewType.LOGGED_OUT;
			Model.instance.viewType = ViewType.AOI;
			Model.instance.menuType = MenuType.QUERIES;
			Model.instance.jobTableTitle = "";

			Model.instance.currentUserInfo = null;
			Model.instance.privileges = new PrivilegeManager();
			
			Model.instance.serviceInfo = null;
			Model.instance.autoCloseJob = false;
			Model.instance.autoStatusAssign = false;
			Model.instance.commentActivityId = 0;
			Model.instance.jobIdField = null;
			Model.instance.queryList = new ArrayCollection();
			Model.instance.reportList = null;
			Model.instance.users = null;
			Model.instance.groups = null;
			Model.instance.lastJobSearch = null;
			Model.instance.jobList = null;
			Model.instance.queryResultFields = null;
			
			Model.instance.isSelectedJobOnHold = false;
			Model.instance.selectedJob = null;
			Model.instance.workflowImageSource = null;
			Model.instance.selectedJobCurrentSteps = null;
			Model.instance.selectedJobDisplaySteps = null;
			Model.instance.selectedJobDisplayPaths = null;
			Model.instance.selectedGraphic = null;
			Model.instance.selectedJobHistory = null;
			Model.instance.selectedJobHolds = null;
			Model.instance.selectedJobNotes = null;
			Model.instance.selectedJobAttachments = null;
			Model.instance.selectedJobExtendedProperties = null;
			Model.instance.selectedJobRelationships = null;
			Model.instance.selectedJobRelationshipItem = null;
        }
        
		/**
		 * Loads the config file.
		 */		
        private function loadConfig():void
        {
			var configService:HTTPService = new HTTPService();
			configService.url = "config.xml";
			configService.resultFormat = "e4x";
			configService.addEventListener(ResultEvent.RESULT, configResult);
			configService.addEventListener(FaultEvent.FAULT, configFault);	
			configService.send();
		}
		
		/**
		 * Fault handler for loading config file.
		 */
		private function configFault(event:FaultEvent):void
		{
			Alert.show(Model.resource("ErrorLoadingConfig") + "\n\n" + event.fault, Model.resource("ErrorTitle"));
		}
		
		/**
		 * Result handler for loading config file. Sets the Model parameters 
		 * based on config properties.
		 */		
		private function configResult(event:ResultEvent):void
		{
			const configXML:XML = event.result as XML;
			const config:ConfigModel = Model.instance.configModel;
			
			config.jobPropertiesDateFormat = configXML.dateFormats.jobPropertiesDateFormat;
			config.jobHistoryDateFormat = configXML.dateFormats.jobHistoryDateFormat;
			config.jobHoldDateFormat = configXML.dateFormats.jobHoldDateFormat;
			
			var xmin:Number = configXML.initialExtent.xmin;
			var ymin:Number = configXML.initialExtent.ymin;
			var xmax:Number = configXML.initialExtent.xmax;
			var ymax:Number = configXML.initialExtent.ymax;
			if (!isNaN(xmin) && !isNaN(ymin) && !isNaN(xmax) && !isNaN(ymax)
				&& !(xmin == 0 && ymin == 0 && xmax == 0 && ymax == 0))
			{
				config.initialExtent = new Extent(xmin, ymin, xmax, ymax/*, new SpatialReference(102100)*/);
			}
			
			config.geometryServiceURL = configXML.geometryService.url;
			config.printServiceURL = configXML.printService.url;
			config.workflowServiceURL = configXML.workflowService.url;
			config.aoiMapServiceURL = configXML.aoiMapService.url;
			config.aoiMapServiceLayerId = Number(configXML.aoiMapService.aoiLayerId) || 0;
			config.aoiMapServiceQueryLayer = config.aoiMapServiceURL + "/" + config.aoiMapServiceLayerId;
			var aoiVisibleLayers:String = configXML.aoiMapService.visibleLayers;
			if (aoiVisibleLayers && aoiVisibleLayers.length > 0)
			{
				config.aoiMapServiceVisibleLayers = MapUtil.parseLayerList(aoiVisibleLayers);
			}
			var aoiAlpha:String = configXML.aoiMapService.alpha;
			if (aoiAlpha && aoiAlpha.length > 0)
			{
				config.aoiMapServiceAlpha = Number(aoiAlpha);
			}
			Model.instance.aoiDynamicLayerDefinitions = MapUtil.formatLayerDefinitions([
				MapUtil.layerDefinition(config.aoiMapServiceLayerId, "1=0")
			]);
			
			var basemaps:Array = [];
			var basemapsXML:XML = configXML.basemaps[0];
			var initialBasemap:String = basemapsXML.@initial;
			for each (var basemapXML:XML in basemapsXML.basemap)
			{
				var basemap:Basemap = new Basemap();
				basemap.label = basemapXML.@label || "";
				basemap.isInitialBasemap = (initialBasemap == basemap.label);
				for each (var layerXML:XML in basemapXML.layer)
				{
					var mapLayer:Layer = createMapLayer(layerXML, configXML);
					if (mapLayer)
					{
						basemap.layers.push(mapLayer);
					}
				}
				basemaps.push(basemap);
			}
			config.basemaps = basemaps;
			
			config.initialUsername = configXML.authentication.defaultUsername;
			config.autoLogin = (configXML.authentication.autoLogin == "true");
			
			// Support for Windows authentication, username passed in from HTML wrapper
			var params:Object = FlexGlobals.topLevelApplication.parameters;
			if (params)
			{
				var externalUser:String = params["user"];
				if (WMUtil.isSet(externalUser))
				{
					// Strip off the Windows domain from the username
					var userParts:Array = externalUser.split("\\");
					config.initialUsername = userParts[userParts.length - 1];
					//config.initialUsername = externalUser;
					config.autoLogin = true;
				}
			}
			
			// Support for ArcGIS token authentication, username and password entered manually
			config.tokenAuthenticationEnabled = (configXML.authentication.tokenAuthentication.enabled == "true");
			if (config.tokenAuthenticationEnabled)
			{
				config.tokenServiceURL = configXML.authentication.tokenAuthentication.url;
				config.tokenDuration = configXML.authentication.tokenAuthentication.tokenDuration;
				
				// The remote security model is required for token authentication to work properly
				if (Security.sandboxType != Security.REMOTE)
				{
					Model.instance.loginEnabled = false;
					Alert.show(Model.resource("ErrorRemoteSandbox"), Model.resource("ErrorTitle"));
					return;
				}
			}
			
			Model.instance.geometryService = new GeometryService(config.geometryServiceURL);
			Model.instance.geometryService.showBusyCursor = true;
			Model.instance.printTask = new PrintTask(config.printServiceURL);
			Model.instance.printTask.showBusyCursor = true;

			Model.instance.aoiLayerTask = new WMAOILayerTask(config.aoiMapServiceQueryLayer);
			Model.instance.aoiLayerTask.showBusyCursor = true;
			Model.instance.configTask = new WMConfigurationTask(config.workflowServiceURL);
			Model.instance.configTask.showBusyCursor = true;
			Model.instance.jobTask = new WMJobTask(config.workflowServiceURL);
			Model.instance.jobTask.showBusyCursor = true;
			Model.instance.workflowTask = new WMWorkflowTask(config.workflowServiceURL);
			Model.instance.workflowTask.showBusyCursor = true;
			Model.instance.reportTask = new WMReportTask(config.workflowServiceURL);
			Model.instance.reportTask.showBusyCursor = true;
			Model.instance.tokenTask = new WMTokenTask(config.workflowServiceURL);
			Model.instance.tokenTask.showBusyCursor = true;
			
			if (config.autoLogin 
				&& !config.tokenAuthenticationEnabled 
				&& config.initialUsername
				&& config.initialUsername.length > 0 )
			{
				CentralDispatcher.dispatchEvent(new LoginEvent(config.initialUsername, ""));
			}
			else
			{
				Model.instance.loginEnabled = true;
			}
		}
		
		private function createMapLayer(layerXML:XML, configXML:XML):Layer
		{
			var layer:Layer;
			
			var proxyURL:String = null;
			if (layerXML.@useproxy == "true")
			{
				proxyURL = configXML.httpproxy;
			}
			
			var token:String = layerXML.@token || null;
			var url:String = layerXML.@url || "";
			var serviceHost:String = layerXML.@servicehost || "";
			var serviceName:String = layerXML.@servicename || "";
			var mapStyle:String = layerXML.@style || "road";
			var culture:String = layerXML.@culture || "en-US";
			var visibleLayers:String = layerXML.@visiblelayers || null;
			
			var layerType:String = layerXML.@type || "";
			layerType = layerType.toLowerCase();
			if (layerType == "tiled")
			{
				layer = new ArcGISTiledMapServiceLayer(url, proxyURL, token);
			}
			else if (layerType == "dynamic")
			{
				layer = new ArcGISDynamicMapServiceLayer(url, proxyURL, token);
				if (visibleLayers && visibleLayers.length > 0)
				{
					ArcGISDynamicMapServiceLayer(layer).visibleLayers = MapUtil.parseLayerList(visibleLayers, true);
				}
			}
			else if (layerType == "image")
			{
				layer = new ArcGISImageServiceLayer(url, proxyURL, token);
			}
			else if (layerType == "arcims")
			{
				layer = new ArcIMSMapServiceLayer(serviceHost, serviceName, proxyURL);
				if (visibleLayers && visibleLayers.length > 0)
				{
					ArcIMSMapServiceLayer(layer).visibleLayers = MapUtil.parseLayerList(visibleLayers, false);
				}
			}
			else if (layerType == "bing")
			{
				layer = new VETiledLayer(culture, mapStyle);
				VETiledLayer(layer).key = configXML.bing.@key;
			}
			else if (layerType == "wms")
			{
				layer = new WMSLayer(url, proxyURL);
				if (visibleLayers && visibleLayers.length > 0)
				{
					WMSLayer(layer).visibleLayers = MapUtil.parseLayerList(visibleLayers, false);
				}
			}
			else if (layerType == "openstreetmap")
			{
				layer = new OpenStreetMapLayer();
			}
			else
			{
				Alert.show(Model.resource("ErrorInvalidMapLayerType", [layerType]), Model.resource("ErrorTitle"));
				return null;
			}
			
			layer.visible = false;
			
			var alpha:String = layerXML.@alpha;
			if (alpha && alpha.length > 0)
			{
				layer.alpha = Number(alpha);
			}
			
			return layer;
		}
	}
}
