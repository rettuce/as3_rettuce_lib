package com.rettuce.debug
{
	import flash.external.ExternalInterface;

	/**
	 * Console.log debug trace
	 * use common.js
	 * 
	 **/
	public class JS
	{
		static public var enabled:Boolean = true;
		
		static public function Trace($txt:*):void
		{
			if(!enabled) return;
			
			if( ExternalInterface.available ){
				try{
					ExternalInterface.call( 'trace',$txt.toString());
				}
				catch(e:SecurityError){}
				catch(e:Error){}
			}			
		}
		
		static public function getQuery():String
		{
			return String(ExternalInterface.call("function() { return window.location.search; }"));
		}
		
	}
}