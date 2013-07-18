package com.rettuce.util
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.LoaderContext;

	public class PostUtil
	{
		
		/**
		 * 
		 * PostUtil.post( Param.API_HOST + Param.API_REGISTER_USER,
		 * 	[
		 * 		{ key:'user_seq', value:Data.user_seq }
		 * 	],
		 * 	compJoin );
		 * 
		 * function compJoin(e:Event):void
		 * {
		 * 		URLLoader(e.target).removeEventListener(Event.COMPLETE, arguments.callee );
		 * 		if(!e.target.data){
		 * 			trace('*** '+Param.API_HOST + Param.API_JOIN+'  API Load Error.');	
		 * 			return;
		 * 		}
		 * 		var obj:Object = JSON.parse(String(e.target.data));
		 * 		if(obj.status=="0")
		 * 		{
		 * 			Data.user_seq = obj.user_seq;
		 * 			loadcheck();
		 * 		}else{
		 * 			trace('*** '+Param.API_HOST + Param.API_JOIN+'  API Status Error.');	
		 * 		}			
		 * 	}
		 * 
		 */
		static public function post( $url:String, $value:Array, $func:Function ):void
		{
			var va:URLVariables = new URLVariables();
			for (var i:int = 0; i < $value.length; i++) {				
				va[$value[i].key] = $value[i].value;
			}
			var url:URLRequest = new URLRequest($url);
			url.method = URLRequestMethod.POST;
			url.data = va;
			
			var loader:URLLoader = new URLLoader();
			loader.load(url);
			loader.addEventListener( Event.COMPLETE, $func );
			loader.addEventListener( IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void{
				trace(e);
			});
		}
	}
}