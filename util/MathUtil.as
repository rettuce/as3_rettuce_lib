package com.rettuce.util
{
	import funnel.SetPoint;

	/**
	 * ...
	 * @author rettuce
	 */
	public class MathUtil
	{
		
		/** 
		 * MathUtil.map( $value:Number, min1:Number, max1:Number, min2:Number, max2:Number ):Number<br>
		 * analog入力(1024段階)を256段階に丸めるとか<br>
		 * 0-1023 → 0-255 にスケーリングとか
		 */
		static public function map( $value:Number, min1:Number, max1:Number, min2:Number, max2:Number ):Number{
			var val:Number = ($value-min1)*(max2-min2)/(max1-min1)+min2;
			if( val < min2 ) val = min2;
			else if( val > max2 ) val = max2;
			return val;
		}
		
		/** 
		 * MathUtil.setPoint():Boolean<br>
		 * 中間値となる閾値から+-分の不感帯を設定することで閾値を越えた値のぶれを削除する
		 */
		static public var isBool:Boolean = false;
		static public function setPoint():Boolean{
			return false;
		}
		
		
		
		/** 
		 * MathUtil.random( min:Number, max:Number):Number<br>
		 * 2値間でのランダム整数値を返す
		*/
		static public function random(min:Number = 0, max:Number=1):Number{
			return Math.round(Math.random() * ( max - min ) + min);
		}
		
		
		/** 
		 * MathUtil.center( min:Number, max:Number):Number<br>
		 * 2点間の差分*1/2を返す。センター配置用の整数値
		*/
		static public function center(min:Number = 0, max:Number=1 ):Number{
			return int( (max - min)*0.5 + 0.5 );
		}
		
		
		/**
		* MathUtil.dist(A:Object, B:Object):Number<br>
		* 2点間距離を返す
		*/
		static public function length(a:Object, b:Object):Number
		{
			var dx:Number = b.x - a.x;
			var dy:Number = b.y - a.y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		
		/**
		* MathUtil.angle(A:Object, B:Object):Number<br>
		* 2点間の角度（radian）を返す
		*/
		static public function angle(a:Object, b:Object):Number
		{
			var dx:Number = b.x - a.x;
			var dy:Number = b.y - a.y;
			return Math.atan2(dy , dx);
		}
		
		
		/**
		* MathUtil.timeString(num:Number):String<br>
		* Numberを00:00でのStringで返す
		*/		
		static public function timeString(num:Number):String
		{
			var mm:int = Math.floor(num / 60);
			var ss:int = Math.floor(num % 60);
			
			var mmStr:String = new String(); // 分（表示用00）
			var ssStr:String = new String(); // 秒（表示用00）
			
			(mm < 10) ? mmStr = "0" + mm : mmStr = mm.toString();
			(ss < 10) ? ssStr = "0" + ss : ssStr = ss.toString();
			
			var str:String = mmStr + ":" + ssStr;
			return str;
		}
		
		
		
/*      候補
 * 
		
		function xMax(n0:Number, n1:Number):Number {
			var nMax:Number = (n0 > n1) ? n0 : n1;
			return nMax;
		}		
		
		
		
		
		private function sizeReturn( _spW:Number, _spH:Number , num:Number = 1 ):Object {  // 現時点でのwindowに対しての画像のサイズを返す 第3引数はスケール係数
			var perW:Number = _spW / _W ;
			var perH:Number = _spH / _H ;
			var per:Number = Math.max( perW, perH );
			if( num == 0.8 ) per = perH ;
			
			var result:Object = new Object();
			result["W"] = ( _spW / per ) * num ; 					// Fit 時の サイズ横幅
			result["H"] = ( _spH / per ) * num ;   				// Fit 時の サイズ縦幅
			result["X"] =  result["W"] / _spW  ;		// Fit するための スケールX
			result["Y"] =  result["H"] / _spH  ;		// Fit するための スケールY
			return result;
		}
		
		//　ボール移動のステージ外への処理　（跳ね返り）
		private function checkWalls(b:Ball):void
		{
			if(b.x+b.width/2 > stage.stageWidth){
				b.x = stage.stageWidth-b.width/2;					
				b._vx *= _bounce;					
			}else if( b.x-b.width/2 < 0 ){
				b.x = b.width/2;					
				b._vx *= _bounce;					
			}
			
			if( b.y+b.height/2 > stage.stageHeight ){
				b.y = stage.stageHeight-b.height/2;					
				b._vy *= _bounce;	
			}else if( b.y-b.height/2 < 0){
				b.y = b.height/2;					
				b._vy *= _bounce;	
			}
		}
		//　ボール移動のステージ外への処理　（逆側出現）
		private function checkWalls2(b:Ball):void
		{
			if(b.x-b.width/2 > stage.stageWidth){
				b.x = -b.width/2;					
			}else if( b.x+b.width/2 < 0 ){
				b.x = stage.stageWidth+b.width/2;
			}			
			if( b.y-b.height/2 > stage.stageHeight ){
				b.y = -b.height/2;
			}else if( b.y+b.height/2 < 0){
				b.y = stage.stageHeight+b.height/2;
			}
		}
		
		
		*/
		
		
		
		
	}	
}