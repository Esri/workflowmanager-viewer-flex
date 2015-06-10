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
	import com.esri.workflowManager.tasks.supportClasses.WorkflowOption;

	public class ResolveConflictEvent extends AbstractEvent
	{
		public var jobID:int;
		public var stepID:int;
		public var workflowOption:WorkflowOption;
        
        public function ResolveConflictEvent(jobID:int, stepID:int, workflowOption:WorkflowOption)
        {
            super("resolveConflict");
            this.jobID = jobID;
            this.stepID = stepID;
            this.workflowOption = workflowOption;
        }
	}
}
