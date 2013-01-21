package com.rettuce.data
{
	import flash.net.SharedObject;	
	/**
	 * @author rettuce
	 */
	public class Cookie
	{
		// Save
		static public function save($id:String, $obj:Object):void
		{
			var shareObj:SharedObject = SharedObject.getLocal( $id, '/' );
			shareObj.data.object = $obj;
			shareObj.flush();
		}
		
		// Load
		static public function read($id:String):Object
		{
			var shareObj:SharedObject = SharedObject.getLocal( $id, '/' );
			return shareObj.data.object;
		}
		
	}
}