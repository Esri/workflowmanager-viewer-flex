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
	import com.esri.ags.geometry.MapPoint;
	import com.esri.holistic.AbstractEvent;

	public class AOIMapClickEvent extends AbstractEvent
	{
		public var mapPoint:MapPoint;
		
        public function AOIMapClickEvent(mapPoint:MapPoint)
        {
            super("aoiMapClick");
            this.mapPoint = mapPoint;
        }
	}
}
