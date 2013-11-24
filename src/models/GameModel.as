package models
{
	
	import bootstrap.FSM;
	
	import feathers.display.TiledImage;
	
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import framework.Animated;
	
	import maps.ITileManager;
	import maps.Tile;
	
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	import robotlegs.bender.framework.api.IInjector;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.KeyboardEvent;
	import starling.textures.TextureAtlas;
	
	public class GameModel extends Animated
	{
		
		public static const TILE_WIDTH:uint = 30;
		public static const TILE_HEIGHT:uint = 30;
		public static const PARTICLE_COUNT:uint = 100;
		
		[Inject]
		public var _injector:IInjector;
		
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		[Inject]
		public var _stage:Stage;
		
		[Inject]
		public var _global:Global;
		
		[Inject]
		public var _levelManger:LevelManger;
		
		[Inject]
		public var _gameAssets:GameAssets;
		
		private var _entities:Vector.<Entity> = new Vector.<Entity>();
		private var _physicsEngine:PhysicsEngineInterface;
		public var particles:Vector.<Particle> = new Vector.<Particle>();
		private var _playerA:PlayerA;
		private var _playerB:PlayerB;
		private var _tileManager:ITileManager;
		
		private var _camera:Camera;
		
		private var _hud:Hud;
		
		
		public function get hud():Hud
		{
			return _hud;
		}

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
			stickCameraToPlayer();
			finishCheck();
		}
		
		private function stickCameraToPlayer():void 
		{
			var tmp:int = _playerA.y;
			if (_playerA.state == PlayerA.STATE_PLAY && _playerB.state == PlayerA.STATE_PLAY && _playerB.y > tmp) {
				tmp = _playerB.y;
			} else if(_playerA.state == PlayerA.STATE_PLAY ){
				tmp = _playerA.y;
			} else {
				tmp = _playerB.y;
			}
			_camera.stick(tmp);
		}
		
		private function finishCheck():void {
			if(playerA.state == PlayerA.STATE_WIN && playerB.state == PlayerA.STATE_WIN)
			{
				dispose();
				eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, FSM.FINISH));
			}
		}
		
		public function initPhysics(chosen:String):void {
			var physics:Dictionary = new Dictionary();
			physics['qbolec'] = PhysicsEngine1;
			physics['qbolectweakedbymiko'] = PhysicsEngine2;
			_physicsEngine = _injector.instantiateUnmapped(physics[chosen]);
			_physicsEngine.initialize();
		}
		
		public function initTailModel():void {
			_tileManager = _levelManger.getLevel(_global.level);
		}
		
		public function addEntity(entity:Entity):void
		{
			_injector.injectInto(entity);
			entity.spawn();
			_entities.push(entity);
			_camera.add(entity);
		}
		
		
		public function init():GameModel
		{
			
			bindKeys();
			
			setParentJuggler(Starling.juggler);
			start();
			initTailModel();
			_camera = new Camera(Starling.current.viewPort, new Rectangle(0, 0, _tileManager.getColumsCount() * TILE_WIDTH, (_tileManager.getRowsCount()) * TILE_HEIGHT));
			_camera.attach(_stage);
			
			_hud = new Hud(Starling.current.viewPort);
			_hud.attach(_stage);
			
			var i:int;
			for (i=0;i<PARTICLE_COUNT;++i){
				var particle:Particle = new Particle();
				particles.push(particle);
				addEntity(particle);
			}
			initPhysics(tileManager.getPhisicsEngineVersion());
			
			if(_tileManager.getBg()){
				var atlas:TextureAtlas = _gameAssets.getAtlas(GameAssetsEnum.general);
				var image:TiledImage = new TiledImage(atlas.getTexture(_tileManager.getBg()))
				image.height = _tileManager.getRowsCount() * TILE_HEIGHT;
				_camera.add(image);
			}
			
			for (i =0;i<_tileManager.getColumsCount();i++) {
				for (var j:int =_tileManager.getRowsCount() - 1;j>=0;j--) {
					var tile:Tile = _tileManager.getCell(j, i);
					var tileEntity:TileEntity = new TileEntity(tile);
					addEntity(tileEntity);
				}
			}
			
			_playerA = new PlayerA();
			addEntity(_playerA);
			_playerB = new PlayerB();
			addEntity(_playerB);
			
			
			return this;
		}
		
		private var _keyPressed:Array = new Array();
		
		private function keyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.P) {
				stickCameraToPlayer();
			}
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
			_hud.removeFromParent(true);
			_camera.detach();
			stop();
			unbindKeys();
		}
	}
}