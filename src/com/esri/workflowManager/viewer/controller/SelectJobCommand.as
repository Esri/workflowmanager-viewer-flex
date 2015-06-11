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
	import com.esri.workflowManager.tasks.supportClasses.JobHold;
	import com.esri.workflowManager.tasks.supportClasses.JobInfo;
	import com.esri.workflowManager.viewer.events.PropertiesDirtyEvent;
	import com.esri.workflowManager.viewer.events.ReloadGroupsEvent;
	import com.esri.workflowManager.viewer.events.ReloadUsersEvent;
	import com.esri.workflowManager.viewer.events.SelectedJobAOIEvent;
	import com.esri.workflowManager.viewer.events.SelectedJobAttachmentsEvent;
	import com.esri.workflowManager.viewer.events.SelectedJobExtendedPropertiesEvent;
	import com.esri.workflowManager.viewer.events.SelectedJobHistoryEvent;
	import com.esri.workflowManager.viewer.events.SelectedJobHoldsEvent;
	import com.esri.workflowManager.viewer.events.SelectedJobNotesEvent;
	import com.esri.workflowManager.viewer.events.SelectedJobRelationshipsEvent;
	import com.esri.workflowManager.viewer.events.SelectedJobWorkflowEvent;
	import com.esri.workflowManager.viewer.model.Model;
	import com.esri.workflowManager.viewer.model.ViewType;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;
	
	public class SelectJobCommand
	{
        [Listen(properties="jobID")]
        public function selectJobHandler(jobID:int):void
        {
        	Model.instance.map.infoWindow.hide();
			if (jobID > 0)
			{
				// get the most up-to-date user and group lists if viewtype is properties
				if (Model.instance.viewType == ViewType.PROPERTIES)
				{
					CentralDispatcher.dispatchEvent(new ReloadUsersEvent());
					CentralDispatcher.dispatchEvent(new ReloadGroupsEvent());
				}

				Model.instance.jobTask.getJob(jobID, new AsyncResponder(onJobResult, onJobFault));
				Model.instance.jobTask.getHolds(jobID, new AsyncResponder(onHoldsResult, onHoldsFault));
			}
			else
			{
				Model.instance.selectedJob = null;
			}
			
        	function onJobResult(data:JobInfo, token:Object=null):void
        	{
				CentralDispatcher.dispatchEvent(new PropertiesDirtyEvent(false));
				Model.instance.selectedJob = data;
				switch (Model.instance.viewType)
				{
					case ViewType.PROPERTIES:
						CentralDispatcher.dispatchEvent(new SelectedJobExtendedPropertiesEvent(jobID));
						break;
					case ViewType.AOI:
						CentralDispatcher.dispatchEvent(new SelectedJobAOIEvent(jobID));
						break;
					case ViewType.WORKFLOW:
						CentralDispatcher.dispatchEvent(new SelectedJobWorkflowEvent(jobID));
						break;
					case ViewType.ATTACHMENTS: 
						CentralDispatcher.dispatchEvent(new SelectedJobAttachmentsEvent(jobID));
						break;
					case ViewType.NOTES:
						CentralDispatcher.dispatchEvent(new SelectedJobNotesEvent(jobID));
						break;
					case ViewType.HISTORY:
						CentralDispatcher.dispatchEvent(new SelectedJobHistoryEvent(jobID));
						break;
					case ViewType.RELATIONSHIPS:
						CentralDispatcher.dispatchEvent(new SelectedJobRelationshipsEvent(jobID));
						break;
					case ViewType.HOLDS:
						CentralDispatcher.dispatchEvent(new SelectedJobHoldsEvent(jobID));
						break;
				}
			}
			function onHoldsResult(data:Array, token:Object=null):void
			{
				for each (var jobHold:JobHold in data)
				{
					if (jobHold.active)
					{
						Model.instance.isSelectedJobOnHold = true;
						return;
					}
				}
				Model.instance.isSelectedJobOnHold = false;
			}
			function onJobFault(data:Object, token:Object=null):void
			{
				Alert.show(Model.resource("ErrorLoadingJobInfo") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
			}
			function onHoldsFault(data:Object, token:Object=null):void
			{
				Alert.show(Model.resource("ErrorLoadingJobHolds") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
			}
        }
	}
}
