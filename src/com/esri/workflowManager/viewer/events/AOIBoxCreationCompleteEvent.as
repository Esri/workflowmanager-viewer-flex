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

package com.esri.workflowManager.viewer.events
{
	import com.esri.ags.Map;
	import com.esri.ags.layers.ArcGISDynamicMapServiceLayer;
	import com.esri.holistic.AbstractEvent;

	public class AOIBoxCreationCompleteEvent extends AbstractEvent
	{
		public var map:Map;
		public var aoiDynamicLayer:ArcGISDynamicMapServiceLayer;
		
		public function AOIBoxCreationCompleteEvent(map:Map, aoiDynamicLayer:ArcGISDynamicMapServiceLayer)
        {
            super("aoiBoxCreationComplete");
			this.map = map;
			this.aoiDynamicLayer = aoiDynamicLayer;
        }
	}
}
