package models
{
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import starling.display.Quad;

	public class PlayerA extends Entity
	{
		
		public function PlayerA()
		{
			super();
		}
		
		
		override public function spawn():void
		{
			addChild(new Quad(60, 60, 0x00000));
		}
		
		public function getKeyMappings():Dictionary 
		{
			var t:Dictionary = new Dictionary;
			t[Keyboard.W] = new Point(0, 1);
			t[Keyboard.S] = new Point(0, -1);
			t[Keyboard.A] = new Point(-1, 0);
			t[Keyboard.D] = new Point(1, 0);
			return t;
		}
		
		public function getIntendedDirection():Point
		{
			var tmp:Point = new Point(0, 0);
			for each(var keyCode:uint in _model.keyPressed) {
				var matched:Point = getKeyMappings()[keyCode];
				if (matched) {
					tmp = tmp.add(matched);
				}
			}
			return tmp;
		}
	}
}