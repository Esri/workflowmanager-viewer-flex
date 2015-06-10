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

package com.esri.workflowManager.viewer.controller
{
	import com.esri.workflowManager.viewer.model.Basemap;
	import com.esri.workflowManager.viewer.model.Model;
	
	public class BasemapCommand
	{
        [Listen(properties="basemap")]
		/**
		 * Switches the basemap.
		 */
        public function basemapHandler(basemap:Basemap):void
        {
			var b:Basemap;
			// First hide the old basemap
			for each (b in Model.instance.configModel.basemaps)
			{
				if (b !== basemap)
				{
					b.hide();
				}
			}
			// Then show the new basemap
			for each (b in Model.instance.configModel.basemaps)
			{
				if (b === basemap)
				{
					b.show();
				}
			}
        }
	}
}
