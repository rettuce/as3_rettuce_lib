package com.rettuce.imageprocessing
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author rettuce
	 */
	public class ImageProcessing extends EventDispatcher
	{
		public static const START:String = "ImageProcessingStart";
		public static const PROCESSING:String = "ImageProcessing";
		public static const COMPLETE:String = "ImageProcessingComplete";
		
		
		
		
		
		/* 
		* Main Function
		* 
		* 1.ソース元となるBitmapData
		* 2.閾値      → 0〜100
		* 3.エフェクト → 0〜10
		* 4.color    → red , green , blue
		* 5.def      → true , false  デフォルト閾値を使用するかどうか
		* 
		* return     → BitmapData
		*/
		/////////////////////////////////////////////////////////////////////////
		
		public function processing( s:BitmapData, value:Number, modeID:int,
									color:String = null , def:Boolean = false ):BitmapData
		{
			dispatchEvent(new Event(START));
			var d:BitmapData = new BitmapData(s.width, s.height, true, 0xff000000);
			
			switch(modeID) {
				
				case 0: // ノーマル
				d = s;
				break;
				
				case 1: //  明度フィルター  value値　 0 ～ 100 -> 12
				if (def) value = 12;
				d.applyFilter(s, new Rectangle(0, 0, s.width, s.height), new Point(0, 0),
							new ColorMatrixFilter([ 1, 0, 0, 0, value,
														0,  1, 0, 0, value,
														0, 0,  1, 0, value,
														0, 0, 0, 1, 0]));
				break;
				
				case 2: // コントラストフィルター  value値　 0 ～ 1.5 -> 0.4
				if (def) value = 27;
				value = value * 0.015;
				var cont:Number = value;
				d.applyFilter(s, new Rectangle(0, 0, s.width, s.height), new Point(0, 0),
							new ColorMatrixFilter([cont + 1, 0, 0, 0, -(160*cont),
														0, cont + 1, 0, 0, -(160*cont),
														0, 0, cont + 1, 0, -(160*cont),
														0, 0, 0, 1, 0]));
				break;
				
				case 3: // 彩度フィルター  value値　 0 ～ 1.7 -> 1.4
				if (def) value = 82;
				value = value * 0.017;
				var sat:Number = value;
				var n:Number = sat * 2/3 + 1/3;
				var n2:Number = (1 - n) / 2;
				d.applyFilter(s, new Rectangle(0, 0, s.width, s.height), new Point(0, 0),
							new ColorMatrixFilter([n, n2, n2, 0, 0,
														n2, n, n2, 0, 0,
														n2, n2, n, 0, 0,
														0, 0, 0, 1, 0]));
				break;
				
				case 4: // ブラーフィルター  value値　 0 ～ 35 -> 10
				if (def) value = 28.5;
				value = value * 0.35;
				var blur:BlurFilter = new BlurFilter(value, value, 1);
				d.applyFilter(s, new Rectangle(0, 0, s.width, s.height), new Point(0, 0), blur);
				break;
				
				case 5: // セピアフィルター
				d.applyFilter(s, new Rectangle(0, 0, s.width, s.height), new Point(0, 0),
							new ColorMatrixFilter([0.5, 0.5, 0.5, 0, 0,
													 1/3, 1/3, 1/3, 0, 0,
													 1/4, 1/4, 1/4, 0, 0,
													 0, 0, 0, 255, 0]));
				break;
				
				case 6: // ネガポジフィルター
				d.applyFilter(s, new Rectangle(0, 0, s.width, s.height), new Point(0, 0),
							new ColorMatrixFilter([-1,  0,  0, 0, 255,
													  0, -1,  0, 0, 255,
													  0,  0, -1, 0, 255,
													  0,  0,  0, 255, 0]));
				break;
				
				case 7: // Dummy3Dフィルター  value値　-3 ～ -8 -> -5
				if (def) value = 40;
				value = value * 0.05 + 3;
				var e:BitmapData = new BitmapData(s.width, s.height, true, 0xff000000);
				d.copyChannel( s, s.rect, new Point(), 1, 1 );
				e.copyChannel( s, s.rect, new Point(), 4, 4 );				
				d.scroll( -value, 0);
				d.draw(e, null, null, "screen");
				break;
				
				case 8: // BlackONフィルター  value値　 0 ～ 255 -> 50
				if (def) value = 19.6;
				value = value * 2.55;
				var r:Rectangle = new Rectangle(0, 0, s.width, s.height);
				d.fillRect(r, 0xFFFFFFFF);
				d.threshold(s, r, new Point(0, 0), "<=", value, 0xFF000000, 255, true); 
				break;
				
				case 9: // LightningEdgeフィルター  value値　3 ～ 12 -> 8.5
				if (def) value = 61;
				value = value * 0.09 + 3;
				var l:Array = [1, 1, 1,
							   1, -value, 1,
							   1, 1, 1];
				d.applyFilter(s, new Rectangle(0, 0, s.width, s.height), new Point(0, 0),
							  new ConvolutionFilter(3, 3, l));
				break;
				
				case 10: // Illustrationフィルター  toneColor値　Red, Green, Blue -> Blue
				if (def) color = "blue";
				d = smooth_filter(s);
				var stream:ByteArray = d.getPixels(new Rectangle( 0, 0,  d.width, d.height ));
				var _red:Number;
				var _green:Number;
				var _blue:Number;
				if (color == "blue") {
					for(var k = 0; k < stream.length; k+=4){
						_red   = stream[k+1];
						_green = stream[k+2];
						_blue  = stream[k+3];
						
						stream[k+1] = Tone2(_red);
						stream[k+2] = Tone2(_green);
						stream[k+3] = Tone4(_blue);
					}
				} else if (color == "green") {
					for(var j = 0; j < stream.length; j+=4){
						_red   = stream[j+1];
						_green = stream[j+2];
						_blue  = stream[j+3];
						
						stream[j+1] = Tone2(_red);
						stream[j+2] = Tone4(_green);
						stream[j+3] = Tone2(_blue);
					}
				} else if (color == "red") {
					for(var i = 0; i < stream.length; i+=4){
						_red   = stream[i+1];
						_green = stream[i+2];
						_blue  = stream[i+3];
						
						stream[i+1] = Tone4(_red);
						stream[i+2] = Tone2(_green);
						stream[i+3] = Tone2(_blue);
					}
				}
				
				stream.position  = 0;
				var rect : Rectangle = new Rectangle(0, 0, d.width, d.height);
				d.setPixels(rect, stream);
				break;
			}
			
			dispatchEvent(new Event(COMPLETE));
			return d;
		}
		
		
		
		
		/* Illustrationフィルター用 スムース処理 */
		/////////////////////////////////////////////////////////////////////////
		
		// ノイズ除去
        public function smooth_filter(s:BitmapData):BitmapData {
            var d:BitmapData = new BitmapData(s.width, s.height);
            var a:Array = [];
            for (var x:int = 0; x < s.width; x++) {
                for (var y:int = 0; y < s.height; y++) {
                   a[0] = s.getPixel(x - 1, y - 1) ;
                    a[1] = s.getPixel(x - 1, y) ;
                    a[2] = s.getPixel(x - 1, y + 1) ;
                    a[3] = s.getPixel(x, y - 1) ;
                    a[4] = s.getPixel(x, y) ;
                    a[5] = s.getPixel(x, y + 1) ;
                    a[6] = s.getPixel(x + 1, y - 1) ;
                    a[7] = s.getPixel(x + 1, y) ;
                    a[8] = s.getPixel(x + 1, y + 1) ;
                    a[9] = s.getPixel(x - 2, y - 2) ;
                    a[10] = s.getPixel(x - 1, y - 2) ;
                    a[11] = s.getPixel(x , y - 2) ;
                    a[12] = s.getPixel(x + 1, y - 2) ;
                    a[13] = s.getPixel(x + 2, y - 2) ;
                    a[14] = s.getPixel(x + 2, y - 1) ;
                    a[15] = s.getPixel(x + 2, y ) ;
                    a[16] = s.getPixel(x + 2, y + 1) ;
                    a[17] = s.getPixel(x + 2, y + 2) ;
                    a[18] = s.getPixel(x + 1, y + 2) ;
                    a[19] = s.getPixel(x , y + 2) ;
                    a[20] = s.getPixel(x - 1, y + 2) ;
                    a[21] = s.getPixel(x - 2, y + 2) ;
                    a[22] = s.getPixel(x - 2, y + 1) ;
                    a[23] = s.getPixel(x - 2, y ) ;
                    a[24] = s.getPixel(x - 2, y - 1) ;
					
					a.sort(Array.NUMERIC); // ソート
					
					if ( 1500000 >= a[8] - a[0] ) {
						var c:int = a[12]; // 真ん中を取る
						var _red   : uint = (c >> 16) & 0xFF;
						var _green : uint = (c >>  8) & 0xFF;
						var _blue  : uint = (c >>  0) & 0xFF;
						d.setPixel(x, y, (_red << 16) | (_green << 8) | (_blue) ); // 中央値による色の設定
					}else {
						var c2:int = s.getPixel(x, y); // 元データ
						var _red2   : uint = (c2 >> 16) & 0xFF;
						var _green2 : uint = (c2 >>  8) & 0xFF;
						var _blue2  : uint = (c2 >>  0) & 0xFF;
						d.setPixel(x, y, (_red2 << 16) | (_green2 << 8) | (_blue2) ); // 中央値による色の設定
					}
                }
            }
            return d;
        }
		
		private function Tone2(num:uint):uint
		{
			if ( num <= 128 ) {
				num = 0;
			} else {
				num = 255;
			}
			return num
		}
		private function Tone3(num:uint):uint
		{
			if ( num <= 96 ) {
				num = 0;
			} else if ( num > 96 && num <= 160 ) {
				num = 128;
			} else {
				num = 255;
			}
			return num
		}
		private function Tone4(num:uint):uint
		{
			if ( num <= 64 ) {
				num = 0;
			} else if ( num > 64 && num <= 128 ) {
				num = 96;
			} else if ( num > 128 && num <= 192 ) {
				num = 160;
			} else {
				num = 255;
			}
			return num
		}
		
	}
}