package com.rettuce.util
{
	/**
	 * ...
	 * @author rettuce
	 */
	public class ArrUtil
	{
		/**
		 * ArrUtil.shuffle(Array):Array
		 * 配列をシャッフルして戻す
		*/
		static public function shuffle(arr:*):*
		{
			var l:uint = arr.length;
			var newArr:* = arr;
			while(l){
				var m:uint = Math.floor(Math.random()*l);
				var n:Object = newArr[--l];
				newArr[l] = newArr[m];
				newArr[m] = n;
			}
			return newArr;
		}
		
	}
}