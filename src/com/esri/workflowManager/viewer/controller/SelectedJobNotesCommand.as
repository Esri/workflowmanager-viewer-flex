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
	
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;

	public class SelectedJobNotesCommand
	{
		[Listen(properties="jobID")]
        public function selectedJobNotesHandler(jobID:int):void
        {
        	Model.instance.jobTask.getNotes(jobID, new AsyncResponder(onResult, onFault));
			
        	function onResult(data:String, token:Object=null):void
        	{
        		Model.instance.selectedJobNotes = data;
        	}
        	function onFault(data:Object, token:Object=null):void
        	{
				Alert.show(Model.resource("ErrorLoadingJobNotes") + "\n\n" + data.toString(), Model.resource("ErrorTitle"));
        	}
        }
	}
}
