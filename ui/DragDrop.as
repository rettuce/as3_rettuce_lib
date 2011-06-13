package com.rettuce.ui
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author rettuce
	 * 
	 */
	public class DragDrop extends EventDispatcher
	{
		
		/* Property */
		/////////////////////////////////////////////////////////////////////////
		
		static public const START:String = "drag_start";
		static public const COMP:String  = "drag_complete";
		private var _dragFlg:Boolean = false;
		private var _offset:Number = 0;
		private var _dist:Number   = 0;
		
		private var _bar:Object;
		private var _pointer:Object;
		private var _stage:Stage;	
		
		
		
		
		/* 
		* Constructor
		* Bar's Display Object, Pointer's Display Object, Root Stage
		*/
		/////////////////////////////////////////////////////////////////////////
		
		public function DragDrop( $bar:Object, $pointer:Object, $stage:Stage )
		{
			_bar     = $bar;
			_pointer = $pointer;
			_stage   = $stage;
			
			_pointer.mouseChildren = false;		
			_pointer.addEventListener(MouseEvent.MOUSE_DOWN, downHandler );
		}
		
		
		
		
		/* Event Handler */
		/////////////////////////////////////////////////////////////////////////
		
		// Mouse Down
		private function downHandler(e:MouseEvent):void
		{
			_dragFlg = true;
			_offset = _pointer.x;
			
			_pointer.startDrag(false,new Rectangle(0, _pointer.y, _bar.width, 0));
			_stage.addEventListener(MouseEvent.MOUSE_UP, upHandler );			
			dispatchEvent(new Event(DragDrop.START));
		}
		// Mouse Up
		private function upHandler(e:MouseEvent):void
		{
			if(!_dragFlg) return;
			
			_dragFlg = false;
			_pointer.stopDrag();
			_dist = _pointer.x;
			
			_stage.removeEventListener(Event.ENTER_FRAME, upHandler );
			dispatchEvent(new Event(DragDrop.COMP));
		}
		
		
		
		
		/* Setter & Getter */
		/////////////////////////////////////////////////////////////////////////
		
		//　ドラッグ量を0〜1で返す
		public function get dist():Number
		{
			var per:Number = _dist/_bar.width;
			return per;
		}
		
		
		
		
		
	}
}