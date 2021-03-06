package com.rettuce.data
{
	import com.adobe.serialization.json.JSON;
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author rettuce
	 * 
	 */
	dynamic public class JS extends EventDispatcher
	{
		
		/* Property */
		/////////////////////////////////////////////////////////////////////////
		
		private var _param:Array = [];
		public function get param():Array{ return _param };
		
		
		/* 
		 * Constructor
		 * コンストラクタの引数としてJSONへのパスを渡すと
		 * Event.COMLETEのタイミングで.paramで配列が取得できる
		 * 
		 * var js:JS = new JS( URL );
		 * js.addEventListener(Event.COMPLETE, function(e:Event):void{
		 * 	 trace(js.param as Array);
		 * });
		*/
		/////////////////////////////////////////////////////////////////////////
				
		public function JS( url:String )
		{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, jsDeco);
			urlLoader.load(new URLRequest(url));
		}
		
		private function jsDeco(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE, jsDeco);
			
			var json:String = URLLoader(e.currentTarget).data as String;			
			_param = JSON.decode(json);
			dispatchEvent(new Event(Event.COMPLETE));			
		}
	}	
}