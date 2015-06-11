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
	import com.esri.workflowManager.tasks.supportClasses.JobCreationParameters;

	public class CreateJobEvent extends AbstractEvent
	{
		public var createParams:JobCreationParameters;
		public var prefix:String;
		public var suffix:String;
        
        public function CreateJobEvent(createParams:JobCreationParameters, prefix:String, suffix:String)
        {
            super("createJob");
            this.createParams = createParams;
			this.prefix = prefix;
			this.suffix = suffix;
        }
	}
}
