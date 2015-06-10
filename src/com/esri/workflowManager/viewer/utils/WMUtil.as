package com.esri.workflowManager.viewer.utils
{
	import com.esri.workflowManager.tasks.supportClasses.GroupInfo;
	import com.esri.workflowManager.tasks.supportClasses.GroupMembership;
	import com.esri.workflowManager.tasks.supportClasses.UserDetails;
	
	/**
	 * Miscellaneous utility methods.
	 */
	public class WMUtil
	{
		/**
		 * Returns true if a string is null or empty, false otherwise.
		 */
		public static function isEmpty(str:String):Boolean
		{
			return str == null || str.length == 0;
		}
		
		/**
		 * Returns true if a string is not null and not empty, false otherwise.
		 */
		public static function isSet(str:String):Boolean
		{
			return str != null && str.length > 0;
		}
		
		/**
		 * Determines if one string ends with another string.
		 */
		public static function endsWith(str:String, suffix:String):Boolean
		{
			return (str != null) && (suffix != null) 
				&& (str.substring(str.length - suffix.length) == suffix);
		}
		
		/**
		 * Determines whether two field names are equivalent.
		 * Either the specified field names must be the same, or the expected field name
		 * must be a suffix of the actual field name (e.g. [schema/user].[table].[field]).
		 */
		public static function isField(actualFieldName:String, expectedFieldName:String):Boolean
		{
			if (actualFieldName == null || expectedFieldName == null)
			{
				return false;
			}
			actualFieldName = actualFieldName.toUpperCase();
			expectedFieldName = expectedFieldName.toUpperCase();
			return (actualFieldName == expectedFieldName) || endsWith(actualFieldName, "."+expectedFieldName);
		}
		
		/**
		 * Determines if the specified username belongs to any group of the current user.
		 */
		public static function isUserInMyGroups(usernameToFind:String, 
												currentUser:UserDetails, 
												allGroups:Array/*of GroupInfo*/ ):Boolean
		{
			for each (var userGroup:GroupMembership in currentUser.groups)
			{
				for each (var group:GroupInfo in allGroups)
				{
					if (userGroup.id == group.id)
					{
						for each (var user:String in group.users)
						{
							if (usernameToFind == user)
							{
								return true;
							}
						}
					}
				}
			}
			return false;
		}
	}
}
