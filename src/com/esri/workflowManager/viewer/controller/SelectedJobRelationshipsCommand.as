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
	import com.esri.workflowManager.viewer.model.JobRelation;
	import com.esri.workflowManager.viewer.model.Model;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.Responder;

	public class SelectedJobRelationshipsCommand
	{
		[Listen(properties="jobID")]
        public function selectedJobRelationshipsHandler(jobId:int):void
        {
			Model.instance.selectedJobRelationshipItem = null;
			Model.instance.selectedJobRelationships = new ArrayCollection([Model.resource("LoadingJobRelationships")]);
			
			JobRelation.query("JOB_ID="+jobId, new Responder(
				function (rels:Array/*of JobRelation*/):void
				{
					if (rels.length > 0)
					{
						var newItem:JobRelation = rels[0];
						Model.instance.selectedJobRelationshipItem = newItem;
						newItem.loadChildren();
						loadParent(newItem);
					}
					else
					{
						Model.instance.selectedJobRelationships = new ArrayCollection([Model.resource("SelectedJobNotFound")]);
					}
				},
				function (fault:Object):void
				{
					Model.instance.selectedJobRelationships = new ArrayCollection();
					Alert.show(Model.resource("ErrorLoadingJobRelationships") + "\n\n" + fault.toString(), Model.resource("ErrorTitle"));
				}
			));
        }
		
		private function loadParent(item:JobRelation):void
		{
			if (item.parentJobId == 0)
			{
				Model.instance.selectedJobRelationships = new ArrayCollection([item]);
			}
			else
			{
				JobRelation.query("JOB_ID="+item.parentJobId, new Responder(
					function (rels:Array/*of JobRelation*/):void
					{
						if (rels.length > 0)
						{
							var parentItem:JobRelation = rels[0];
							parentItem.childrenLoaded = true;
							parentItem.children = new ArrayCollection([item]);
							loadParent(parentItem);
						}
						else
						{
							Model.instance.selectedJobRelationships = new ArrayCollection([item]);
						}
					},
					function (fault:Object):void
					{
						Model.instance.selectedJobRelationships = new ArrayCollection();
						Alert.show(Model.resource("ErrorLoadingJobRelationships") + "\n\n" + fault.toString(), Model.resource("ErrorTitle"));
					}
				));
			}
		}
		
		private function findJobItem(items:ArrayCollection, jobId:int):JobRelation
		{
			if (items)
			{
				for each (var item:JobRelation in items)
				{
					if (item.jobId == jobId)
					{
						return item;
					}
					var match:JobRelation = findJobItem(item.children, jobId);
					if (match)
					{
						return match;
					}
				}
			}
			return null;
		}
	}
}
