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
	import com.esri.workflowManager.tasks.supportClasses.QueryFieldInfo;

	public class UniqueValueChartEvent extends AbstractEvent
	{
		public var categorizeByField:QueryFieldInfo;
		public var groupByField:QueryFieldInfo;

        public function UniqueValueChartEvent(categorizeByField:QueryFieldInfo, groupByField:QueryFieldInfo)
        {
            super("uniqueValueChart");
            this.categorizeByField = categorizeByField;
            this.groupByField = groupByField;
        }
	}
}
