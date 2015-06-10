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
	import com.esri.workflowManager.viewer.events.ApplicationCompleteEvent;
	import com.esri.workflowManager.viewer.model.LoginViewType;
	import com.esri.workflowManager.viewer.model.Model;
	
	public class LogoutCommand
	{
        [Listen]
        public function logoutHandler():void
        {
    		CentralDispatcher.dispatchEvent(new ApplicationCompleteEvent());
    		Model.instance.loginViewType = LoginViewType.LOGGED_OUT;
        }
	}
}
