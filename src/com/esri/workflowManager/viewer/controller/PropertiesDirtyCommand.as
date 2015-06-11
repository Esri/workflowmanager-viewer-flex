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

package com.esri.workflowManager.viewer.controller
{
	import com.esri.workflowManager.viewer.model.Model;
	
	public class PropertiesDirtyCommand
	{
        [Listen(properties="isDirty")]
        public function propertiesDirtyHandler(isDirty:Boolean):void
        {
			Model.instance.isPropertiesDirty = isDirty;
        }
	}
}
