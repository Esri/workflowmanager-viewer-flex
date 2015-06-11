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

package com.esri.workflowManager.viewer.model
{
	import com.esri.ags.Graphic;
	import com.esri.ags.Map;
	import com.esri.ags.layers.ArcGISDynamicMapServiceLayer;
	import com.esri.ags.tasks.GeometryService;
	import com.esri.ags.tasks.PrintTask;
	import com.esri.workflowManager.tasks.WMAOILayerTask;
	import com.esri.workflowManager.tasks.WMConfigurationTask;
	import com.esri.workflowManager.tasks.WMJobTask;
	import com.esri.workflowManager.tasks.WMReportTask;
	import com.esri.workflowManager.tasks.WMTokenTask;
	import com.esri.workflowManager.tasks.WMWorkflowTask;
	import com.esri.workflowManager.tasks.supportClasses.JobInfo;
	import com.esri.workflowManager.tasks.supportClasses.UserDetails;
	import com.esri.workflowManager.tasks.supportClasses.WorkflowManagerServiceInfo;
	import com.esri.workflowManager.utils.PrivilegeManager;
	
	import mx.collections.ArrayCollection;
	import mx.resources.ResourceManager;

	[Bindable]
    public final class Model
    {
		// Model singleton
		private static var _created:Boolean = false;
        public static const instance:Model = new Model();
        
		public var configModel:ConfigModel = new ConfigModel();
		public var chartingModel:ChartingModel = new ChartingModel();
		public var listValueCache:AuxListValueCache = new AuxListValueCache();
		
		public var loginError:String = "";
		public var loginEnabled:Boolean = true;
		public var token:String;
		
		public var map:Map;
		public var aoiDynamicLayer:ArcGISDynamicMapServiceLayer;
		public var aoiDynamicLayerDefinitions:Array;
		public var isOSMBasemap:Boolean = false;
		
		// tasks
		public var aoiLayerTask:WMAOILayerTask;
		public var configTask:WMConfigurationTask;
		public var jobTask:WMJobTask;
		public var workflowTask:WMWorkflowTask;
		public var reportTask:WMReportTask;
		public var tokenTask:WMTokenTask;
		public var geometryService:GeometryService;
		public var printTask:PrintTask;
		
		public var isWorkflowLoading:Boolean = false;
		public var isStepExecuting:Boolean = false;
		public var isMarkingStepAsDone:Boolean = false;
		public var isPropertiesDirty:Boolean = false;
		
		public var loginViewType:int = LoginViewType.LOGGED_OUT;
		public var viewType:int = ViewType.AOI;
		public var menuType:int = MenuType.QUERIES;
		public var jobTableTitle:String = "";

		public var currentUserInfo:UserDetails;
		public var privileges:PrivilegeManager = new PrivilegeManager();
		
		public var serviceInfo:WorkflowManagerServiceInfo;
		public var autoCloseJob:Boolean;
		public var autoStatusAssign:Boolean;
		public var commentActivityId:int;
		public var jobIdField:String;
		public var queryList:ArrayCollection = new ArrayCollection();
		public var reportList:Array; // of Report
		public var users:Array; // of UserInfo
		public var groups:Array; // of GroupInfo
		public var lastJobSearch:JobSearch;
		public var jobList:ArrayCollection;
		public var queryResultFields:Array;
		public var dataWorkspaceDetails:Array;

		public var isSelectedJobOnHold:Boolean;
		public var selectedJob:JobInfo;
		public var workflowImageSource:Object;
		public var selectedJobCurrentSteps:Array;
		public var selectedJobDisplaySteps:Array;
		public var selectedJobDisplayPaths:Array;
		public var selectedGraphic:Graphic;
		public var selectedJobHistory:ArrayCollection;
		public var selectedJobHolds:ArrayCollection;
		public var selectedJobNotes:String;
		public var selectedJobAttachments:Array;
		public var selectedJobExtendedProperties:ArrayCollection; // of AuxRecordContainer
		public var selectedJobRelationships:ArrayCollection; // of JobRelation
		public var selectedJobRelationshipItem:JobRelation;
		public var selectedJobVersion:Array;
		public var selectedJobParentVersion:Array;
		
		//----------------------------------------------------------------------
		//  Resource Management
		//----------------------------------------------------------------------
		
		public static const RESOURCE_BUNDLE:String = "WMResources";
		
		/**
		 * Returns a string resource from the application's default resource bundle.
		 */
		public static function resource(resourceName:String, parameters:Array = null):String
		{
			return ResourceManager.getInstance().getString(RESOURCE_BUNDLE, resourceName, parameters);
		}
		
		//----------------------------------------------------------------------
		//  Constructor
		//----------------------------------------------------------------------
		
        public function Model()        
        {
            if (_created)
            {
                throw new Error("Model instance already created");
            }
            _created = true;
        }
    }
}
