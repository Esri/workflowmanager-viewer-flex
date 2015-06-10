package com.esri.workflowManager.viewer.components
{	
	import flash.display.DisplayObject;
	
	import mx.controls.ComboBox;
	import mx.core.IFlexDisplayObject;
	import mx.core.UIComponent;
	
	public class IconComboBox extends ComboBox
	{
		public function IconComboBox() 
		{
			super();
		}
		
		private var iconHolder:UIComponent;
		private var iconPaddingLeft:Number = 2;
		private var iconPaddingRight:Number = 2;
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			iconHolder = new UIComponent();
			addChild(iconHolder);
		}
		
		override protected function measure():void
		{
			super.measure();
			
			if (iterator && iterator.current)
			{
				var iconClass:Class = iterator.current.icon;
				var icon:IFlexDisplayObject = new iconClass() as IFlexDisplayObject;
				measuredWidth += icon.measuredWidth + iconPaddingLeft + iconPaddingRight;
				measuredHeight = Math.max(measuredHeight, icon.measuredHeight + borderMetrics.top + borderMetrics.bottom);
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (iterator && iterator.current)
			{
				var iconClass:Class = iterator.current.icon;
				var icon:IFlexDisplayObject = new iconClass() as IFlexDisplayObject;
				while (iconHolder.numChildren > 0)
					iconHolder.removeChildAt(0);
				iconHolder.addChild(DisplayObject(icon));
				iconHolder.y = (unscaledHeight - icon.measuredHeight) / 2;
				iconHolder.x = borderMetrics.left + iconPaddingLeft;
				textInput.x = iconHolder.x + icon.measuredWidth + iconPaddingRight;
				textInput.setActualSize(textInput.width - icon.measuredWidth, textInput.height);
			}
		} 
	}
}
