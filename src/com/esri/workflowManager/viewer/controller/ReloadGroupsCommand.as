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
	import com.esri.workflowManager.tasks.supportClasses.WorkflowManagerServiceInfo;
	import com.esri.workflowManager.viewer.model.Model;
	
	import mx.controls.Alert;
	import mx.rpc.Responder;
	
	public class ReloadGroupsCommand
	{
        [Listen]
		/**
		 * Reloads the user group list.
		 */
        public function reloadGroupsHandler():void
        {
			Model.instance.configTask.getAllGroups(new Responder(onGroupsResult, onGroupsFault));
			function onGroupsResult(data:Array):void
			{
				Model.instance.groups = data;
			}
			function onGroupsFault(data:Object):void
			{
				Alert.show(Model.resource("ErrorLoadingGroups") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
			}
		}
	}
}
