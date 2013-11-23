package models
{
	import flash.geom.Point;
	
	import starling.display.Quad;

	public class Player extends Entity
	{
		private var _pos:Point = new Point(0,0);
		
		public function Player()
		{
			super();
		}
		
		public function setPosition(pt:Point):void
		{
			_pos = pt;
		}
		
		public function getPosition():Point
		{
			return _pos;
		}
		
		override public function updateView():void
		{
			x = _pos.x;
			y = _pos.y;
		}
		
		override public function spawn():void
		{
			addChild(new Quad(60, 60, 0x00000));
		}
	}
}