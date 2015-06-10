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
	
	public class ListValuesLoadedEvent extends AbstractEvent
	{
		public static const TYPE:String = "listValuesLoaded";
		
		public var tableName:String;
		public var fieldName:String;
		public var values:Array;
        
        public function ListValuesLoadedEvent(tableName:String, fieldName:String, values:Array)
        {
            super(TYPE);
            this.tableName = tableName;
			this.fieldName = fieldName;
			this.values = values;
        }
	}
}
