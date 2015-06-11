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

package com.esri.workflowManager.viewer.view.supportClasses
{
	import flash.display.Shape;
	
	import mx.containers.VBox;
	
	/**
	 * @private
	 */
	public class ImageBox extends VBox
	{
		public function ImageBox()
		{
			super();
		}
		
		override public function validateDisplayList():void
		{
			super.validateDisplayList();
			for (var i:int = 0; i < rawChildren.numChildren; i++)
			{
				if (rawChildren.getChildAt(i).name == "whiteBox")
				{
					(rawChildren.getChildAt(i) as Shape).graphics.clear();
					break;
				}
			}
		}	
	}
}
