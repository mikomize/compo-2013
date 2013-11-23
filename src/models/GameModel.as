package models
{
	
	import flash.geom.Rectangle;
	
	import framework.Animated;
	
	import maps.ITileManager;
	import maps.Tile;
	
	import robotlegs.bender.framework.api.IInjector;
	
	import starling.core.Starling;
	import starling.events.KeyboardEvent;
	
	public class GameModel extends Animated
	{
		
		public static const TILE_WIDTH:uint = 30;
		public static const TILE_HEIGHT:uint = 30;
		
		
		[Inject]
		public var _injector:IInjector;
		
		private var _entities:Vector.<Entity> = new Vector.<Entity>();
		private var _physicsEngine:PhysicsEngineInterface;
		
		private var _playerA:PlayerA;
		private var _playerB:PlayerB;
		private var _tileManager:ITileManager;
		
		private var _camera:Camera;
		
		
		public function get tileManager():ITileManager
		{
			return _tileManager;
		}

		public function get playerA():PlayerA 
		{
			return _playerA;
		}
		
		public function get playerB():PlayerA 
		{
			return _playerB;
		}
		
		public function GameModel()
		{
			super();
		}
		
		public function get keyPressed():Array
		{
			return _keyPressed;
		}
		
		override public function advanceTime(time:Number):void {
			super.advanceTime(time);
			_physicsEngine.update(time);
			for each( var entity:Entity in _entities) {
				entity.updateView();
			}
			
			var tmp:int = _playerA.y;
			if (_playerB.y > tmp) {
				tmp = _playerB.y;
			}
			_camera.stick(tmp);
		}
		
		public function initPhysics():void {
			_physicsEngine = _injector.instantiateUnmapped(PhysicsEngine1);
			_physicsEngine.initialize();
		}
		
		public function initTailModel():void {
			_tileManager = new LevelManger().init(1);
		}
		
		public function addEntity(entity:Entity):void
		{
			_injector.injectInto(entity);
			entity.spawn();
			_entities.push(entity);
			trace(entity.y);
			_camera.add(entity);
		}
		
		
		public function init():GameModel
		{
			
			bindKeys();
			
			setParentJuggler(Starling.juggler);
			start();
			initTailModel();
			initPhysics();
			
			_camera = new Camera(Starling.current.viewPort, new Rectangle(0, 0, _tileManager.getColumsCount() * TILE_WIDTH, _tileManager.getRowsCount() * TILE_HEIGHT));
			_camera.attach();
			
			_playerA = new PlayerA();
			addEntity(_playerA);
			_playerB = new PlayerB();
			addEntity(_playerB);
			
			for (var i:uint =0;i<_tileManager.getColumsCount();i++) {
				for (var j:uint =0;j<_tileManager.getRowsCount();j++) {
					var tile:Tile = _tileManager.getCell(j, i);
					var tileEntity:TileEntity = new TileEntity(tile);
					addEntity(tileEntity);
				}
			}
			return this;
		}
		
		private var _keyPressed:Array = new Array();
		
		private function keyDown(e:KeyboardEvent):void
		{
			if (_keyPressed.indexOf(e.keyCode) == -1) {
				_keyPressed.push(e.keyCode);
			}
		}
		
		private function keyUp(e:KeyboardEvent):void
		{ 
			var tmp:int = _keyPressed.indexOf(e.keyCode);
			if (tmp != -1) {
				_keyPressed.splice(tmp, 1);
			}
		}
		
		public function bindKeys():void 
		{
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		}
		
		public function unbindKeys():void 
		{
			Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			Starling.current.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
		}
		
		public function dispose():void
		{
			stop();
			unbindKeys();
		}
	}
}