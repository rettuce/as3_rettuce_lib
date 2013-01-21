package com.rettuce.util
{
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class TxtUtil
	{
		/**
		 * 	letter spacing
		 * 	配置済みのTextFieldでclearされる letter spacing を調整する
		 */
		static public function setLetterSpacing( $tf:TextField, $space:Number ):void
		{
			var format:TextFormat = new TextFormat();
			format.letterSpacing = $space;
			$tf.setTextFormat(format);			
		}
		
		/**
		 * 	文章中から @screen_name とか #hashtag とか取得する<br />
		 *  obj.start : index start<br />
		 *  obj.end   : index end<br />
		 *  obj.txt   : 該当テキスト
		 */
		static public function extract( $txt:String, $isAt:Boolean=true ):Array
		{
			var txts:Array=[];
			if($txt.indexOf(($isAt)?'@':'#')!=-1){
				var patternAt:RegExp   = /@[-_a-zA-Z0-9]++/g;	// @から半角英数字以外まで繰り返し
				var patternHash:RegExp = /#[-_a-zA-Z0-9]++/g;	// #から半角英数字以外まで繰り返し
				var pattern:RegExp = ($isAt)? patternAt : patternHash;
				var resultAtObj:Object = pattern.exec($txt);
				
				var leng:int = 0;
				while(resultAtObj != null)
				{
					var obj:Object = {
						'start': resultAtObj.index ,
						'end'  : resultAtObj.index + resultAtObj[0].length,
						'txt'  : resultAtObj[0]
					};
					txts.push(obj);
					resultAtObj = pattern.exec($txt);
				}
			};
			return txts;
		}
		
	}
}