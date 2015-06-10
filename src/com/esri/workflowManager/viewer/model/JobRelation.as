package com.esri.workflowManager.viewer.model
{
	import com.esri.workflowManager.tasks.supportClasses.JobQueryParameters;
	import com.esri.workflowManager.tasks.supportClasses.QueryResult;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	
	[Bindable]
	/**
	 * A data item for representing the parent-child relationships of jobs.
	 */
	public class JobRelation
	{
		public function JobRelation()
		{
		}
		
		public var jobId:int;
		public var label:String; // job name
		public var parentJobId:int;
		
		public var children:ArrayCollection = new ArrayCollection(); // of JobRelation
		public var childrenLoaded:Boolean = false;
		
		public function loadChildren():void
		{
			if (!childrenLoaded)
			{
				childrenLoaded = true;
				query("PARENT_JOB="+jobId, new Responder(
					function (rels:Array/*of JobRelation*/):void
					{
						rels.sortOn("label", Array.CASEINSENSITIVE);
						children = new ArrayCollection(rels);
					},
					function (fault:Object):void
					{
						Alert.show(Model.resource("ErrorLoadingJobRelationships") + "\n\n" + fault.toString(), Model.resource("ErrorTitle"));
					}
				));
			}
		}
		
		public static function query(where:String, responder:IResponder):void
		{
			var params:JobQueryParameters = new JobQueryParameters();
			params.fields = ["JOB_ID","JOB_NAME","PARENT_JOB"];
			params.tables = ["JTX_JOBS"];
			params.where = where;
			
			CursorManager.setBusyCursor();
			Model.instance.jobTask.queryJobsAdHoc(params, Model.instance.currentUserInfo.userName, new Responder(
				function (result:QueryResult):void
				{
					CursorManager.removeBusyCursor();
					var rels:Array = [];
					var jobIdIndex:int = result.findField("JOB_ID");
					var jobNameIndex:int = result.findField("JOB_NAME");
					var parentJobIndex:int = result.findField("PARENT_JOB");
					for each (var row:Array in result.rows)
					{
						var rel:JobRelation = new JobRelation();
						rel.jobId = int(row[jobIdIndex]);
						rel.label = row[jobNameIndex];
						rel.parentJobId = int(row[parentJobIndex]);
						rels.push(rel);
					}
					responder.result(rels);
				},
				function (fault:Object):void
				{
					CursorManager.removeBusyCursor();
					responder.fault(fault);
				}
			));
		}
	}
}
