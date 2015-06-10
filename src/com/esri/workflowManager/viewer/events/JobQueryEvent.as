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
	import com.esri.workflowManager.viewer.model.JobSearch;

	public class JobQueryEvent extends AbstractEvent
	{
		public var queryName:String;
		public var queryParams:JobSearch;
        
        public function JobQueryEvent(queryName:String, queryParams:JobSearch)
        {
            super("jobQuery");
			this.queryName = queryName;
            this.queryParams = queryParams;
        }
	}
}
