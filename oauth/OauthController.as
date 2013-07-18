package oauth
{
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;

	public class OauthController extends Sprite
	{
		static private const URL_fb:String = "http://lab.rettuce.com/oauth/scd/fb/login.php";
		static private const URL_tw:String = "http://lab.rettuce.com/oauth/scd/tw/login.php";
		
		static public var token:String;
		static public const OAUTH_COMP:String = 'oauth_comp';
		
		private var _lc:LocalConnection;
		private var _isFB:Boolean = false;
		
		public function OauthController(){}
		
		public function oauthAccess(isFB:Boolean=true):void{
			_isFB = isFB;
			if ( !token ) {
				var str:String = (_isFB)? URL_fb : URL_tw ;
				localConnectionSet();
				ExternalInterface.call("function(){ window.open('"+str+"','popup', 'width=600, height=400'); void(0);}");
			}
		}
		
		/* LocalConnection Setting */
		/////////////////////////////////////////////////////////////////////////　
		
		private function localConnectionSet():void
		{
			_lc = new LocalConnection();
			_lc.client = this;
			_lc.allowDomain('*');
			if(_isFB) _lc.connect('_oauth_callbackFB');	// connection名は '_'　始まり
			else _lc.connect('_oauth_callbackTW');
		}
		public function callbackReload($obj:Object):void
		{
			MonsterDebugger.trace("OAuth callback.", $obj);
			token = $obj.access_token;
			dispatchEvent( new Event( OAUTH_COMP ) );
		}
	}
}