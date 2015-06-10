package com.esri.workflowManager.viewer.view.supportClasses
{
	import mx.containers.VBox;
	import mx.core.UIComponent;
	
	public class BaseJobView extends VBox
	{
		public function BaseJobView()
		{
			super();
			
			percentWidth = 100;
			percentHeight = 100;
			minWidth = 0;
			minHeight = 0;
			
			setStyle("backgroundColor", 0x93afbe);
			setStyle("backgroundAlpha", 1.0);
			updatePaddingStyles();
		}
		
		/**
		 * An optional UI component that should be displayed in the control bar above 
		 * the job view area when the job view is active.
		 */
		public var controlBarContent:UIComponent;
		
		
		private var _usePadding:Boolean = true;
		
		/**
		 * Whether to apply padding around the border of the job view area.
		 * 
		 * @default true
		 */
		public function get usePadding():Boolean
		{
			return _usePadding;
		}
		/**
		 * @private
		 */
		public function set usePadding(value:Boolean):void
		{
			_usePadding = value;
			updatePaddingStyles();
		}
		
		private function updatePaddingStyles():void
		{
			if (usePadding)
			{
				setStyle("paddingTop", 10);
				setStyle("paddingBottom", 10);
				setStyle("paddingLeft", 10);
				// Right padding is still 0 in case of scroll bars
				setStyle("paddingRight", 0);
			}
			else
			{
				setStyle("paddingTop", 0);
				setStyle("paddingBottom", 0);
				setStyle("paddingLeft", 0);
				setStyle("paddingRight", 0);
			}
		}
	}
}
