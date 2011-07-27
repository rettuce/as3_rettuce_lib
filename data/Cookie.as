package com.rettuce.data
{
	import flash.net.SharedObject;
	
	/**
	 * ...
	 * @author rettuce
	 * 
	 */
	public class Cookie
	{
		
		/* Property */
		/////////////////////////////////////////////////////////////////////////
		
		private var _id:String;
		
		
		
		
		/* Constructor 引数にSharedObject用IDを渡す */
		/////////////////////////////////////////////////////////////////////////
				
		public function Cookie($id:String)
		{
			_id = $id;
		}
		
		
		
		/* Save & Load */
		/////////////////////////////////////////////////////////////////////////
		
		public function save($obj:Object):void
		{
			var shareObj:SharedObject = SharedObject.getLocal( _id, '/' );
			shareObj.data.object = $obj;
			shareObj.flush();
		}
		
		public function read():Object
		{
			var shareObj:SharedObject = SharedObject.getLocal( _id, '/' );
			return shareObj.data.object;
		}
		
	}
}