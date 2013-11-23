package models
{
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;

	public class PhysicsEngine1 implements PhysicsEngineInterface
	{
		
		private var _world:b2World;
		
		public function PhysicsEngine1()
		{
		}
		
		public function initialize(model:GameModel):void
		{
			var worldAABB:b2AABB = new b2AABB();
			worldAABB.lowerBound.Set(-100.0, -100.0);
			worldAABB.upperBound.Set(400.0, 300.0);
			_world = new b2World(worldAABB, new b2Vec2 (0.0, 10.0), true);			
		}
		
		public function update(deltaTimeSeconds:Number):void
		{	
			_world.Step(deltaTimeSeconds, 10);
		}
	}
}