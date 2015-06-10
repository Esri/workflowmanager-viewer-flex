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

package com.esri.workflowManager.viewer.model
{
	import com.esri.workflowManager.tasks.supportClasses.QueryFieldInfo;
	
	import mx.charts.series.BarSet;
	import mx.collections.ArrayCollection;

	[Bindable]
	public final class ChartingModel
	{
		public const uniqueValueColors:Array = [
			0xE48701,
			0xA5BC4E,
			0x1B95D9,
			0xCACA9E,
			0x6693B0,
			0xF05E27,
			0x86D1E4,
			0xE4F9A0,
			0xFFD512,
			0x75B000,
			0x0662B0,
			0xEDE8C6,
			0xCC3300,
			0xD1DFE7,
			0x52D4CA,
			0xC5E0FD,
			0xE7C174,
			0xFFF797,
			0xC5F68F,
			0xBDF1E6,
			0x9E987D,
			0xEB988D,
			0x91C9E5,
			0x93DC4A,
			0xFFB900,
			0x9EBBCD,
			0x009797,
			0x0DB2C2];		
		
		public var chartColorLookup:Array;
		public var chartFields:ArrayCollection;
		public var chartCategorizeByField:QueryFieldInfo;
		public var chartGroupByField:QueryFieldInfo;
		public var selectedChartCategory:String;
		public var selectedChartGroup:String;
		public var chartData:ArrayCollection;
		public var barChartData:ArrayCollection;
		public var barSet:BarSet = new BarSet();
		
		public function ChartingModel()
		{
		}
	}
}
