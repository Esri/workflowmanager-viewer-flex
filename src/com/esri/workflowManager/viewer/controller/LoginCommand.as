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
	import com.esri.workflowManager.tasks.supportClasses.JobQueryContainer;
	import com.esri.workflowManager.tasks.supportClasses.UserDetails;
	import com.esri.workflowManager.viewer.events.LoadServiceEvent;
	import com.esri.workflowManager.viewer.model.LoginViewType;
	import com.esri.workflowManager.viewer.model.Model;
	
	import mx.core.FlexGlobals;
	import mx.rpc.AsyncResponder;
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class LoginCommand
	{
		[Listen(properties="username,password")]
		public function loginHandler(username:String, password:String):void
		{
			Model.instance.loginEnabled = false;
			if (Model.instance.configModel.tokenAuthenticationEnabled)
			{
				var appURL:String = FlexGlobals.topLevelApplication.url;
				var tokenService:HTTPService = new HTTPService();
				var tokenServiceURL:String = Model.instance.configModel.tokenServiceURL;
				if (tokenServiceURL.charAt(tokenServiceURL.length - 1) != "/")
				{
					tokenServiceURL += "/";
				}
				tokenService.url = tokenServiceURL + "generateToken";
				var requestParams:Object = new Object();
				requestParams.username = username;
				requestParams.password = password;
				requestParams.expiration = Model.instance.configModel.tokenDuration;
				requestParams.clientid = "ref." + appURL;
				tokenService.request = requestParams;
				tokenService.method = "POST";
				tokenService.addEventListener(ResultEvent.RESULT, tokenResult);
				tokenService.addEventListener(FaultEvent.FAULT, tokenFault);	
				tokenService.send();
			}
			else
			{
				getUserInfo();
			}
			
			function tokenFault(event:FaultEvent):void
			{
				Model.instance.loginError = Model.resource("ErrorAccessDenied");
				Model.instance.loginEnabled = true;
			}
			function tokenResult(event:ResultEvent):void
			{
				var token:String = event.result as String;
				token = token.replace('\n', '').replace('\r', '');
				Model.instance.token = token;
				Model.instance.aoiLayerTask.token = Model.instance.token;
				Model.instance.configTask.token = Model.instance.token;
				Model.instance.jobTask.token = Model.instance.token;
				Model.instance.workflowTask.token = Model.instance.token;
				Model.instance.reportTask.token = Model.instance.token;
				Model.instance.aoiDynamicLayer.token = Model.instance.token;
				getUserInfo();
			}
			function getUserInfo():void
			{
				username = formatDomainUsername(username);
				Model.instance.configTask.getUser(username, new AsyncResponder(onUserResult, onUserFault));
			}
			function onUserResult(userInfo:UserDetails, token:Object=null):void
			{
				Model.instance.currentUserInfo = userInfo;
				Model.instance.privileges.applyUserPrivileges(userInfo);
				CentralDispatcher.dispatchEvent(new LoadServiceEvent());
				
				var userQueries:JobQueryContainer = Model.instance.currentUserInfo.userQueries;
				userQueries.name = Model.resource("UserQueries");
				Model.instance.queryList.addItem(userQueries);
				
				Model.instance.loginViewType = LoginViewType.LOGGED_IN;
				Model.instance.loginError = "";
				Model.instance.loginEnabled = true;
			}
			function onUserFault(fault:Fault, token:Object=null):void
			{
				trace(fault.faultString);
				Model.instance.loginError = Model.resource("ErrorInvalidUser");
				Model.instance.loginEnabled = true;
			}
		}
		
		private function formatDomainUsername(user:String = null):String
		{
			if (user && user.length > 0)
			{
				// replace all occurences of backslash with "*" in the string
				user = user.replace(/\\/g, "*");
			}
			return user;
		}
	}
}
