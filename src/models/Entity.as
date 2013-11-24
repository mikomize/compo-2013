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
			pivotX = width/2;
			pivotY = height/2;
			updateView();
		}
		
		public function updateView():void
		{
			
		}
		
		public function setPosition(pt:Point):void
		{
			_pos = pt;
			updateView();
		}
		
		public function setAngle(angle:Number):void
		{	
			rotation = -angle;
			updateView();
		}
		
		public function getPosition():Point
		{
			return _pos;
		}
		
	}
}