package com.rettuce.util
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * ...
	 * @author rettuce
	 * 
	 * SetPoint.instance.init( threshold, hysteresis );	// 閾値と不感帯ぶれ幅
	 * SetPoint.instance.update(Number);
	 * SetPoint.instance.value:Boolean;
	 * Setpoint.instance.addEventListener(SetPoint.UP_CHANGE, upchangeHandler );
	 * Setpoint.instance.addEventListener(SetPoint.DOWN_CHANGE, downchangeHandler );
	 * */
	public class SetPoint extends EventDispatcher
	{
		private static var _instance:SetPoint;
		public static function get instance():SetPoint { return _instance ||= new SetPoint(); };
		
		static public const UP_CHANGE:String = "upchange";
		static public const DOWN_CHANGE:String = "downchange";
		
		static private var _threshold:Number;	// 閾値		0.5
		static private var _hysteresis:Number;	// ぶれ幅		0.1
		static private var _wasBool:Boolean = false;
		static private var _isBool:Boolean = false;
		static public function get value():Boolean{ return _isBool }
		
		static public function init($threshold:Number=0.5,$hysteresis:Number=0)
		{
			_threshold  = $threshold;
			_hysteresis = $hysteresis;
		}
		
		static public function update($val:Number)
		{
			_isBool = _wasBool;
			if( $val > (_threshold + _hysteresis)){
				_isBool = true;
			}else if( $val < ( _threshold - _hysteresis)){
				_isBool = false;
			}
			
			if( !_wasBool && _isBool ){
				dispatchEvent( new Event(SetPoint.UP_CHANGE) );
			}else if( _wasBool && !_isBool ){
				dispatchEvent( new Event(SetPoint.DOWN_CHANGE) );
			}
			
			_wasBool = _isBool;
		}
		
		
		
	}
}