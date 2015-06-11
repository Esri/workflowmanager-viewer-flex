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
	import com.esri.workflowManager.tasks.supportClasses.JobUpdateParameters;

	public class UpdateJobAOIEvent extends AbstractEvent
	{
		public var updateParams:JobUpdateParameters;
        
        public function UpdateJobAOIEvent(updateParams:JobUpdateParameters)
        {
            super("updateJobAOI");
            this.updateParams = updateParams;
        }
	}
}
