package com.rettuce.graph
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author rettuce
	 * 
	 */	
	public class GraphMath
	{
		private static const RIGHT_ANGLE:Number = Math.PI / 2;		
		public var offset:int = Math.floor(10 * Math.random()) + 1;		
		
		/* Pie 描画 function */
		/////////////////////////////////////////////////////////////////////////////////////////////////
		
		// 描画関数  引数1：graphics　引数2：x　引数3：ｙ　引数4：半径　引数5：扇の角度始点　引数6：扇の角度終点　
		public static function drawPie(g:Graphics, x:Number, y:Number, r:Number, t1:Number, t2:Number ):void
		{
			// 曲線の分割数。多いほど近似の精度は高くなる。
			var div : int = Math.max(1, Math.floor(Math.abs(t1 - t2) / 0.4));
			
			var lx : Number;
			var ly : Number;
			var lt : Number;
			
			for (var i : int = 0; i <= div; i++) {
				var ct : Number = t1 + (t2 - t1) * i / div;
				var cx : Number = Math.cos(ct) * r + x;    
				var cy : Number = Math.sin(ct) * r + y;    
				if (i == 0) {
					g.lineTo(cx, cy);            
				} else {
					var cp : Point = getControlPoint(lx, ly, lt + RIGHT_ANGLE, cx, cy, ct + RIGHT_ANGLE); 
					g.curveTo(cp.x, cp.y, cx, cy);            
				}
				lx = cx;
				ly = cy;
				lt = ct;
			}
		}
		
		public static function getControlPoint(
			x1 : Number, y1 : Number, t1 : Number,
			x2 : Number, y2 : Number, t2 : Number
		) : Point {
			var x12 : Number = x2 - x1;
			var y12 : Number = y2 - y1;
			
			var l12 : Number = Math.sqrt(x12 * x12 + y12 * y12);
			var t12 : Number = Math.atan2(y12, x12);
			var l13 : Number = l12 * Math.sin(t2 - t12) / Math.sin(t2 - t1);
			var x3 : Number = x1 + l13 * Math.cos(t1);
			var y3 : Number = y1 + l13 * Math.sin(t1);
			return new Point(x3, y3);
		}
		
		
	}
}