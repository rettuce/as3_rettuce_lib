package com.rettuce.util
{
	/**
	 * ...
	 * @author rettuce
	 */
	public class ArrUtil
	{
		/* 
		 * ArrUtil.shuffle(Array):Array
		 * 配列をシャッフルして戻す
		*/
		/////////////////////////////////////////////////////////////////////////
		
		static public function shuffle(arr:Array):Array
		{
			var l:uint = arr.length;
			var newArr:Array = arr;
			while(l){
				var m:uint = Math.floor(Math.random()*l);
				var n = newArr[--l];
				newArr[l] = newArr[m];
				newArr[m] = n;
			}
			return newArr;
		}
		
	}
}