package com.rettuce.ui
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author rettuce
	 * 
	 * LoadingBar.instance.update(Number);
	 * 
	 * */
	public class LoadingBar extends Sprite
	{
		private static var _instance:LoadingBar;
		public static function get instance():LoadingBar { return _instance ||= new LoadingBar(); };
		
		private var COLOR_0:Number = 0x444444;
		private var COLOR_1:Number = 0x999999;
		private var _base:Sprite;
		private var _bar:Sprite;
		
		public function LoadingBar()
		{
			super();
			
			_base = addChild( new Sprite() ) as Sprite;
			_bar  = addChild( new Sprite() ) as Sprite;
			
			_base.graphics.beginFill( COLOR_1 );
			_bar.graphics.beginFill( COLOR_0 );
			
			_base.graphics.drawRect(0,0,150,1);
			_bar.graphics.drawRect(0,0,150,1);
			
			reset();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveStage);
		}
		
		public function update($per:Number):void
		{
			if($per<1){
				this.visible = true;
				_bar.scaleX = $per;
			}else{
				reset();
			}
		}
		
		public function reset():void
		{
			this.visible = false;
			_bar.scaleX = 0;
		}
		
		private function onAddStage(e:Event):void
		{
			stage.addEventListener(Event.RESIZE, resizeHandler);
			resizeHandler(null);
		}
		
		private function onRemoveStage(e:Event):void
		{
			stage.removeEventListener(Event.RESIZE, resizeHandler);
		}
		
		private function resizeHandler(e:Event):void
		{
			this.x = (stage.stageWidth  - this.width)>>1;
			this.y = (stage.stageHeight)>>1;
		}
	}
}