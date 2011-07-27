package com.rettuce.simplevideo
{
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	/**
	 * ...
	 * @author rettuce
	 * 
	 * 	var video:SimpleVideo = new SimpleVideo(videoWidth, videoHeight);
	 * 	video.setUrl($moviePath, autoPlayFlg, replayFlg );
	 * 	addChild(video);
	 * 
	 */
	public class SimpleVideo extends Video
	{
		
		/* Property */
		/////////////////////////////////////////////////////////////////////////
		
		public static const INFO_COMP:String  = "video_info_complete";
		public static const START:String = "video_start";
		public static const COMP:String  = "video_complete";
		
		private var info:Object;		
		private var nc:NetConnection;
		private var ns:NetStream;
		private var URL:String;
		private var vol:Number;
		private var playFlg:Boolean = false;
		private var autoFlg:Boolean = false;
		private var replayFlg:Boolean = false;
		
		
				
		/* Constructor */
		/////////////////////////////////////////////////////////////////////////
		
		public function SimpleVideo(width:int=320, height:int=240)
		{
			super(width, height);
			smoothing = true;
		}
		
		
		
		
		/* 
		 * Set URL
		 * VIDEO SRC PATH, AUTO PLAY?, REPLAY PLAY?
		*/
		/////////////////////////////////////////////////////////////////////////
		
		public function setUrl(url:String, $vol:Number = 0.5,
							   $autoFlg:Boolean = false, $replayFlg:Boolean = false):void
		{
			URL = url;
			vol = $vol;
			autoFlg = $autoFlg;
			replayFlg = $replayFlg;
			
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			nc.connect(null);			
		}
		
		private function onNetStatus(e:NetStatusEvent):void
		{
			if (e.info.code=="NetConnection.Connect.Success") {
				//ストリームの生成
				ns = new NetStream(nc);
				ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
				
				//メタデータの取得
				var obj:Object=new Object();
				obj.onMetaData = onMetaData;
				ns.client = obj;
				
				attachNetStream(ns);
				
				//ビデオの再生
				ns.play(URL);
				
				// 音量設定
				volume(vol);
				
				if(!autoFlg){
					//一旦停止
					ns.pause();
				}
			}
			//再生
			else if (e.info.code == "NetStream.Play.Start"){
				dispatchEvent(new Event(SimpleVideo.START));
			}
			//停止
			else if (e.info.code=="NetStream.Play.Stop") {
				stop();
				if(replayFlg) play();
				dispatchEvent(new Event(SimpleVideo.COMP));				
			}
			//エラー
			else if (e.info.level=="error") {
				trace("Error : videoPlayer");
				trace("Error : "+e.info.code);
			}			
		}
		
		//メタデータ取得イベントのコールバック処理
		private function onMetaData($info:Object):void {
			info = $info;
			dispatchEvent(new Event(SimpleVideo.INFO_COMP));
		}
		
		//セキュリティーエラーイベントの処理
		private function onSecurityError(e:SecurityErrorEvent):void {
			trace("SecurityError : videoPlayer");
		}
		
		//同期エラーイベントの処理        
		private function onAsyncError(e:AsyncErrorEvent):void {
			trace("AsyncErrorEvent : videoPlayer");
		}
		
		
		
		/* Controlle Function */
		/////////////////////////////////////////////////////////////////////////
		
		// 再生
		public function play():void{
			ns.resume();
			playFlg = true;
		}
		// 一時停止
		public function pause():void{
			ns.pause();
			playFlg = false;
		}
		// 停止
		public function stop():void{
			ns.pause();
			ns.seek(0);
			playFlg = false;
		}
		// 再生ヘッダ移動
		public function seek(num:Number = 0):void{
			if(num > info.duration) return;
			ns.seek(num);
		}
		// 終了
		public function close():void{
			ns.close();
			playFlg = false;
		}
		// 音量
		public function volume(num:Number):void
		{
			if(num > 1) return;
			var st:SoundTransform = ns.soundTransform;
			st.volume = num;
			ns.soundTransform = st;
		}
		
		
		
		/* Setter & Getter */
		/////////////////////////////////////////////////////////////////////////
		
		// 現在時間
		public function get time():Number{
			return ns.time;
		}
		// 総時間
		public function get total():Number{
			return info.duration;
		}
		// 映像の幅
		public function get srcWidth():Number{
			return info.width;
		}
		// 映像の高さ
		public function get srcHeight():Number{
			return info.height;
		}
		// 映像のfps
		public function get fps():Number{
			return info.framerate;
		}
		// ロード状況
		public function get bytePer():Number{
			return ns.bytesLoaded / ns.bytesTotal;
		}
		// 再生中かどうか
		public function get playing():Boolean{
			return playFlg;
		}
		
		
		
	}
}