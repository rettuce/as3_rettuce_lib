package com.rettuce.akp.simpleplayer
{
	import assets.AKP_simpleplayer_gui;
	import assets.bitmap.BgSkin;
	
	import com.demonsters.debugger.MonsterDebugger;
	import com.rettuce.util.MathUtil;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author rettuce
	 * 
	 */
	public class AKP_simpleplayer_gui extends assets.AKP_simpleplayer_gui
	{
		
		static public const CLICK:String  = "seek_click";
		
		// assets skin MC
		public var _playBtn:MovieClip;
		public var _pauseBtn:MovieClip;
		public var _time:MovieClip;
		public var _seek:MovieClip;
		public var _volume:MovieClip;
		public var _full:MovieClip;
		
		private var _bg:Sprite;
		private var _px:Number;			// seekbar pointer X position
		private var playFlg:Boolean = false;
		
		public function get bg():Sprite{ return _bg }
		
		/* Constructor */
		/////////////////////////////////////////////////////////////////////////
		
		public function AKP_simpleplayer_gui()
		{
			// init
			_playBtn  = btn_play;
			_pauseBtn = btn_pause;
			_time     = time;
			_seek     = seek;
			_volume   = volume;
			_full     = btn_full;
			
			_bg = addChildAt( new Sprite(), 0) as Sprite;
			_bg.graphics.beginBitmapFill( new BgSkin(), null, true, true );
			_bg.graphics.drawRect(0,0,300,31);
			
			_seek.bar.scaleX = 0;
		}
		
		public function btnSet():void
		{			
			_full.buttonMode =
			_playBtn.buttonMode  = 
			_pauseBtn.buttonMode = 
			_seek.pointer.buttonMode  = 
			_volume.seek.pointer.buttonMode =
			_volume.btn_volume.buttonMode  = true;
			
			_seek.addEventListener(MouseEvent.CLICK, seekClickHandler );
		}
		
		public function infoSet(num:Number):void
		{
			_time.total.text = MathUtil.timeString(num);
		}
		
		
		
		/* Controlle Function */
		/////////////////////////////////////////////////////////////////////////
		
		// 再生
		public function playUI():void{
			playFlg = true;
			_playBtn.visible  = false;
			_pauseBtn.visible = true;
		}
		// 一時停止
		public function pauseUI():void{
			playFlg = false;
			_playBtn.visible  = true;
			_pauseBtn.visible = false;
		}
		// 停止
		public function stopUI():void{
			pauseUI();
			
			_seek.bar.scaleX = 0;
			_seek.pointer.x = 0;
			_time.now.text = MathUtil.timeString(0);
		}
		// 音量
		public function volumeUI(num:Number):void
		{
			_volume.seek.bar.width = num * _volume.seek.bg.width;
			_volume.seek.pointer.x = num * _volume.seek.bg.width;
		}
		// 再生ヘッダ移動 0〜1.0
		public function seekUI(num:Number):void
		{
			_seek.bar.scaleX = num;
			_seek.pointer.x = num * seek.bg.width;
		}
		// 再生時間表示
		public function timeUI(num:Number):void
		{
			_time.now.text = MathUtil.timeString(num);
		}
		
		
		
		/* Custom Function */
		/////////////////////////////////////////////////////////////////////////
		
		private function seekClickHandler(e:MouseEvent):void
		{
			_px = seek.mouseX / seek.width;
			dispatchEvent( new Event(com.rettuce.akp.simpleplayer.AKP_simpleplayer_gui.CLICK));
		}
		
		private function resizeHandler($w:Number, $h:Number):void
		{
			
		}
		
		
		
		
		/* Setter & Getter */
		/////////////////////////////////////////////////////////////////////////
		
		// pointer位置
		public function get px():Number{
			return _px;
		}
		
		
				
	}
}