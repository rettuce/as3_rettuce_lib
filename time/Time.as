package com.rettuce.time
{
	
	/**
	 * ...
	 * @author rettuce
	 * 
	 */	
	public class Time
	{
		/* 
		* Time.timeString(num:Number):String
		* Numberを00:00でのStringで返す
		*/
		/////////////////////////////////////////////////////////////////////////
		
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
		
		
		/* 
		* Time.timeObj($date:Date):Object
		* Objectで返す
		*/
		/////////////////////////////////////////////////////////////////////////
		
		static public function timeObj($date:Date):Object
		{
			var wdays:Array = ['日','月','火','水','木','金','土'];
			var obj:Object = new Object();
			obj['year']  = $date.getFullYear();
			obj['month'] = $date.getMonth() +1;
			obj['day']   = $date.getDate();
			obj['week']  = wdays[$date.getDay()]
			obj['hour']  = $date.getHours();
			obj['min']   = $date.getMinutes();
			obj['sec']   = $date.getSeconds();
			return obj;
		}

		
		
		
		
	}
}