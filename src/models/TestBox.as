package models
{
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	
	import starling.display.Quad;
	import starling.display.Sprite;

	public class TestBox extends Entity
	{
		public function TestBox(x:Number, y:Number)
		{
			super(x, y);
		}
		
		override protected function createBody():b2Body
		{
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.x = _x;
			bodyDef.position.y = _y;
			
			
			var boxDef:b2PolygonDef = new b2PolygonDef();
			boxDef.SetAsBox(20, 30);
			boxDef.density = 1.0;
			boxDef.friction = 0.5;
			boxDef.restitution = 0;
			
			var body:b2Body = _model.world.CreateBody(bodyDef);
			body.CreateShape(boxDef);
			body.SetMassFromShapes();
			return body;
		}
		
		override protected function createView():Sprite
		{
			var tmp:Sprite = new Sprite();
			tmp.addChild(new Quad(20, 30, 0x000000));
			return tmp;
		}
	}
}