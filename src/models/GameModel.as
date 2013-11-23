package models
{
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	
	import framework.Animated;
	
	import starling.core.Starling;
	
	public class GameModel extends Animated
	{
		private var _entities:Vector.<Entity> = new Vector.<Entity>();
		private var _physicsEngine:PhysicsEngineInterface;
		public function GameModel()
		{
			super();
		}
		
		override public function advanceTime(time:Number):void {
			super.advanceTime(time);
			_physicsEngine.update(time);
			for each( var entity:Entity in _entities) {
				entity.updateView();
			}
		}
		
		public function initPhysics():void{
			_physicsEngine = new PhysicsEngine1();
			_physicsEngine.initialize(this);
		}
		
		public function addEntity(entity:Entity):void
		{
			entity.spawn();
			_entities.push(entity);
			Starling.current.stage.addChild(entity);
		}
		
		public function init():GameModel
		{
			setParentJuggler(Starling.juggler);
			start();
			return this;
		}
	}
}