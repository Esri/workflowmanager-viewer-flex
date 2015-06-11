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

package com.esri.workflowManager.viewer.model
{
	public class AuxListValueCache
	{
		public function AuxListValueCache()
		{
		}
		
		private var _cache:Object = {};
		
		public function add(tableName:String, fieldName:String, values:Array/*of AuxListValue*/):void
		{
			if (!_cache[tableName])
			{
				_cache[tableName] = {};
			}
			_cache[tableName][fieldName] = values;
		}
		
		public function get(tableName:String, fieldName:String):Array/*of AuxListValue*/
		{
			if (_cache[tableName])
			{
				return _cache[tableName][fieldName] as Array;
			}
			return null;
		}
	}
}
