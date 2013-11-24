package models
{
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import starling.display.Image;
	import starling.textures.TextureAtlas;

	public class PlayerB extends PlayerA
	{
		public function PlayerB()
		{
			super();
		}
		

		override public function get playerName():String
		{
			return "B";
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
		
		override public function getPolarityKeyMappings():Dictionary 
		{
			var t:Dictionary = new Dictionary;
			t[Keyboard.LEFTBRACKET] = -1;
			t[Keyboard.RIGHTBRACKET] = 1;
			return t;
		}
	}
}