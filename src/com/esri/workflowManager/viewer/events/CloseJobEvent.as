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
	
	public class CloseJobEvent extends AbstractEvent
	{
		public var jobID:int;
		public var isBulkOperation:Boolean;
        
        public function CloseJobEvent(jobID:int, isBulkOperation:Boolean = false)
        {
            super("closeJob");
            this.jobID = jobID;
			this.isBulkOperation = isBulkOperation;
        }
	}
}
