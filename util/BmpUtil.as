package com.rettuce.util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author rettuce
	 */
	public class BmpUtil
	{	
		/* 
		 * BmpUtil.resize(Bitmap, width, height);
		 * 渡されたBitmapを決められた値（W,H）でリサイズして戻す
		*/
		/////////////////////////////////////////////////////////////////////////
		
		static public function resize(bm:Bitmap, w:Number, h:Number ):Bitmap
		{			
			var bmNew:Bitmap = new Bitmap( new BitmapData( w, h ));
			bmNew.smoothing = true;
			
			var per:Number;
			var perW:Number = w / bm.width;
			var perH:Number = h / bm.height ;			
			per = Math.max( perW, perH );
			
			var bmX:int = Math.floor(( w - bm.width * per ) >> 1 );
			var bmY:int = Math.floor(( h - bm.height * per ) >> 1 );
			
			var mat:Matrix = new Matrix();
			mat.scale( per, per );
			mat.translate( bmX , bmY );
			bmNew.bitmapData.draw(bm , mat );
			
			return bmNew;
		}
		
	}	
}