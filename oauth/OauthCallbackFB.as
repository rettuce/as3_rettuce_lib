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
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	[SWF(width = 465, height = 465, backgroundColor = 0xFFFFFF, frameRate = 60)]
	
	/**
	 * ...
	 * @author rettuce
	 * 
	 * ポップアップページに置くCallback用ドキュメントクラス
	 * faceBook OAuth Callback -> LocalConnection
	 * 
	 */
	public class OauthCallbackFB extends Sprite
	{
		
		/* Property */
		/////////////////////////////////////////////////////////////////////////
		
		private var _access_token:String;
		
		
		/* Main Function */
		/////////////////////////////////////////////////////////////////////////　
		
		public function OauthCallbackFB()
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
			_access_token = loaderInfo.parameters.access_token;
			var obj:Object = { access_token:_access_token };
			
			MonsterDebugger.trace("obj FB", obj );
			
			var lc:LocalConnection = new LocalConnection();
			lc.send( '_oauth_callbackFB', 'callbackReload', obj );	// connection名は '_'　始まり
			
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