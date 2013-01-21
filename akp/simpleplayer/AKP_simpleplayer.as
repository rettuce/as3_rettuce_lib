package com.rettuce.akp.simpleplayer
{
	import assets.AKP_simpleplayer;
	import assets.bitmap.BgSkin;
	
	import com.demonsters.debugger.MonsterDebugger;
	import com.rettuce.controller.FullScreen;
	import com.rettuce.simplevideo.SimpleVideo;
	import com.rettuce.ui.DragDrop;
	import com.rettuce.util.BmpUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * ...
	 * @author rettuce
	 * 
	 */
	public class AKP_simpleplayer extends assets.AKP_simpleplayer
	{		
		private var video:SimpleVideo;
		private var videoUI:AKP_simpleplayer_gui;		
		private var videoWidth:Number;
		private var videoHeight:Number;
		private var vol:Number;
		private var autoFlg:Boolean;
		private var replayFlg:Boolean;
		private var _frame:Sprite;
		
		private const lineWidth:Number = 1;
		private var _firstbmp:Bitmap;
		private var _playbmp:Bitmap;
		
		// assets skin MC
		private var _autoplay:MovieClip;
		private var _bg:MovieClip;
		
		/* Constructor */
		/////////////////////////////////////////////////////////////////////////
		public function AKP_simpleplayer()
		{			
			_autoplay = autoplay;
			_bg       = bg;			
			_frame = addChild(new Sprite()) as Sprite;
		}
				
		/* 
		 * Video Setting
		 * VIDEO WIDTH, VIDEO HEIGHT, VIDEO SRC PATH,
		 * AUTO PLAY?, REPLAY PLAY?
		*/
		/////////////////////////////////////////////////////////////////////////
		public function videoSet( $width:Number, $height:Number, $moviePath:String, $imgPath:String, $vol:Number = 0.5, $autoPlayFlg:Boolean=false, $replayFlg:Boolean=false):void
		{
			// PARAMETER SET
			videoWidth  = $width;
			videoHeight = $height;
			vol         = $vol;
			autoFlg     = $autoPlayFlg;
			replayFlg   = $replayFlg;
			
			// VIDEO SET
			video = new SimpleVideo(videoWidth, videoHeight);
			video.setUrl($moviePath, vol, autoFlg, replayFlg );
			addChildAt(video, 1);
			
			// autoplay?
			if(!autoFlg){
				_autoplay.visible = true;
			}else{
				_autoplay.visible = false;				
			}
			_autoplay.addEventListener(MouseEvent.ROLL_OVER, mouseHandler );
			_autoplay.addEventListener(MouseEvent.ROLL_OUT,  mouseHandler );
			_autoplay.addEventListener(MouseEvent.CLICK,     playHandler  );
			_autoplay.buttonMode = true;
			
			// movie thumb
			var loader:Loader = new Loader();
			loader.load( new URLRequest( $imgPath ), new LoaderContext(true) );
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, function(e:Event):void{
				_playbmp = _firstbmp = BmpUtil.resize(Bitmap(loader.content), videoWidth, videoHeight );
				_autoplay.addChildAt(_playbmp,0);
			});				
			
			// VIDEO-UI SET
			videoUI = new AKP_simpleplayer_gui();
			videoUI.volumeUI(vol);
			addChildAt(videoUI, 1);
			
			videoUI._playBtn.addEventListener(MouseEvent.ROLL_OVER, mouseHandler );
			videoUI._playBtn.addEventListener(MouseEvent.ROLL_OUT,  mouseHandler );
			videoUI._pauseBtn.addEventListener(MouseEvent.ROLL_OVER, mouseHandler );
			videoUI._pauseBtn.addEventListener(MouseEvent.ROLL_OUT,  mouseHandler );
			videoUI._volume.btn_volume.addEventListener(MouseEvent.ROLL_OVER, mouseHandler );
			videoUI._volume.btn_volume.addEventListener(MouseEvent.ROLL_OUT,  mouseHandler );
			videoUI._full.addEventListener(MouseEvent.ROLL_OVER, mouseHandler );
			videoUI._full.addEventListener(MouseEvent.ROLL_OUT,  mouseHandler );
			
			// fullscreen set
			new FullScreen( stage, videoUI.btn_full );
						
			// Please wait VIDEO INFO LOAD
			video.addEventListener(SimpleVideo.INFO_COMP, videoStart );
			
			// Please wait VIDEO LOAD → loading animation　seek bar
			video.addEventListener(Event.ENTER_FRAME, function(e:Event):void{
				if(video.bytePer>=1) video.removeEventListener(Event.ENTER_FRAME, arguments.callee);
				videoUI.seek.base.scaleX = video.bytePer;
			});
				
			// resize
			stage.addEventListener(Event.RESIZE, resize);
			resizeHandler();
		}
		
		
		
		
		
		/* Video Info Load Complete → Video Start */
		/////////////////////////////////////////////////////////////////////////
		
		private function videoStart(e:Event):void
		{									
			video.removeEventListener(SimpleVideo.INFO_COMP, videoStart );
			video.addEventListener(SimpleVideo.COMP,  videoComplete );
			
			videoUI.btnSet();
			videoUI.infoSet(video.total);
						
			videoUI.btn_play.addEventListener(MouseEvent.CLICK,  playHandler );
			videoUI.btn_pause.addEventListener(MouseEvent.CLICK, pauseHandler );
			videoUI.addEventListener(AKP_simpleplayer_gui.CLICK, seekClickHandler );
			
			var dd:DragDrop = new DragDrop(videoUI.seek.bg, videoUI.seek.pointer, stage );
			dd.addEventListener(DragDrop.START, dragStartHandler );
			dd.addEventListener(DragDrop.COMP,  dragCompHandler );
			dd.addEventListener(DragDrop.MOVE,  dragMoveHandler );
			
			var ddV:DragDrop = new DragDrop(videoUI.volume.seek.bg, videoUI.volume.seek.pointer, stage );
			ddV.addEventListener(DragDrop.MOVE,  dragMoveHandlerVolume );
			ddV.addEventListener(DragDrop.COMP,  dragCompHandlerVolume );
			videoUI.volume.btn_volume.addEventListener(MouseEvent.CLICK, volumeClickHandler );
			
			if(autoFlg) playHandler(null);
			else pauseHandler(null);
		}
		
		
		
		
		/* Event Handler */
		/////////////////////////////////////////////////////////////////////////
		
		// Play Button
		private function playHandler(e:MouseEvent):void
		{
			if(_autoplay.visible) _autoplay.visible = false;
			video.play();
			videoUI.playUI();
			addEventListener(Event.ENTER_FRAME, playEnterframeHandler );
		}
		// Pause Button
		private function pauseHandler(e:MouseEvent):void
		{
			video.pause();
			videoUI.pauseUI();
			removeEventListener(Event.ENTER_FRAME, playEnterframeHandler );			
		}
		// Stop Button
		private function stopHandler(e:MouseEvent):void
		{
			video.stop();
			videoUI.stopUI();
			removeEventListener(Event.ENTER_FRAME, playEnterframeHandler );			
		}

		
		
		
		
		/* Seek bar Handler */
		/////////////////////////////////////////////////////////////////////////
		
		// drag start → seekbar pointer enterframe stop
		private function dragStartHandler(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, playEnterframeHandler );	
		}
		// drag stop → seekbar pointer enterframe start
		// e.target.dist で seekの移動量取得
		private function dragCompHandler(e:Event):void
		{
			var num:Number = (e.target.dist >= 1)? 0.995 : e.target.dist;
			var vidTime:Number = (num * video.total >= video.total)? video.total-1 : num * video.total;
			if(video.bytePer <= num){
				num = video.bytePer-0.1;
				vidTime = num * video.total;
			}			
			video.seek(vidTime);
			videoUI.seekUI(num);
			videoUI.timeUI(vidTime);
			addEventListener(Event.ENTER_FRAME, playEnterframeHandler );			
		}
		// drag move
		// e.target.dist で seekの移動量取得
		private function dragMoveHandler(e:Event):void
		{
			var num:Number = (e.target.dist >= 1)? 0.995 : e.target.dist;
			var vidTime:Number = (num * video.total >= video.total)? video.total-1 : num * video.total;
			if(video.bytePer <= num){
				num = video.bytePer-0.1;
				vidTime = num * video.total;
			}
			video.seek(vidTime);
			videoUI.seekUI(num);
			videoUI.timeUI(vidTime);
		}
		// seek bar click handler
		private function seekClickHandler(e:Event):void
		{
			var num:Number = videoUI.px;
			var vidTime:Number = num * video.total;
			if(video.bytePer <= num){
				num = video.bytePer-0.1;
				vidTime = num * video.total;
			}
			video.seek(vidTime);
			videoUI.seekUI(num);
			videoUI.timeUI(vidTime);
		}
		
		
		
		
		/* Volume Handler */
		/////////////////////////////////////////////////////////////////////////
		
		// e.target.dist で seekの移動量取得
		private function dragMoveHandlerVolume(e:Event):void
		{
			vol = e.target.dist;
			volumeSet(vol);
		}
		// e.target.dist で seekの移動量取得
		private function dragCompHandlerVolume(e:Event):void
		{
			vol = e.target.dist;
			volumeSet(vol);
		}
		// volume click handler
		private var preVolume:Number = 0;
		private function volumeClickHandler(e:MouseEvent):void
		{
			if(preVolume!=0){
				volumeSet(preVolume);
				preVolume = 0;
			}else{
				preVolume = vol;
				volumeSet(0);
			}
		}
		private function volumeSet($vol:Number):void
		{			
			videoUI.volumeUI($vol);
			if($vol==0) videoUI.volume.btn_volume.gotoAndStop(2);
			else videoUI.volume.btn_volume.gotoAndStop(1);
			video.volume($vol);
		}
		
		

		
		
		
		
		
		
		
		
		/* Play enterframe Handler */
		/////////////////////////////////////////////////////////////////////////
				
		private function playEnterframeHandler(e:Event):void
		{
			var num:Number = video.time / video.total;
			videoUI.seekUI(num);
			videoUI.timeUI(video.time);
		}
		
		// VIDEO Play Complete
		private function videoComplete(e:Event):void
		{
			video.stop();
			videoUI.stopUI();
			removeEventListener(Event.ENTER_FRAME, playEnterframeHandler );
			_autoplay.visible = true;
		}
		
			
		private function mouseHandler(e:MouseEvent):void
		{
			var $t:* = e.currentTarget;
			switch(e.type){
				case 'rollOver':{
					$t.filters = [new ColorMatrixFilter([
						1, 0, 0, 0, 35, 
						0, 1, 0, 0, 35, 
						0, 0, 1, 0, 35, 
						0, 0, 0, 1, 0
					])];
					break;
				}
				case 'rollOut':{
					$t.filters = null;					
					break;
				}
			}
		}
		
		private function autoplayHandler(e:MouseEvent):void
		{
			var $t:* = e.currentTarget;
			switch(e.type){
				case 'rollOver':{
					$t.filters = [new ColorMatrixFilter([
						1, 0, 0, 0, -35, 
						0, 1, 0, 0, -35, 
						0, 0, 1, 0, -35, 
						0, 0, 0, 1, 0
					])];
					break;
				}
				case 'rollOut':{
					$t.filters = null;					
					break;
				}
			}
		}
		
		
		
		
		
		/* Resize Event */
		/////////////////////////////////////////////////////////////////////////　
		
		private var MAX_SEEK:Number = 370;

		public function resize(e:Event):void
		{
			videoWidth  = int( stage.stageWidth );
			videoHeight = int( stage.stageHeight ) - 31;
			resizeHandler();
		}
		private function resizeHandler():void
		{
			// video
			video.width  = videoWidth;
			video.height = videoHeight;
			
			// player position set
			_bg.width  = _autoplay.bg.width  = videoWidth;
			_bg.height = _autoplay.bg.height = videoHeight;
			_autoplay.btn.x = int(videoWidth>>1);
			_autoplay.btn.y = int(videoHeight>>1);
			if(_playbmp){
				_autoplay.removeChild(_playbmp);
				_playbmp = BmpUtil.resize(_firstbmp, videoWidth, videoHeight );
				_autoplay.addChildAt(_playbmp,0);				
			}
			
			// frame
			_frame.graphics.clear();
			_frame.graphics.beginFill(0xe1e1e1);
			_frame.graphics.drawRect(0,0,videoWidth, lineWidth);
			_frame.graphics.drawRect(0,lineWidth,lineWidth,videoHeight-(lineWidth*2));
			_frame.graphics.drawRect(0,videoHeight-lineWidth,videoWidth, lineWidth);
			_frame.graphics.drawRect(videoWidth-lineWidth,lineWidth,lineWidth,videoHeight-(lineWidth*2));
			
			// GUI position set
			MAX_SEEK = int(videoWidth - 290);
			
			videoUI.y = videoHeight;
			videoUI.btn_full.x = int(videoWidth - videoUI.btn_full.width);
			videoUI.volume.x   = int(videoUI.btn_full.x - videoUI.volume.width);
			videoUI.line.width = videoWidth;
			
			videoUI.bg.graphics.clear();
			videoUI.bg.graphics.beginBitmapFill( new BgSkin() );
			videoUI.bg.graphics.drawRect(0,0,videoWidth,31);
			
			videoUI.seek.bar.bg.width  = 
			videoUI.seek.base.bg.width = 
			videoUI.seek.bg.bg.width   = MAX_SEEK;
		}
	
		
		
		
		
		
		/*
		 *  coloring
		*/
		
		private var isColoring:Boolean = false;
		private var reverse:ColorMatrixFilter = new ColorMatrixFilter([
			-1, 0, 0, 0, 255,
			0, -1, 0, 0, 255,
			0, 0, -1, 0, 255,
			0, 0, 0, 1, 0
		]);
		public function coloring():void
		{
			isColoring = true;
			videoUI.filters = _autoplay.btn.filters = _bg.filters = _frame.filters = [reverse];
		}
		
		
		
		
		
		
		
		
		
		
		
		
	}
}