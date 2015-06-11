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
	import com.esri.holistic.CentralDispatcher;
	import com.esri.workflowManager.tasks.supportClasses.ActivityType;
	import com.esri.workflowManager.tasks.supportClasses.DataWorkspace;
	import com.esri.workflowManager.tasks.supportClasses.DataWorkspaceDetails;
	import com.esri.workflowManager.tasks.supportClasses.WorkflowManagerAOILayerInfo;
	import com.esri.workflowManager.tasks.supportClasses.WorkflowManagerServiceInfo;
	import com.esri.workflowManager.viewer.model.Model;
	
	import mx.controls.Alert;
	import mx.rpc.Responder;
	
	public class LoadServiceCommand
	{
        [Listen]
		/**
		 * Loads the Workflow Manager service description.
		 */
        public function loadServiceHandler():void
        {
        	Model.instance.configTask.getServiceInfo(new Responder(onServiceInfoResult, onServiceInfoFault));
			
        	function onServiceInfoResult(serviceInfo:WorkflowManagerServiceInfo):void
			{
				Model.instance.serviceInfo = serviceInfo;
				
				// sort job priorities by value
				if (Model.instance.serviceInfo && Model.instance.serviceInfo.jobPriorities)
				{
					Model.instance.serviceInfo.jobPriorities.sortOn("value", Array.NUMERIC);
				}
				
				Model.instance.autoCloseJob = (serviceInfo.configProperties["AUTOCLOSEJOB"] == "TRUE");
				Model.instance.autoStatusAssign = (serviceInfo.configProperties["AUTOSTATUSASSIGN"] == "TRUE");
				
				Model.instance.queryList.addItemAt(serviceInfo.publicQueries, 0);
				CentralDispatcher.dispatch("publicQueriesAvailable");
				
				for each (var activityType:ActivityType in serviceInfo.activityTypes)
				{
					if (activityType.name == "Comment")
					{
						Model.instance.commentActivityId = activityType.id;
						break;
					}
				}
				
				// Load additional resources
				intializeJobID();
	        	loadUsers();
			}
			function onServiceInfoFault(data:Object, token:Object=null):void
			{
				Alert.show(Model.resource("ErrorLoadingServiceInfo") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
			}        
		}
        
        private function loadUsers():void
        {
        	Model.instance.configTask.getAllUsers(new Responder(onUsersResult, onUsersFault));
        	function onUsersResult(data:Array):void
        	{
        		Model.instance.users = data;
				loadGroups();
        	}
        	function onUsersFault(data:Object):void
        	{
				Alert.show(Model.resource("ErrorLoadingUsers") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
				loadGroups();
        	}
        }
        
        private function loadGroups():void
        {
        	Model.instance.configTask.getAllGroups(new Responder(onGroupsResult, onGroupsFault));
        	function onGroupsResult(data:Array):void
        	{
        		Model.instance.groups = data;
				loadReports();
        	}
        	function onGroupsFault(data:Object):void
        	{
				Alert.show(Model.resource("ErrorLoadingGroups") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
				loadReports();
        	}
        }

        private function loadReports():void
        {
        	Model.instance.reportTask.getAllReports(new Responder(onReportsResult, onReportsFault));
        	function onReportsResult(data:Array):void
        	{
        		Model.instance.reportList = data;
				loadDataWorkspaces();
        	}
        	function onReportsFault(data:Object):void
        	{
				Alert.show(Model.resource("ErrorLoadingReports") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
				loadDataWorkspaces();
        	}
        }
		
		private function loadDataWorkspaces():void
		{
			Model.instance.dataWorkspaceDetails = [];
			for each (var dataWorksapce:DataWorkspace in Model.instance.serviceInfo.dataWorkspaces)
			{
				Model.instance.configTask.getDataWorkspaceDetails(dataWorksapce.id, 
					Model.instance.currentUserInfo.userName, 
					new Responder(onVersionsResult, onVersionsFault));			
			}	
			function onVersionsResult(data:DataWorkspaceDetails):void
			{				
				Model.instance.dataWorkspaceDetails.push(data);
			}
			function onVersionsFault(data:Object):void
			{
				// Suppress any errors on the UI.  Errors will be logged to server.
				//Alert.show(Model.resource("ErrorLoadingDataWorkspace") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
			}
		}
		
		private function intializeJobID():void
		{
			Model.instance.aoiLayerTask.getServiceInfo(new Responder(aoiLayerInfoResult, aoiLayerInfoFault));
			function aoiLayerInfoResult(aoiLayerInfo:WorkflowManagerAOILayerInfo):void
			{
				if (aoiLayerInfo.jobIdField == null || aoiLayerInfo.jobIdField == "")
					Alert.show(Model.resource("ErrorLoadingJobIdField") + "\n\n" + Model.resource("ErrorQueryAOILayer"), 
						Model.resource("ErrorTitle"));
				else
					Model.instance.configModel.aoiMapServiceJobIdField = aoiLayerInfo.jobIdField;
			}
			function aoiLayerInfoFault(data:Object, token:Object=null):void
			{
				Alert.show(Model.resource("ErrorLoadingJobIdField") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
			}   
		}
	}
}
