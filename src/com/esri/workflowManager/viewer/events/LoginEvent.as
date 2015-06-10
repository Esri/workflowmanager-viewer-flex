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

package com.esri.workflowManager.viewer.events
{
	import com.esri.holistic.AbstractEvent;

	public class LoginEvent extends AbstractEvent
	{
		public var username:String;
		public var password:String;
		
        public function LoginEvent(username:String, password:String)
        {
            super("login");
            this.username = username;
            this.password = password;
        }
	}
}
