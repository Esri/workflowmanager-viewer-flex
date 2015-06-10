package com.esri.workflowManager.viewer.model
{
	import com.esri.workflowManager.tasks.supportClasses.JobQueryParameters;
	
	/**
	 * Maintains the properties and type of the last job search or query to be executed.
	 */
	public class JobSearch
	{
		// search/query types
		public static const TEXT_SEARCH:int = 1;
		public static const QUERY_BY_ID:int = 2;
		public static const QUERY_AD_HOC:int = 3;
		
		public var type:int;
		public var searchText:String;
		public var queryId:int;
		public var queryParameters:JobQueryParameters;
		
		public function JobSearch(type:int)
		{
			this.type = type;
		}
		
		public static function fromTextSearch(text:String):JobSearch
		{
			var js:JobSearch = new JobSearch(TEXT_SEARCH);
			js.searchText = text;
			return js;
		}
		
		public static function fromQueryId(queryId:int):JobSearch
		{
			var js:JobSearch = new JobSearch(QUERY_BY_ID);
			js.queryId = queryId;
			return js;
		}
		
		public static function fromQueryParameters(queryParams:JobQueryParameters):JobSearch
		{
			var js:JobSearch = new JobSearch(QUERY_AD_HOC);
			js.queryParameters = queryParams;
			return js;
		}
	}
}
