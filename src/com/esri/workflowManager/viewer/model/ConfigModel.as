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
	import com.esri.ags.geometry.Extent;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public final class ConfigModel
	{
		public var jobPropertiesDateFormat:String;
		public var jobHistoryDateFormat:String;
		public var jobHoldDateFormat:String;
		
		public var initialExtent:Extent;
		public var basemaps:Array;  // of Basemap
		
		public var geometryServiceURL:String;
		public var printServiceURL:String;
		public var workflowServiceURL:String;
		
		public var aoiMapServiceURL:String;
		public var aoiMapServiceLayerId:int = 0;
		public var aoiMapServiceQueryLayer:String;
		public var aoiMapServiceJobIdField:String;
		public var aoiMapServiceVisibleLayers:ArrayCollection;
		public var aoiMapServiceAlpha:Number = 0.75;
		
		public var initialUsername:String;
		public var autoLogin:Boolean = false;
		public var tokenAuthenticationEnabled:Boolean = false;
		public var tokenServiceURL:String;
		public var tokenDuration:int;

		public function ConfigModel()
		{
		}
	}
}
