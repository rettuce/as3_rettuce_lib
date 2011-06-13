package com.rettuce.simplevideo
{
	import com.rettuce.simplevideo.SimpleVideo;
	import com.rettuce.simplevideo.SimpleVideoPlayer_UI;
	import com.rettuce.ui.DragDrop;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author rettuce
	 * 
	 * 	player = new SimpleVideoPlayer();
	 * 	player.videoSet(videoWidth, videoHeight, $moviePath, autoPlayFlg, replayFlg );
	 * 	addChild(player);
	 * 
	 */
	public class SimpleVideoPlayer extends MovieClip
	{		
		/* Property */
		/////////////////////////////////////////////////////////////////////////
		
		private var video:SimpleVideo;
		private var videoUI:SimpleVideoPlayer_UI;
		
		private var videoWidth:Number;
		private var videoHeight:Number;
		private var vol:Number;
		private var autoFlg:Boolean;
		private var replayFlg:Boolean;
		
				
		
		/* 
		 * Video Setting
		 * VIDEO WIDTH, VIDEO HEIGHT, VIDEO SRC PATH,
		 * AUTO PLAY?, REPLAY PLAY?
		*/
		/////////////////////////////////////////////////////////////////////////
		
		public function videoSet( $width:Number, $height:Number, $moviePath:String,
								  $vol:Number = 0.5, $autoPlayFlg:Boolean=false, $replayFlg:Boolean=false):void
		{
			// PARAMETER SET
			videoWidth  = $width;
			videoHeight = $height;
			vol         = $vol;
			autoFlg     = $autoPlayFlg;
			replayFlg   = $replayFlg;
			
			// VIDEO UI SET
			videoUI = new SimpleVideoPlayer_UI();
			videoUI.y = videoHeight;
			videoUI.volumeUI(vol);
			addChild(videoUI);
			
			// VIDEO SET
			video = new SimpleVideo(videoWidth, videoHeight);
			video.setUrl($moviePath, vol, autoFlg, replayFlg );
			addChild(video);
			
			// Please wait VIDEO INFO LOAD
			video.addEventListener(SimpleVideo.INFO_COMP, videoStart );
			
			// Please wait VIDEO LOAD → loading animation　seek bar
			video.addEventListener(Event.ENTER_FRAME, function(){
				if(video.bytePer>=100) removeEventListener(Event.ENTER_FRAME, arguments.callee);
				videoUI.seek.base.scaleX = video.bytePer;
			})
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
			videoUI.btn_stop.addEventListener(MouseEvent.CLICK,  stopHandler );
			videoUI.addEventListener(SimpleVideoPlayer_UI.CLICK, seekClickHandler );
			
			var dd:DragDrop = new DragDrop(videoUI.seek.base, videoUI.seek.pointer, stage );
			dd.addEventListener(DragDrop.START, dragStartHandler );
			dd.addEventListener(DragDrop.COMP,  dragCompHandler );
			
			videoUI.volume.addEventListener(MouseEvent.CLICK, volumeClickHandler );
			
			if(autoFlg) playHandler(null);
		}
		
		
		
		
		/* Event Handler */
		/////////////////////////////////////////////////////////////////////////
		
		// Play Button
		private function playHandler(e:MouseEvent):void
		{
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
		// volume
		private function volumeClickHandler(e:MouseEvent):void
		{
			var num:Number =  e.currentTarget.mouseX / e.currentTarget.width;
			if(num > 0.85 ) num = 1; 
			if(num < 0.15 ) num = 0;
			video.volume(num);
			videoUI.volumeUI(num);
		}		
		
		
		
		/* Seek bar Handler */
		/////////////////////////////////////////////////////////////////////////
		
		// drag start → seekbar pointer enterframe stop
		private function dragStartHandler(e:Event){
			removeEventListener(Event.ENTER_FRAME, playEnterframeHandler );			
		}		
		// drag stop → seekbar pointer enterframe start
		// e.target.dist で seekの移動量取得
		private function dragCompHandler(e:Event):void
		{
			var num:Number = e.target.dist;
			var vidTime:Number = num * video.total;
			video.seek(vidTime);
			videoUI.seekUI(num);
			videoUI.timeUI(vidTime);
			addEventListener(Event.ENTER_FRAME, playEnterframeHandler );			
		}
		// seek bar click handler
		private function seekClickHandler(e:Event):void
		{
			var num:Number = videoUI.px;
			var vidTime:Number = num * video.total;
			video.seek(vidTime);
			videoUI.seekUI(num);
			videoUI.timeUI(vidTime);
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
			if(!autoFlg){
				video.stop();
				videoUI.stopUI();
				removeEventListener(Event.ENTER_FRAME, playEnterframeHandler );			
			}
		}
		
		
		
	}
}