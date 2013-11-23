package models
{
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	
	import framework.Animated;
	
	import starling.core.Starling;
	
	public class GameModel extends Animated
	{
		
		private var _world:b2World;
		private var _entities:Vector.<Entity> = new Vector.<Entity>();
		
		public function GameModel()
		{
			super();
		}
		
		public function get world():b2World
		{
			return _world;
		}
		
		override public function advanceTime(time:Number):void {
			super.advanceTime(time);
			for each( var entity:Entity in _entities) {
				entity.updateView();
			}
		}
		
		public function addEntity(entity:Entity):void
		{
			entity.spawn();
			_entities.push(entity);
			Starling.current.stage.addChild(entity.view);
		}
		
		public function init():void
		{
			var worldAABB:b2AABB = new b2AABB();
			worldAABB.lowerBound.Set(-100.0, -100.0);
			worldAABB.upperBound.Set(400.0, 300.0);
			_world = new b2World(worldAABB, new b2Vec2 (0.0, 10.0), true);
		}
	}
}