package com.rettuce.animation
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class AnimaTime
	{
		/**
		 * perform it $time later<br />
		 * 経過時間(msec)後に関数実行
		 * */
		static public function after( $time:Number, $func:Function ):void
		{
			var timer:Timer = new Timer($time,1);
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void{
				timer.removeEventListener( TimerEvent.TIMER_COMPLETE, arguments.callee );
				timer.stop();
				timer = null;
				$func();
			});
			timer.start();
		}
	}
}