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
	import com.esri.workflowManager.tasks.supportClasses.AuxRecord;
	import com.esri.workflowManager.tasks.supportClasses.AuxRecordContainer;
	import com.esri.workflowManager.tasks.supportClasses.AuxRecordValue;
	import com.esri.workflowManager.tasks.supportClasses.FieldTypeEnum;
	import com.esri.workflowManager.tasks.supportClasses.TableRelationshipTypeEnum;
	import com.esri.workflowManager.viewer.events.ListValuesLoadedEvent;
	import com.esri.workflowManager.viewer.model.Model;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;

	public class SelectedJobExtendedPropertiesCommand
	{
		[Listen(properties="jobID")]
        public function selectedJobExtendedPropertiesHandler(jobID:int):void
        {
			//Model.instance.selectedJobExtendedProperties = null;
        	Model.instance.jobTask.getExtendedProperties(jobID, new AsyncResponder(onResult, onFault));
			
        	function onResult(containers:Array, token:Object=null):void
        	{
				containers = containers.filter(filterAuxContainer);
				loadListValues(jobID, containers);
				Model.instance.selectedJobExtendedProperties = new ArrayCollection(containers);
        	}
        	function onFault(data:Object, token:Object=null):void
        	{
				Alert.show(Model.resource("ErrorLoadingExtendedProperties") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
        	}
        }
		
		private function filterAuxContainer(item:AuxRecordContainer, index:int, array:Array):Boolean
		{
			if (item.relationshipType == TableRelationshipTypeEnum.ONE_TO_ONE)
			{
				if (item.records && item.records.length > 0)
				{
					var record:AuxRecord = item.records[0];
					var recordValues:Array = record.recordValues;
					if (recordValues)
					{
						recordValues = recordValues.filter(filterAuxRecordValue);
						if (recordValues.length > 0)
						{
							recordValues.sortOn("displayOrder", Array.NUMERIC);
							record.recordValues = recordValues;
							return true;
						}
					}
				}
			}
			return false;
		}
		
		private function filterAuxRecordValue(item:AuxRecordValue, index:int, array:Array):Boolean
		{
			if (!item.userVisible)
			{
				return false;
			}
			var type:int = item.dataType;
			if (type == FieldTypeEnum.DATE && !item.isListValued())
			{
				var date:Date = item.data as Date;
				if (date)
				{
					date = new Date(Date.UTC(date.fullYearUTC, date.monthUTC, date.dateUTC, 12));
					item.data = date;
				}
			}
			if (type == FieldTypeEnum.STRING
				|| type == FieldTypeEnum.INTEGER
				|| type == FieldTypeEnum.SMALL_INTEGER
				|| type == FieldTypeEnum.SINGLE
				|| type == FieldTypeEnum.DOUBLE
				|| type == FieldTypeEnum.DATE)
			{
				return true;
			}
			return false;
		}
		
		private function loadListValues(jobID:int, containers:Array/*of AuxRecordContainer*/):void
		{
			for each (var ctr:AuxRecordContainer in containers)
			{
				// At this point we are assured there is at least one record
				var record:AuxRecord = ctr.records[0];
				for each (var recordValue:AuxRecordValue in record.recordValues)
				{
					if (recordValue.isListValued())
					{
						var listValues:Array = Model.instance.listValueCache.get(ctr.tableName, recordValue.name);
						if (!listValues)
						{
							loadListValuesForField(
								jobID, 
								ctr.tableName, 
								recordValue.name, 
								(recordValue.dataType == FieldTypeEnum.DATE) );
						}
					}
				}
			}
		}
		
		private function loadListValuesForField(jobID:int, tableName:String, fieldName:String, isDateField:Boolean):void
		{
			Model.instance.jobTask.listFieldValues(jobID, tableName, fieldName, isDateField, 
				Model.instance.currentUserInfo.userName, new AsyncResponder(onListValuesResult, onListValuesFault, null));
			
			function onListValuesResult(values:Array/*of AuxListValue*/, token:Object = null):void
			{
				Model.instance.listValueCache.add(tableName, fieldName, values);
				CentralDispatcher.dispatchEvent(new ListValuesLoadedEvent(tableName, fieldName, values));
			}
			function onListValuesFault(data:Object, token:Object = null):void
			{
				trace(data);
			}
		}
	}
}
