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

	public class AddLinkedFileAttachmentEvent extends AbstractEvent
	{
		public var jobId:int;
		public var filePath:String;
		
        public function AddLinkedFileAttachmentEvent(jobId:int, filePath:String)
        {
            super("addLinkedFileAttachment");
            this.jobId = jobId;
			this.filePath = filePath;
        }
	}
}
