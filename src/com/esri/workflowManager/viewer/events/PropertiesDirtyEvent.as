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

	public class PropertiesDirtyEvent extends AbstractEvent
	{
		public static const TYPE:String = "propertiesDirty";
		
		public var isDirty:Boolean;
		
        public function PropertiesDirtyEvent(isDirty:Boolean)
        {
            super(TYPE);
            this.isDirty = isDirty;
        }
	}
}
