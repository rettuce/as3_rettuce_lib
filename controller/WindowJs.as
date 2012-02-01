package com.rettuce.controller
{
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	/**
	 * ...
	 * @author rettuce
	 * 
	 */
	public class WindowJs
	{
		
		// out link
		static public function goto( url:String, win:String='_blank'):void
		{
			navigateToURL( new URLRequest(url), win );
		}
		
		
		// popup
		static public function popup($url:String, $width:Number=600, $height:Number=400):void
		{
			ExternalInterface.call("function(){ window.open('"+$url+"','view', 'width="+$width+", height="+$height+"'); void(0);}");
		}
		
		
		// window close
		static public function close():void
		{
			ExternalInterface.call("window.close()");
		}	
		
		
	}
}