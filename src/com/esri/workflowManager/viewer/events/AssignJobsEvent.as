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
	
	public class AssignJobsEvent extends AbstractEvent
	{
		public var jobIDs:Array;
		public var assignedType:int;
		public var assignedTo:String;
		
		public function AssignJobsEvent(jobIDs:Array, assignedType:int, assignedTo:String)
		{
			super("assignJobs");
			this.jobIDs = jobIDs;
			this.assignedType = assignedType;
			this.assignedTo = assignedTo;
		}
	}
}
