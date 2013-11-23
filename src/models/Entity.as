package models
{
	
	import flash.geom.Point;
	
	import starling.display.Sprite;

	public class Entity extends Sprite
	{
		protected var _pos:Point = new Point(0,0);

		[Inject]
		public var _model:GameModel;
		
		public function Entity()
		{
		}
		
		public function spawn():void 
		{

		}
		
		public function updateView():void
		{
			//TODO: matrix transform, camera, pan
			//TODO: matrix transform, camera, pan
			x = _pos.x*30-30;
			y = 600-_pos.y*30-30;
		}
		
		public function setPosition(pt:Point):void
		{
			_pos = pt;
		}
		
		public function getPosition():Point
		{
			return _pos;
		}
		
	}
}