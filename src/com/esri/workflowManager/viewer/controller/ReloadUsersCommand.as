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
	import com.esri.workflowManager.viewer.model.Model;
	
	import mx.controls.Alert;
	import mx.rpc.Responder;
	
	public class ReloadUsersCommand
	{
        [Listen]
		/**
		 * Reloads the user list.
		 */
        public function reloadUsersHandler():void
        {
			Model.instance.configTask.getAllUsers(new Responder(onUsersResult, onUsersFault));
			function onUsersResult(data:Array):void
			{
				Model.instance.users = data;
			}
			function onUsersFault(data:Object):void
			{
				Alert.show(Model.resource("ErrorLoadingUsers") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
			}
		}
	}
}
