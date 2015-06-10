////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2014 ESRI
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
	
	public class ReopenClosedJobsEvent extends AbstractEvent
	{
		public var jobIDs:Array;
		
		public function ReopenClosedJobsEvent(jobIDs:Array)
		{
			super("reopenClosedJobs");
			this.jobIDs = jobIDs;
		}
	}
}
