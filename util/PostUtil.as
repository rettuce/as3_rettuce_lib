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
		 * PostUtil.post( 'request.php', [{ key:'hoge_id', value:'AAAA' }], completeHandler:Function );
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