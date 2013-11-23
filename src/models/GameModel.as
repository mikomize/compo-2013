package models
{
	import framework.Animated;
	
	import maps.ITileManager;
	import maps.LoadMaps;
	import maps.Tile;
	import maps.TileTypes;
	
	import robotlegs.bender.framework.api.IInjector;
	
	import starling.core.Starling;
	import starling.events.KeyboardEvent;
	
	public class GameModel extends Animated
	{
		
		[Inject]
		public var _injector:IInjector;
		
		private var _entities:Vector.<Entity> = new Vector.<Entity>();
		private var _physicsEngine:PhysicsEngineInterface;
		
		private var _playerA:PlayerA;
		private var _playerB:PlayerB;
		private var _tileManager:ITileManager;
		
		
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
		}
		
		public function initPhysics():void {
			_physicsEngine = _injector.instantiateUnmapped(PhysicsEngine1);
			_physicsEngine.initialize();
		}
		
		public function initTailModel():void {
			_tileManager = new LoadMaps().tileManager;
			
			for (var i:uint =0;i<_tileManager.getColumsCount();i++) {
				for (var j:uint =0;j<_tileManager.getRowsCount();j++) {
					var tile:Tile = _tileManager.getCell(j, i);
					var tileEntity:TileEntity = new TileEntity(tile);
					addEntity(tileEntity);
				}
			}
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
			_playerA = new PlayerA();
			addEntity(_playerA);
			_playerB = new PlayerB();
			bindKeys();
			addEntity(_playerB);
			setParentJuggler(Starling.juggler);
			start();
			initTailModel();
			initPhysics();
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