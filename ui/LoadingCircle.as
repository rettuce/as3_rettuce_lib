package com.rettuce.ui
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
		
	/**
	 * ...
	 * @author rettuce
	 * 
	 * addChild( LoadingCircle.instance );
	 * LoadingCircle.instance.init();
	 * LoadingCircle.instance.loadStart();
	 * 
	 * */
	public class LoadingCircle extends Sprite
	{
		private static var _instance:LoadingCircle;
		public static function get instance():LoadingCircle { return _instance ||= new LoadingCircle(); };
		
		private var _timer:Timer;
		private var _canvas:Sprite;
		private var _cnt:uint = 0;
		
		public function LoadingCircle()
		{
			super();
			
			_canvas = addChild(new Sprite()) as Sprite;
						
			addEventListener(Event.ADDED_TO_STAGE, onAddStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveStage);
		}
		
		
		/**
		 * LoadingCircle.instance.init( $size:Number=3, $width:Number=18, $speed:Number=70, $color:Number=0x000000 )<br />
		 * $size  : Ball Size<br />
		 * $width : Circle Width Size<br />	
		 * $speed : Rotation Speed<br />
		 * $color : Ball Color
		**/
		public function init($size:Number=2, $width:Number=15, $speed:Number=50, $color:Number=0x000000):void
		{
			_timer = new Timer( $speed );
			_timer.addEventListener(TimerEvent.TIMER, rotationHandler );
			
			for (var i:int = 0; i < 12; i++) 
			{
				var factor:Number = i/12;
				var c:Sprite = _canvas.addChild( new Sprite() ) as Sprite;
				c.graphics.beginFill( $color, 1-i*0.1 );
				c.graphics.drawCircle( -$size/2,-$size/2, $size );
				c.x = -Math.cos(factor*Math.PI*2-(Math.PI/2))*$width+$size/2;
				c.y = Math.sin(factor*Math.PI*2-(Math.PI/2))*$width+$size/2;
			}
		}		
		public function loadStart():void
		{
			_timer.reset();
			_timer.start();			
		}
		
		private function rotationHandler(e:TimerEvent):void
		{
			_cnt++;
			_canvas.rotation = _cnt*30;
		}

		private function onAddStage(e:Event):void
		{
			stage.addEventListener(Event.RESIZE, resizeHandler);
			resizeHandler(null);
		}
		private function onRemoveStage(e:Event):void
		{
			_cnt = 0;
			if(_timer.running) _timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, rotationHandler );
			stage.removeEventListener(Event.RESIZE, resizeHandler);
		}
		private function resizeHandler(e:Event):void
		{
			this.x = (stage.stageWidth  - this.width + 3 )>>1;
			this.y = (stage.stageHeight - this.height + 3)>>1;
		}
	}
}