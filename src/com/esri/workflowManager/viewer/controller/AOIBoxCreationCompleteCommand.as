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
	import com.esri.ags.Map;
	import com.esri.ags.layers.ArcGISDynamicMapServiceLayer;
	import com.esri.workflowManager.viewer.model.Model;
	
	public class AOIBoxCreationCompleteCommand
	{
        [Listen(properties="map,aoiDynamicLayer")]
		/**
		 * Sets the map and AOI dynamic layer in the Model for future use.
		 */
        public function aoiBoxCreationCompleteHandler(map:Map, aoiDynamicLayer:ArcGISDynamicMapServiceLayer):void
        {
			Model.instance.map = map;
			Model.instance.aoiDynamicLayer = aoiDynamicLayer;
        }
	}
}
