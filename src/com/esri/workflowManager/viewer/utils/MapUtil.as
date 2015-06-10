package com.esri.workflowManager.viewer.utils
{
	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;
	
	/**
	 * @private
	 */
	public class MapUtil
	{
		/**
		 * Converts a comma-separated list of layer IDs into an ArrayCollection that can 
		 * be applied to the visibleLayers property of ArcGISDynamicMapServiceLayer and 
		 * ArcIMSMapServiceLayer.
		 */
		public static function parseLayerList(layers:String, asNumbers:Boolean = true):ArrayCollection
		{
			if (layers == null || layers.length == 0)
			{
				return null;
			}
			var layerIds:Array = layers.split(",");
			for (var i:int = 0; i < layerIds.length; i++)
			{
				layerIds[i] = StringUtil.trim(layerIds[i]);
				if (asNumbers)
				{
					layerIds[i] = Number(layerIds[i]);
				}
			}
			return new ArrayCollection(layerIds);
		}
		
		/**
		 * Convenience function for converting a layer definition query list from
		 * a compact representation to the expanded form expected by ArcGISDynamicMapServiceLayer.
		 * 
		 * For example, an input of:
		 *   <pre>[ { "layerId":3, "query":"FIELD = 42" } ]</pre>
		 * is converted to:
		 *   <pre>[ "", "", "", "FIELD = 42" ]</pre>
		 */
		public static function formatLayerDefinitions(layerDefs:Array/*of Object*/):Array/*of String*/
		{
			var result:Array = [];
			for each (var layerDef:Object in layerDefs)
			{
				var layerId:int = layerDef.layerId;
				var query:String = layerDef.query;
				while (result.length <= layerId)
				{
					result.push("");
				}
				result[layerId] = query;
			}
			return result;
		}
		
		/**
		 * @private
		 */
		public static function layerDefinition(layerId:int, query:String):Object
		{
			return { "layerId":layerId, "query":query };
		}
	}
}
