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

	public class LogActivityEvent extends AbstractEvent
	{
		public var jobId:int;
		public var comments:String;
        
        public function LogActivityEvent(jobId:int, comments:String)
        {
            super("logActivity");
            this.jobId = jobId;
            this.comments = comments;
        }
	}
}
