package com.rettuce.simplevideo
{
	import com.rettuce.util.MathUtil;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author rettuce
	 * 
	 */
	public class SimpleVideoPlayer_UI extends MovieClip
	{
		/* 
		 * Property 
		 * SimpleVideoPlayer_UI 内に配置してあるMovieClip
		*/
		/////////////////////////////////////////////////////////////////////////
		
		static public const CLICK:String  = "seek_click";
		
		public var btn_play:MovieClip;
		public var btn_pause:MovieClip;
		public var btn_stop:MovieClip;
		public var seek:MovieClip;
		public var time:MovieClip;
		public var volume:MovieClip;
		
		private var _px:Number;			// seekbar pointer X position
		private var playFlg:Boolean = false;
		
		
		/* Constructor */
		/////////////////////////////////////////////////////////////////////////
		
		public function SimpleVideoPlayer_UI()
		{
			seek.bar.scaleX = 0;
		}
		
		public function btnSet():void
		{			
			btn_play.buttonMode  = 
			btn_pause.buttonMode = 
			btn_stop.buttonMode  = 
			seek.pointer.buttonMode  = 
			volume.buttonMode  = true;
			
			seek.addEventListener(MouseEvent.CLICK, seekClickHandler );
		}
		
		public function infoSet(num:Number):void
		{
			time.total.text = MathUtil.timeString(num);
		}
		
		
		
		/* Controlle Function */
		/////////////////////////////////////////////////////////////////////////
		
		// 再生
		public function playUI():void{
			playFlg = true;
			btn_play.visible  = false;
			btn_pause.visible = true;
		}
		// 一時停止
		public function pauseUI():void{
			playFlg = false;
			btn_play.visible  = true;
			btn_pause.visible = false;
		}
		// 停止
		public function stopUI():void{
			playFlg = false;
			btn_play.visible  = true;
			btn_pause.visible = false;
			
			seek.bar.scaleX = 0;
			seek.pointer.x = 0;
			time.now.text = MathUtil.timeString(0);
		}
		// 音量
		public function volumeUI(num:Number):void
		{
			volume.msk.scaleX = num;
		}
		// 再生ヘッダ移動 0〜1.0
		public function seekUI(num:Number):void
		{
			seek.bar.scaleX = num;
			seek.pointer.x = num * seek.bg.width;
		}
		// 再生時間表示
		public function timeUI(num:Number):void
		{
			time.now.text = MathUtil.timeString(num);
		}
		
		
		
		/* Custom Function */
		/////////////////////////////////////////////////////////////////////////
		
		private function seekClickHandler(e:MouseEvent):void
		{
			_px = seek.mouseX / seek.width;
			dispatchEvent( new Event(SimpleVideoPlayer_UI.CLICK));
		}
		
		
		
		/* Setter & Getter */
		/////////////////////////////////////////////////////////////////////////
		
		// pointer位置
		public function get px():Number{
			return _px;
		}
		
		
				
	}
}