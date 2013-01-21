package com.rettuce.graph
{
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author rettuce
	 * 
	 * var runTxt:RundomText = new RundomText('message please!!');
	 * runTxt.txtStart(TextField);
	 * 
	 */	
	public class RundomText extends Sprite
	{
		public static const TEXT_ANIMATION_COMP:String = 'textAnimationComplete';
		private const _alp:String = 'abcdefghijklmnopqrstuvwxyz';
		
		private var _txt:TextField;
		public var _msg:String;
		public var _charPos:uint;
		public var _counter:uint;
		public var _offset:int = 4;
		
		public function RundomText($str:String)
		{
			_msg = $str;
		}
		
		public function txtStart($txt:TextField):void
		{
			_txt = $txt;
			addEventListener(Event.ENTER_FRAME, animation);
		}
		private function comp():void
		{
			_charPos = 0;
			removeEventListener(Event.ENTER_FRAME, animation);
			dispatchEvent( new Event(RundomText.TEXT_ANIMATION_COMP) );
		}
		private function animation(e:Event):void
		{
			_txt.text = textAnimation();			
		}
				
		//文字コードを探りながら1文字ずつ追加するアニメーション
		private function textAnimation():String
		{	
			var answer:String;			
			var startCharCode:uint = _msg.charCodeAt(_charPos) - _offset;		//表示したい文字コードより_offsetだけ小さい文字コード
			var char:String = String.fromCharCode(startCharCode + _counter);	//文字コードを文字に変換
			var run:String = (_charPos <= _msg.length-2)? _alp.charAt(Math.floor(Math.random() * _alp.length)) : "" ;
			answer = _msg.substring(0,_charPos) + char + run;				//表示済みのテキストに新しい文字とランダムなアルファベットを連結して表示		

			if (_msg.charAt(_charPos) == char) {								//表示したい文字と比較
				if(_charPos == _msg.length-1){									//すべてのメッセージを表示し終わったかどうか
					answer = _msg;												//文末の "_"を取り去るために_msgを入れ直す
					comp();
				} else {
//					_offset = Math.floor(10 * Math.random()) + 5;
					_charPos++;
					_counter = 0;
				}
			} else {
				_counter++;					//次の文字コードに進む
			};
			return answer;
		}
	}
}