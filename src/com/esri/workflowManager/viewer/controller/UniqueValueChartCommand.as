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
	import com.esri.ags.symbols.SimpleFillSymbol;
	import com.esri.ags.symbols.SimpleLineSymbol;
	import com.esri.holistic.CentralDispatcher;
	import com.esri.workflowManager.tasks.supportClasses.QueryFieldInfo;
	import com.esri.workflowManager.viewer.events.UniqueValueFilterJobsEvent;
	import com.esri.workflowManager.viewer.model.Model;
	import com.esri.workflowManager.viewer.utils.Hashtable;
	import com.esri.workflowManager.viewer.utils.MapUtil;
	
	import mx.charts.series.BarSeries;
	import mx.charts.series.BarSet;
	import mx.collections.ArrayCollection;
	
	public class UniqueValueChartCommand
	{
        [Listen(properties="categorizeByField,groupByField")]
        public function uniqueValueChartHandler(categorizeByField:QueryFieldInfo, groupByField:QueryFieldInfo):void
        {
        	Model.instance.jobList.filterFunction = null;
        	Model.instance.jobList.refresh();
        	var jobObject:Object;
        	var jobIds:Array = [];
        	for each (jobObject in Model.instance.jobList)
        	{
        		jobIds.push(jobObject[Model.instance.jobIdField]);
        	}
			// Update the AOI map layer
			Model.instance.aoiDynamicLayerDefinitions = MapUtil.formatLayerDefinitions([
				MapUtil.layerDefinition(
					Model.instance.configModel.aoiMapServiceLayerId, 
					Model.instance.configModel.aoiMapServiceJobIdField + " IN (" + jobIds.join(",") + ")"
				)
			]);
			
        	Model.instance.chartingModel.chartCategorizeByField = categorizeByField;
        	Model.instance.chartingModel.chartGroupByField = groupByField;
        	Model.instance.chartingModel.chartData = new ArrayCollection();
			Model.instance.chartingModel.barChartData = new ArrayCollection();
			Model.instance.chartingModel.barSet = new BarSet();
        	Model.instance.chartingModel.chartColorLookup = generateChartColors(categorizeByField.name);
        	if (categorizeByField != null)
        	{
	        	if (groupByField == null)
	        	{
		        	var curChartData:ArrayCollection = createChartData(Model.instance.jobList, categorizeByField.name);
		        	Model.instance.chartingModel.chartData.addItem({
						label:Model.resource("AllGroupsChartLabel"), 
						name:Model.resource("AllGroupsChartLabel"), 
						data:curChartData
					});
		        }
		        else
		        {
		        	var groupByFieldName:String = groupByField.name;
		        	var jobListLookup:Array = [];
		        	for each (jobObject in Model.instance.jobList)
		        	{
		        		if (jobListLookup[jobObject[groupByFieldName]] == null)
		        		{
		        			jobListLookup[jobObject[groupByFieldName]] = new ArrayCollection();
		        		}
		        		(jobListLookup[jobObject[groupByFieldName]] as ArrayCollection).addItem(jobObject);
		        	}
					
					//create pie chart data
					createPieChartData(jobListLookup);
					
					//create bar chart data and chart series
					createBarChart(jobListLookup);
		        }
	        }
            CentralDispatcher.dispatchEvent(new UniqueValueFilterJobsEvent(null, null));
        }
		private function createPieChartData(jobListLookup:Array):void
		{
			for (var groupName:String in jobListLookup)
			{
				var groupChartData:ArrayCollection = createChartData(jobListLookup[groupName], Model.instance.chartingModel.chartCategorizeByField.name);
				if (groupName == "")
				{
					Model.instance.chartingModel.chartData.addItem({
						label:Model.resource("NotAvailable"), 
						name:groupName, 
						data:groupChartData
					});
				}
				else
				{
					Model.instance.chartingModel.chartData.addItem({
						label:groupName, 
						name:groupName, 
						data:groupChartData
					});
				}
			} 
		}
		private function createBarChart(jobListLookup:Array):void
		{
			var categories:Hashtable = new Hashtable();			
			Model.instance.chartingModel.barSet.series = [];
			var series:BarSeries;				
			
			for (var groupName:String in jobListLookup)
			{
				var chartLookup:Array = [];							
				var fieldName:String = Model.instance.chartingModel.chartCategorizeByField.name;
				for each (var jobObject:Object in jobListLookup[groupName])
				{
					if (chartLookup[jobObject[fieldName]] == null)
					{
						chartLookup[jobObject[fieldName]] = 0;
					}
					chartLookup[jobObject[fieldName]]++;
				}					
				if(groupName =="")
				{
					groupName=Model.resource("Unassigned");
				}					
				var o:Object = {};
				o.group = groupName;
				for (var keyString:String in chartLookup)
				{								
					if(keyString =="")
					{
						o[Model.resource("Unassigned")] = chartLookup[keyString];
						if(!categories.containsKey(Model.resource("Unassigned")))
						{
							categories.add(Model.resource("Unassigned"),0);
							
							series = new BarSeries();
							
							series.xField = Model.resource("Unassigned");
							series.displayName = Model.resource("Unassigned");								
							Model.instance.chartingModel.barSet.series.push(series);		
						}
					}
					else
					{
						o[keyString] = chartLookup[keyString];
						if(!categories.containsKey(keyString))
						{
							categories.add(keyString, 0);
							series = new BarSeries();		
							series.xField = keyString;
							series.displayName = keyString;
							Model.instance.chartingModel.barSet.series.push(series);
						}
					}								
				}							
				Model.instance.chartingModel.barChartData.addItem(o);							
			}
			Model.instance.chartingModel.barSet.type = "stacked";
		}			

        private function generateChartColors(fieldName:String):Array
        {
        	var colorIndex:int = 0;
        	var colorLookup:Array = [];
        	for each (var jobObject:Object in Model.instance.jobList)
        	{
        		if (colorLookup[jobObject[fieldName]] == null)
        		{
        			colorLookup[jobObject[fieldName]] = Model.instance.chartingModel.uniqueValueColors[colorIndex];
        			colorIndex++;
	        		if (colorIndex == Model.instance.chartingModel.uniqueValueColors.length)
	        		{
	        			colorIndex = 0;
	        		}
        		}
        	}
        	return colorLookup;
        }
        
        private function createChartData(jobList:ArrayCollection, fieldName:String):ArrayCollection
        {
			var chartLookup:Array = [];
        	for each (var jobObject:Object in jobList)
        	{
        		if (chartLookup[jobObject[fieldName]] == null)
        		{
        			chartLookup[jobObject[fieldName]] = 0;
        		}
        		chartLookup[jobObject[fieldName]]++;
        	}

			var curChartData:ArrayCollection = new ArrayCollection();
			var defaultSymbol:SimpleFillSymbol = new SimpleFillSymbol("solid", 0xCCCCCC, 0.3);
			defaultSymbol.outline = new SimpleLineSymbol("solid", 0x000000, 1, 1);
        	for (var key:String in chartLookup)
        	{
        		if (key == "")
        		{
	        		curChartData.addItem({
						name:key, 
						label:Model.resource("NotAvailable"), 
						value:chartLookup[key], 
						color:Model.instance.chartingModel.chartColorLookup[key]
					});
	        	}
	        	else
	        	{
	        		curChartData.addItem({
						name:key, 
						label:key, 
						value:chartLookup[key], 
						color:Model.instance.chartingModel.chartColorLookup[key]
					});
	        	}
        	}
        	return curChartData;        	
    	}
	}
}
