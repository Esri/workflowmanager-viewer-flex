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
	import com.esri.holistic.AbstractEvent;

	public class ViewEvent extends AbstractEvent
	{
		public var viewType:int;
		
        public function ViewEvent(viewType:int)
        {
            super("view");
            this.viewType = viewType;
        }
	}
}
