package com.rettuce.graph
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author rettuce
	 * 
	 * new PieGraph();
	 * PieGraph.createGraph( start, end, radius, color );
	 * PieGraph.addEventListener( PieGraph.GRAPH_COMP, completeHandler );
	 * 
	 */	
	public class PieGraph extends Sprite
	{
		public static const GRAPH_COMP:String = 'graphComplete';
		
		private var _start:Number;	// 開始 radian
		private var _end:Number;	// 終了 radian
		private var _now:Number;	// 現在 radian
		private var _cnt:Number;	// 追加 radian
		
		private var _speed:Number = 0.12;
		private var _radius:Number;	// 半径
		private var _color:Number;
		
		/**
		 * 0-100% の範囲で start, end, radius, color を設定　
		*/
		public function createGraph( $start:Number=0, $end:Number=30, $radius:Number=100, $color:Number=0x000000 ):void
		{
			_start = $start * Math.PI/180;
			_end   = $end   * Math.PI/180;
			_radius=$radius;
			_color = $color;
			
			var g:Graphics = graphics;
			
			_now = _cnt = _start;
			
			addEventListener( Event.ENTER_FRAME, function():void{
				
				if( _cnt >= _end ){
					removeEventListener( Event.ENTER_FRAME, arguments.callee );
					g.clear();
					g.beginFill(_color);
					GraphMath.drawPie( g, 0, 0, _radius, _start, _end );
					g.endFill();
					dispatchEvent( new Event(PieGraph.GRAPH_COMP) );
					return;
				};
				
				g.clear();
				g.beginFill(_color);
				GraphMath.drawPie( g, 0, 0, _radius, _start, _cnt );
				g.endFill();
				_cnt+=_speed;
			});
		}
		
	}
}