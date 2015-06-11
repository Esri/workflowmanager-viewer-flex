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

	public class SelectedJobAttachmentsEvent extends AbstractEvent
	{
		public var jobID:int;
        
        public function SelectedJobAttachmentsEvent(jobID:int)
        {
            super("selectedJobAttachments");
            this.jobID = jobID;
        }
	}
}
