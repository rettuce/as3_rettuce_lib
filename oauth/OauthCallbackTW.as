package oauth
{
	import com.demonsters.debugger.MonsterDebugger;
	import com.rettuce.controller.WindowJs;
	import com.rettuce.data.Cookie;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	[SWF(width = 465, height = 465, backgroundColor = 0xFFFFFF, frameRate = 60)]
	
	/**
	 * ...
	 * @author rettuce
	 * 
	 * ポップアップページに置くCallback用ドキュメントクラス
	 * Twitter OAuth Callback -> LocalConnection
	 * 
	 */
	public class OauthCallbackTW extends Sprite
	{
		
		/* Property */
		/////////////////////////////////////////////////////////////////////////
		
		private var _access_token:String;
		private var _access_token_secret:String;
		private var _user_id:String;
		private var _screen_name:String;
		
		
		/* Main Function */
		/////////////////////////////////////////////////////////////////////////　
		
		public function OauthCallbackTW()
		{
			MonsterDebugger.initialize(this);
			MonsterDebugger.enabled = false;
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init );
		}
		
		private function init(e:Event = null ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init );
			
			// flash vars 取得
			_access_token        = loaderInfo.parameters.access_token;
			_access_token_secret = loaderInfo.parameters.access_token_secret;
			_user_id = loaderInfo.parameters.user_id;
			_screen_name = loaderInfo.parameters.screen_name;
			
			var obj:Object = { 
				access_token : _access_token,
				access_token_secret : _access_token_secret,
				user_id : _user_id,
				screen_name : _screen_name
			};
			
			MonsterDebugger.trace("obj TW", obj );
			
			var lc:LocalConnection = new LocalConnection();
			lc.send( '_oauth_callbackTW', 'callbackReload', obj );	// connection名は '_'　始まり
			
			var timer:Timer = new Timer(200, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, close );
			timer.start();
		}
		
		private function close(e:TimerEvent):void
		{
			WindowJs.close();
		}
		
	}
}