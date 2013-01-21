package com.rettuce.tool
{
	import com.bit101.components.*;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	
	/**
	 * ...
	 * @author rettuce
	 * 
	 */
	public class ConpaneBase extends Sprite
	{
		public static const PARAM_UPDATE:String = 'param_update';
		
		protected var WIDTH:Number;
		protected var HEIGHT:Number;
		
		protected var _stage:Stage;		
		protected var _conpane:Sprite;
		protected var _info:Text;
		protected var _open:PushButton, _close:PushButton;
		
		public function ConpaneBase($stage:Stage, $W:Number=290, $H:Number=300 )
		{
			_stage = $stage;
			_conpane = addChild( new Sprite() ) as Sprite;
			
			WIDTH  = $W;
			HEIGHT = $H;
			
			var bg:Sprite = _conpane.addChild(new Sprite()) as Sprite;
			bg.graphics.beginFill( 0xEEEEEE );
			bg.graphics.drawRect(0,0,WIDTH,HEIGHT);
			bg.filters = [new DropShadowFilter(0,0,0,0.7)]
			
			_close = new PushButton( _conpane, WIDTH-40, 5, "close", function(e:Event):void{
				_conpane.visible = false;
				_open.visible = true;
			});
			_close.width = 35;
			_close.height = 15;
			
			_open = new PushButton( this, 5, 5, "open", function(e:Event):void{
				_conpane.visible = true;
				_open.visible = false;
			});
			_open.width = 35;
			_open.height = 15;
			_open.visible = false;
						
			_info = new Text(_conpane, WIDTH-105, 25, "");
			_info.width  = 100;
			_info.height = HEIGHT - 30;
						
			_conpane.x = _stage.stageWidth - WIDTH - 5;
			_conpane.y = 5;
			_open.x = _stage.stageWidth - _open.width - 5;
			
			bg.addEventListener( MouseEvent.MOUSE_DOWN, drugstart );			
			_stage.addEventListener(MouseEvent.MOUSE_UP, drugstop);
			
			conpaneMain();
		}
		private function drugstart(e:MouseEvent):void{ _conpane.startDrag() }
		private function drugstop(e:MouseEvent):void{ _conpane.stopDrag() }
		
		
		
		/**
		 * OverRide用
		**/
		public function conpaneMain():void{}
	}
}