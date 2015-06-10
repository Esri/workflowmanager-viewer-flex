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
	import com.esri.holistic.CentralDispatcher;
	import com.esri.workflowManager.viewer.events.SelectJobEvent;
	import com.esri.workflowManager.viewer.events.SelectedJobAOIEvent;
	import com.esri.workflowManager.viewer.events.SelectedJobAttachmentsEvent;
	import com.esri.workflowManager.viewer.events.SelectedJobHistoryEvent;
	import com.esri.workflowManager.viewer.events.SelectedJobHoldsEvent;
	import com.esri.workflowManager.viewer.events.SelectedJobNotesEvent;
	import com.esri.workflowManager.viewer.events.SelectedJobRelationshipsEvent;
	import com.esri.workflowManager.viewer.events.SelectedJobWorkflowEvent;
	import com.esri.workflowManager.viewer.model.Model;
	import com.esri.workflowManager.viewer.model.ViewType;
	
	public class ViewCommand
	{
        [Listen(properties="viewType")]
        public function viewHandler(viewType:int):void
        {
			Model.instance.viewType = viewType;
			if (Model.instance.selectedJob != null)
			{
				var jobID:int = Model.instance.selectedJob.id;
				switch (Model.instance.viewType)
				{
					case ViewType.PROPERTIES:
						CentralDispatcher.dispatchEvent(new SelectJobEvent(jobID));
						break;
					case ViewType.WORKFLOW:
						CentralDispatcher.dispatchEvent(new SelectedJobWorkflowEvent(jobID));
						break;
					case ViewType.AOI:
						CentralDispatcher.dispatchEvent(new SelectedJobAOIEvent(jobID));
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
        }
	}
}
