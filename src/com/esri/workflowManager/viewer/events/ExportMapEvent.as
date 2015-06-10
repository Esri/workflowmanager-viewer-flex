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
	import com.esri.ags.tasks.supportClasses.PrintParameters;

	public class ExportMapEvent extends AbstractEvent
	{
		public var printParameters:PrintParameters;
        
        public function ExportMapEvent(printParameters:PrintParameters)
        {
            super("exportMap");
            this.printParameters = printParameters;
        }
	}
}
