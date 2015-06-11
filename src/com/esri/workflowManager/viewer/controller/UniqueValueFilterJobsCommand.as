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
	import com.esri.workflowManager.viewer.utils.MapUtil;
	
	public class UniqueValueFilterJobsCommand
	{
        [Listen(properties="filterCategory,filterGroup")]
        public function uniqueValueFilterJobsHandler(filterCategory:String, filterGroup:String):void
        {
        	Model.instance.chartingModel.selectedChartCategory = filterCategory;
        	Model.instance.chartingModel.selectedChartGroup = filterGroup;
        	if (filterCategory != null && filterGroup == null)
        	{
        		Model.instance.jobList.filterFunction = filterJobsByCategory;
        	}
        	else if (filterCategory != null && filterGroup != null)
        	{
        		Model.instance.jobList.filterFunction = filterJobsByBoth;
        	}
        	else
        	{
        		Model.instance.jobList.filterFunction = null;
        	}
        	Model.instance.jobList.refresh();
        	var jobIds:Array = [];
        	for each (var jobObject:Object in Model.instance.jobList)
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
        }
        
        private function filterJobsByCategory(item:Object):Boolean
        {
        	return (item[Model.instance.chartingModel.chartCategorizeByField.name] == Model.instance.chartingModel.selectedChartCategory);
        }

        private function filterJobsByBoth(item:Object):Boolean
        {
        	return (item[Model.instance.chartingModel.chartCategorizeByField.name] == Model.instance.chartingModel.selectedChartCategory &&
        			item[Model.instance.chartingModel.chartGroupByField.name] == Model.instance.chartingModel.selectedChartGroup);
        }
	}
}
