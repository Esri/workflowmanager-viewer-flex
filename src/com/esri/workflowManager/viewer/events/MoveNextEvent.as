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

package com.esri.workflowManager.viewer.events
{
	import com.esri.holistic.AbstractEvent;

	public class MoveNextEvent extends AbstractEvent
	{
		public var jobID:int;
		public var stepID:int;
		public var returnCode:int;
		public var moveToNext:Boolean;
		public var answerLabel:String;
		public var notes:String;
        
        public function MoveNextEvent(jobID:int, stepID:int, returnCode:int, moveToNext:Boolean = true, answerLabel:String = null, notes:String = null)
        {
            super("moveNext");
            this.jobID = jobID;
            this.stepID = stepID;
            this.returnCode = returnCode;
			this.moveToNext = moveToNext;
			this.answerLabel = answerLabel;
			this.notes = notes;
        }
	}
}
