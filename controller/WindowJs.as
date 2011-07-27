package com.rettuce.controller
{
	import flash.external.ExternalInterface;
	
	/**
	 * ...
	 * @author rettuce
	 * 
	 */
	public class WindowJs
	{
		/* window close */
		/////////////////////////////////////////////////////////////////////////
		
		static public function close():void{ ExternalInterface.call("window.close()"); }		
		
		
	}
}