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

	public class UpdateJobPropertiesEvent extends AbstractEvent
	{
		public var updateParams:JobUpdateParameters;
		public var extendedProperties:Array;  // of AuxRecordDescription
        
        public function UpdateJobPropertiesEvent(updateParams:JobUpdateParameters, extendedProperties:Array/*of AuxRecordDescription*/)
        {
            super("updateJobProperties");
            this.updateParams = updateParams;
			this.extendedProperties = extendedProperties;
        }
	}
}
