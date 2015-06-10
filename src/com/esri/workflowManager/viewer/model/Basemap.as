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

package com.esri.workflowManager.viewer.model
{
	import com.esri.ags.layers.Layer;
	import com.esri.ags.layers.OpenStreetMapLayer;
	
	public class Basemap
	{
		public var label:String;
		public var isInitialBasemap:Boolean = false;
		public var layers:Array = [];  // of Layer
		
		public function Basemap()
		{
		}
		
		public function show():void
		{
			for each (var layer:Layer in layers)
			{
				layer.visible = true;
				if(layer is OpenStreetMapLayer)
				{
					Model.instance.isOSMBasemap = true;
				}
			}
		}
		
		public function hide():void
		{
			for each (var layer:Layer in layers)
			{
				layer.visible = false;
				if(layer is OpenStreetMapLayer)
				{
					Model.instance.isOSMBasemap = false;
				}
			}
		}
	}
}
