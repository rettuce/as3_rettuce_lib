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
		/** 
		 * BmpUtil.resize(Bitmap, width, height, MaxFlg=true );<br />
		 * 渡されたBitmapを決められた値（W,H）でリサイズして戻す。<br />
		 * MaxFlgは長辺に合わせるか短辺に合わせるかを指定
		*/
		static public function resize(bm:Bitmap, w:Number, h:Number, maxFlg:Boolean=true ):Bitmap
		{			
			var bmNew:Bitmap = new Bitmap( new BitmapData( w, h, true, 0x00000000 ));
			bmNew.smoothing = true;
			
			var per:Number;
			var perW:Number = w / bm.width;
			var perH:Number = h / bm.height ;			
			per = (maxFlg)? Math.max( perW, perH ) : Math.min(perW, perH) ;
			
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