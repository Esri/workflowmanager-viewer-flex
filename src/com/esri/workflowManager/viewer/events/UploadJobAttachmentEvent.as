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
	import flash.net.*;
	import com.esri.holistic.AbstractEvent;

	public class UploadJobAttachmentEvent extends AbstractEvent
	{
		public var jobId:int;
		public var file:FileReference;
        
        public function UploadJobAttachmentEvent(jobId:int, file:FileReference)
        {
            super("uploadJobAttachment");
            this.jobId = jobId;
            this.file = file;
        }
	}
}
