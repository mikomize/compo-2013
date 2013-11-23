package
{
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2World;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	
	public class Shell extends Sprite
	{
		public function Shell()
		{
			super();
			
			var boxView:DisplayObject = new Quad(20, 30, 0x000000);
			Starling.current.stage.addChild(boxView);
			
			
			var worldAABB:b2AABB = new b2AABB();
			worldAABB.lowerBound.Set(-100.0, -100.0);
			worldAABB.upperBound.Set(400.0, 300.0);
			var world:b2World = new b2World(worldAABB, new b2Vec2 (0.0, 10.0), true);
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.x = 0;
			bodyDef.position.y = 0;
			
			
			var boxDef:b2PolygonDef = new b2PolygonDef();
			boxDef.SetAsBox(20, 30);
			boxDef.density = 1.0;
			boxDef.friction = 0.5;
			boxDef.restitution = 0;
			
			var body:b2Body = world.CreateBody(bodyDef);
			body.CreateShape(boxDef);
			body.SetMassFromShapes();
			
			
			//ground
			
			bodyDef = new b2BodyDef();
			bodyDef.position.Set(0, 150);
			boxDef = new b2PolygonDef();

			boxDef.SetAsBox(300, 10);
			boxDef.friction = 0.3;
			boxDef.density = 0;

			var zbody:b2Body = world.CreateBody(bodyDef);
			zbody.CreateShape(boxDef);
			zbody.SetMassFromShapes();
			
			addEventListener(Event.ENTER_FRAME, function (e:EnterFrameEvent):void {
				world.Step(e.passedTime, 10);
				boxView.x = body.GetPosition().x;
				boxView.y = body.GetPosition().y;
			});
		}
	}
}