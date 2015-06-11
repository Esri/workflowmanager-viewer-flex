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
	import com.esri.holistic.CentralDispatcher;
	import com.esri.workflowManager.tasks.supportClasses.FieldTypeEnum;
	import com.esri.workflowManager.tasks.supportClasses.JobQueryParameters;
	import com.esri.workflowManager.tasks.supportClasses.QueryFieldInfo;
	import com.esri.workflowManager.tasks.supportClasses.QueryResult;
	import com.esri.workflowManager.utils.WMDateUtil;
	import com.esri.workflowManager.viewer.events.JobQueryEvent;
	import com.esri.workflowManager.viewer.model.JobSearch;
	import com.esri.workflowManager.viewer.model.Model;
	import com.esri.workflowManager.viewer.utils.MapUtil;
	import com.esri.workflowManager.viewer.utils.WMUtil;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.Responder;
	
	public class JobQueryCommand
	{
        [Listen(properties="queryName,queryParams")]
		/**
		 * Runs a job query based on the query parameters.
		 * If a query ID is specified, the query corresponding to that ID is
		 * executed. Otherwise, an ad hoc query is run.
		 */
        public function jobQueryHandler(queryName:String, queryParams:JobSearch):void
        {
			Model.instance.lastJobSearch = queryParams;
        	Model.instance.chartingModel.chartFields = new ArrayCollection();
			
			switch (queryParams.type)
			{
				case JobSearch.QUERY_BY_ID:
					Model.instance.jobTask.queryJobsByID(queryParams.queryId, 
						Model.instance.currentUserInfo.userName, 
						new Responder(onResult, onQueryFault));
					break;
				case JobSearch.QUERY_AD_HOC:
					Model.instance.jobTask.queryJobsAdHoc(queryParams.queryParameters, 
						Model.instance.currentUserInfo.userName,
						new Responder(onResult, onQueryFault));
					break;
				case JobSearch.TEXT_SEARCH:
					Model.instance.jobTask.searchJobs(queryParams.searchText, 
						Model.instance.currentUserInfo.userName,
						new Responder(onResult, onSearchFault));
					break;
			}
			
			function onResult(queryResult:QueryResult):void
			{
				handleQueryResult(queryName, queryResult);
			}
			function onQueryFault(fault:Object):void
			{
				Alert.show(Model.resource("ErrorExecutingJobQuery") + "\n\n" + fault.toString(), Model.resource("ErrorTitle"));
				Model.instance.jobList = null;
				// Update the AOI map layer
				Model.instance.aoiDynamicLayerDefinitions = MapUtil.formatLayerDefinitions([
					MapUtil.layerDefinition(Model.instance.configModel.aoiMapServiceLayerId, "1=0")
				]);
			}
			function onSearchFault(fault:Object):void
			{
				trace(fault);
				
				// Fallback to the 10.0 search method
				var q:String = queryParams.searchText.toUpperCase();
				q = q.replace("'", "");
				
				var whereClause:String = "JTX_JOBS.JOB_TYPE_ID=JTX_JOB_TYPES.JOB_TYPE_ID AND ("
					+((Number(q) > 0) ? ("JTX_JOBS.JOB_ID="+Number(q)) : "0=1")
					+" OR UPPER(JTX_JOBS.JOB_NAME) LIKE '%"+q+"%'"
					+" OR UPPER(JTX_JOB_TYPES.JOB_TYPE_NAME) LIKE '%"+q+"%'"
					+" OR UPPER(JTX_JOBS.DESCRIPTION) LIKE '%"+q+"%'"
					// Search group assignments, by group name
					+" OR (JTX_JOBS.ASSIGNED_TYPE=2 AND UPPER(JTX_JOBS.ASSIGNED_TO) LIKE '%"+q+"%')"
					// Search user assignments, by username and full name
					+" OR (JTX_JOBS.ASSIGNED_TYPE=1 AND ("
					+"UPPER(JTX_JOBS.ASSIGNED_TO) LIKE '%"+q+"%'"
					+" OR JTX_JOBS.ASSIGNED_TO IN (SELECT USERNAME FROM JTX_USERS WHERE UPPER(FULL_NAME) LIKE '%"+q+"%')"
					+"))"
					+")";
				
				var params:JobQueryParameters = new JobQueryParameters();
				params.fields = ["JTX_JOBS.JOB_ID","JTX_JOBS.JOB_NAME","JTX_JOB_TYPES.JOB_TYPE_NAME","JTX_JOBS.ASSIGNED_TO","JTX_JOBS.DUE_DATE","JTX_JOBS.DESCRIPTION"];
				params.aliases = Model.resource("QueryFieldDescriptions").split(",");
				params.tables = ["JTX_JOBS","JTX_JOB_TYPES"];
				params.where = whereClause;
				CentralDispatcher.dispatchEvent(new JobQueryEvent(queryName, JobSearch.fromQueryParameters(params)));
			}
        }
		
		private function handleQueryResult(queryName:String, queryResult:QueryResult):void
		{
			var jobList:ArrayCollection = new ArrayCollection();
			Model.instance.jobIdField = null;
			
			// Process the result schema
			var curField:QueryFieldInfo;
			for each (curField in queryResult.fields)
			{
				if ((Model.instance.jobIdField == null) && WMUtil.isField(curField.name, "JTX_JOBS.JOB_ID"))
				{
					Model.instance.jobIdField = curField.name;
				}
				if (curField.type == FieldTypeEnum.STRING)
				{
					if (!WMUtil.isField(curField.name, "JTX_JOBS.JOB_ID") && !WMUtil.isField(curField.name, "JTX_JOBS.JOB_NAME"))
					{
						Model.instance.chartingModel.chartFields.addItem(curField);
					}
				}
			}
			
			// Process the result records
			for (var i:int = 0; i < queryResult.rows.length; i++)
			{
				var curObject:Object = {};
				for(var j:int = 0; j < queryResult.fields.length; j++)
				{
					curField = queryResult.fields[j];
					curObject[curField.name] = queryResult.rows[i][j];
					if (curField.type == FieldTypeEnum.DATE)
					{
						// To support multiple locales, show the date string as-is from WMX server.
						// If a date object needs to be formatted, then edit the 
						// WMDateUtil.parseJobQueryDate method for that specific locale and
						// uncomment the line below.
						//curObject[curField.name] = WMDateUtil.parseJobQueryDate(curObject[curField.name]);
					}
					else if (curField.type == FieldTypeEnum.INTEGER
						|| curField.type == FieldTypeEnum.SMALL_INTEGER)
					{
						curObject[curField.name] = parseInt(curObject[curField.name]);
					}
					else if (curField.type == FieldTypeEnum.DOUBLE
						|| curField.type == FieldTypeEnum.SINGLE)
					{
						curObject[curField.name] = parseFloat(curObject[curField.name]);
					}
				}
				jobList.addItem(curObject);
			}
			
			Model.instance.queryResultFields = queryResult.fields;
			Model.instance.jobList = jobList;
			if (queryName !== null)
			{
				Model.instance.jobTableTitle = queryName;
			}
			
			// Update the AOI map layer
			var jobIds:Array = [];
			if (Model.instance.jobIdField != null)
			{
				for each (var jobObject:Object in jobList)
				{
					jobIds.push(jobObject[Model.instance.jobIdField]);
				}
			}
			Model.instance.aoiDynamicLayerDefinitions = MapUtil.formatLayerDefinitions([
				MapUtil.layerDefinition(
					Model.instance.configModel.aoiMapServiceLayerId, 
					Model.instance.configModel.aoiMapServiceJobIdField + " IN (" + jobIds.join(",") + ")"
				)
			]);
			
			// Update the charting model
			Model.instance.chartingModel.chartCategorizeByField = null;
			Model.instance.chartingModel.chartGroupByField = null;
			Model.instance.chartingModel.chartData = null;
			Model.instance.chartingModel.selectedChartCategory = null;
			Model.instance.chartingModel.selectedChartGroup = null;
		}
	}
}
