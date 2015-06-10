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
	import com.esri.workflowManager.viewer.model.Model;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;

	public class SelectedJobHoldsCommand
	{
		[Listen(properties="jobID")]
        public function selectedJobHoldsHandler(jobID:int):void
        {
			Model.instance.jobTask.getHolds(jobID, new AsyncResponder(onResult, onFault));
			
			function onResult(data:Array, token:Object=null):void
			{
				var collection:ArrayCollection = new ArrayCollection(data);
				var sort:Sort = new Sort();
				sort.fields = [new SortField("id", true, false, true)];
				collection.sort = sort;
				collection.refresh();
				
				Model.instance.selectedJobHolds = collection;
			}
			function onFault(data:Object, token:Object=null):void
			{
				Alert.show(Model.resource("ErrorLoadingJobHolds") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
			}			
        }
	}
}
