package com.rettuce.color
{
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.ColorShortcuts;

	public class Brightness
	{
		static private var isColorShortcuts:Boolean = false;

		static private function shortcutsCheck():void
		{
			if(!isColorShortcuts)
			{
				isColorShortcuts = true;
				ColorShortcuts.init();
			}
		}
		
		/**
		 * set color transform
		 * */
		static public function up( $t:*, $bright:Number=0.3, $tin:Number=0.3 ):void
		{
			shortcutsCheck();
			Tweener.addTween( $t,{ _brightness:$bright, time:$tin, transition:'easeOutQuad'});
		}
		static public function down( $t:*, $tout:Number=0.1 ):void
		{
			shortcutsCheck();
			Tweener.addTween( $t,{ _brightness:0, time:$tout, transition:'easeOutQuad'});
		}
	}
}