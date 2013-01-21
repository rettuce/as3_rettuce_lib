package com.rettuce.controller
{
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;

	/**
	 * ...
	 * @author rettuce
	 * new FullScreen( Stage, Button target Object )
	 */
	public class FullScreen
	{
		private var _stg:Stage;
		private var _obj:Object;
		
		public function FullScreen( $stg:Stage, $obj:Object )
		{
			_stg = $stg;
			_obj = $obj;			
			_obj.addEventListener( MouseEvent.CLICK, fullscreenHandler );
		}
		
		private function fullscreenHandler(m:MouseEvent):void
		{
			if (_stg.displayState == StageDisplayState.NORMAL) _stg.displayState = StageDisplayState.FULL_SCREEN;
			else _stg.displayState = StageDisplayState.NORMAL;
		}
	}
}