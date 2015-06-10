package com.esri.workflowManager.viewer.utils
{
	/**
	 * @private
	 */
	public class URLUtil
	{
		/**
		 * @private
		 * 
		 * Returns the protocol section of the specified URL.
         * The following examples show what is returned based on different URLs:
         *  
         * <pre>
         * getProtocol("https://localhost:2700/") returns "https"
         * getProtocol("rtmp://www.myCompany.com/myMainDirectory/groupChatApp/HelpDesk") returns "rtmp"
         * getProtocol("rtmpt:/sharedWhiteboardApp/June2002") returns "rtmpt"
         * getProtocol("rtmp::1234/chatApp/room_name") returns "rtmp"
         * getProtocol("mailto:myEmail@myCompany.com") returns "mailto"
         * </pre>
         *
         * @param url String containing the URL to parse.
         * @return The protocol or an empty String if no protocol is specified.
		 */
		public static function getProtocol(url:String):String
		{
			var index:int = url.indexOf(":");
			var pattern:RegExp = /^[a-zA-Z]+$/;		// pattern to allow only alpha characters (case insensitive)
			if (index > 0)
			{
				var protocol:String = url.substring(0, index);
				if (pattern.test(protocol))
				{
					return protocol;
				}
			}
			return "";
		}
		
		/**
		 * @private
		 * 
		 * Returns the absolute path to a URL.
		 * 
		 * Checks if the given URL has a protocol specified.  If the protocol is
		 * missing from the URL (e.g. www.esri.com), the default "http://" protocol 
		 * will be prepended to the URL.
		 * 
		 * @param url String containing the URL to check.
         * @return The protocol or an empty String if no protocol is specified.
		 */
		public static function getAbsolutePathURL(url:String):String
		{
			if (!getProtocol(url))
			{
				url = "http://" + url;
			}
			return url;
		}
		
		/*
		// Code from mx.utils.URLUtil.as.  However, this does not work with
		// protocols which do not have a "/" following the colon (e.g. "mailto:")
		wm_internal static function getProtocol(url:String):String
		{
			var slash:int = url.indexOf("/");
			var indx:int = url.indexOf(":/");
			if (indx > -1 && indx < slash)
			{
				return url.substring(0, indx);
			}
			else
			{
				indx = url.indexOf("::");
				if (indx > -1 && indx < slash)
					return url.substring(0, indx);
			}
			
			return "";
		}
		*/
	}
}
