package com.rettuce.util
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author rettuce
	 */
	public class FuncUtil
	{
		/** 
		 *  all Child Remove !!!!!!!!
		 */
		static public function allRemoveChild( $target:DisplayObjectContainer ):void
		{
			if($target.numChildren!=0){
				var k:int = $target.numChildren;
				while( k -- ){
					var t:DisplayObject = $target.removeChildAt( k );
					t = null;
				}
			}
		}
		
		
		
		
		
		
		
		
		
		
	}
}