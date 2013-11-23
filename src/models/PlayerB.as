package models
{
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	public class PlayerB extends PlayerA
	{
		public function PlayerB()
		{
			super();
		}
		
		override public function getKeyMappings():Dictionary 
		{
			var t:Dictionary = new Dictionary;
			t[Keyboard.I] = new Point(0, 1);
			t[Keyboard.K] = new Point(0, -1);
			t[Keyboard.J] = new Point(-1, 0);
			t[Keyboard.L] = new Point(1, 0);
			return t;
		}
	}
}