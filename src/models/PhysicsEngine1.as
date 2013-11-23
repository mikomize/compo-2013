package models
{
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2World;
	
	import flash.geom.Point;
	
	public class PhysicsEngine1 implements PhysicsEngineInterface
	{
		
		[Inject]
		public var _model:GameModel;
		
		private var _world:b2World;
		
		private var _unprocessedTime: Number = 0;
		private var _FRAME_DURATION : Number = 1.0/60;
		private var _playerBodies: Vector.<b2Body> = new Vector.<b2Body>();
		public function PhysicsEngine1()
		{
		}
		private function getPlayer(index:Number):PlayerA{
			return index?_model.playerB : _model.playerA;
		}
		private function getRowsCount():Number{
			return 24;
		}
		private function getColsCount():Number{
			return 32;
		}
		private function getSpawnPoint(index:Number):Point{
			return index? new Point(1.5,10) : new Point(4.5,10);		
		}
		private function spawnPlayer(index:Number):b2Body{
			var bodyDef:b2BodyDef = new b2BodyDef();
			var spawnPosition:Point = getSpawnPoint(index);
			bodyDef.position.Set( spawnPosition.x,spawnPosition.y);
			var body:b2Body = _world.CreateBody(bodyDef);
		
			var shapeDef:b2PolygonDef = new b2PolygonDef();
			shapeDef.SetAsBox(1.0, 1.0);
			shapeDef.density = 1.0;
			shapeDef.friction = 0.3;
			body.CreateShape(shapeDef);
			body.SetMassFromShapes();
			return body;
		}
		public function initialize():void
		{
			var worldAABB:b2AABB = new b2AABB();
			worldAABB.lowerBound.Set(0, 0);
			worldAABB.upperBound.Set(getColsCount(), getRowsCount());
			_world = new b2World(worldAABB, new b2Vec2 (0.0, -9.81), true);
			for(var index:Number=0;index<2;++index)
				_playerBodies.push(spawnPlayer(index));
			
		}
		
		public function update(deltaTimeSeconds:Number):void
		{	
			_unprocessedTime += deltaTimeSeconds;
			while(_FRAME_DURATION < _unprocessedTime){
				_step();
			}
		}
		private function _step():void
		{
			_world.Step(_FRAME_DURATION, 10);
			_unprocessedTime -= _FRAME_DURATION;
			for(var index:Number=0;index<2;++index){
				var position:b2Vec2=_playerBodies[index].GetPosition();
				
				getPlayer(index).setPosition(new Point(position.x,position.y));
			}
		}
	}
}