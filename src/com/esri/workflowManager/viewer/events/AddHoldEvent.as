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

	public class AddHoldEvent extends AbstractEvent
	{
		public var jobId:int;
		public var holdTypeId:int;
		public var comments:String;
        
        public function AddHoldEvent(jobId:int, holdTypeId:int, comments:String)
        {
			super("addHold");
			this.jobId = jobId;
			this.holdTypeId = holdTypeId;
			this.comments = comments;
        }
	}
}
