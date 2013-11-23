package models
{
	
	import Box2D.Dynamics.b2Body;
	
	import starling.display.Sprite;

	public class Entity
	{
		
		[Inject]
		public var _model:GameModel;
		
		private var _body:b2Body;
		private var _view:Sprite;
		
		protected var _x:Number;
		protected var _y:Number;
		
		public function get body():b2Body
		{
			return _body;
		}
		
		public function get view():Sprite
		{
			return _view;
		}
		
		public function Entity(x:Number, y:Number)
		{
			_x = x;
			_y = y;
		}
		
		public function spawn():void 
		{
			_body = createBody();
			_view = createView();
		}
		
		public function updateView():void
		{
			_view.x = _body.GetPosition().x;
			_view.y = _body.GetPosition().y;
		}
		
		protected function createBody():b2Body
		{
			return null;
		}
		
		protected function createView():Sprite
		{
			return new Sprite();
		}
	}
}