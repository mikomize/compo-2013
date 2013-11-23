package models
{
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	
	import framework.Animated;
	
	import maps.ITileManager;
	import maps.LoadMaps;
	import maps.TileManagerV1;
	
	import robotlegs.bender.framework.api.IInjector;
	
	import starling.core.Starling;
	
	public class GameModel extends Animated
	{
		
		[Inject]
		public var _injector:IInjector;
		
		private var _entities:Vector.<Entity> = new Vector.<Entity>();
		private var _physicsEngine:PhysicsEngineInterface;
		
		private var _tileManager:ITileManager;
		
		private var _playerA:Player;
		private var _playerB:Player;
		
		public function get tileManager():ITileManager
		{
			return _tileManager;
		}

		public function get playerA():Player 
		{
			return _playerA;
		}
		
		public function get playerB():Player 
		{
			return _playerB;
		}
		
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
		
		public function initPhysics():void {
			_physicsEngine = _injector.instantiateUnmapped(PhysicsEngine1);
			_physicsEngine.initialize();
		}
		
		public function initTailModel():void {
			_tileManager = new LoadMaps().tileManager;;
		}
		
		public function addEntity(entity:Entity):void
		{
			_injector.injectInto(entity);
			entity.spawn();
			_entities.push(entity);
			Starling.current.stage.addChild(entity);
		}
		
		public function init():GameModel
		{
			_playerA = new Player();
			addEntity(_playerA);
			_playerB = new Player();
			addEntity(_playerB);
			setParentJuggler(Starling.juggler);
			start();
			initTailModel();
			initPhysics();
			return this;
		}
	}
}