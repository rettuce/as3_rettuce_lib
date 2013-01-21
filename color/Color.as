package com.rettuce.color
{
	import flash.geom.ColorTransform;

	public class Color
	{
		/**
		 * set color transform
		 * */
		static public function changeColor( $obj:*, $color:Number, $bkFlg:Boolean=true ):*
		{
			var c:Object = colorToRGB($color );
			if($bkFlg) $obj.transform.colorTransform = new ColorTransform(1,1,1,1,c.r,c.g,c.b,0);
			else $obj.transform.colorTransform = new ColorTransform(0,0,0,1,c.r,c.g,c.b,0);
			return $obj;
		}
		
		/**
		 * Change Color RGB
		 * */
		static public function colorToRGB(clr:Number):Object
		{		
			　var r:Number = (clr & 0xFF0000) >> 16;
			　var g:Number = (clr & 0x00FF00) >> 8;
			　var b:Number = clr & 0x0000FF;
			　var obj:Object = {r: r, g: g, b: b};
			　return obj;
		}
		
		/**
		 * Change Color 16 Strings
		 * */
		static public function colorToStrRGB(clr:Number):String
		{	
			　var rgb:String = ("00000" + clr.toString(16)).substr(-6).toUpperCase();	
			　return rgb;
		}
	}
}