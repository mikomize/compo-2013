package models
{
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import maps.TileTypes;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureAtlas;

	public class PlayerA extends Entity
	{
		
		public static const STATE_PLAY = 0;
		public static const STATE_DEATH = 1;
		public static const STATE_WIN = 2;
		
		[Inject]
		public var _gameAssets:GameAssets;
		
		protected var polarity:int = 0
			
		protected var skins:Dictionary;
		
		protected var _state:int = PlayerA.STATE_DEATH;
		
		public function PlayerA()
		{
			super();
		}

		public function get state():int
		{
			return _state;
		}

		override public function updateView():void
		{
			x = _pos.x*GameModel.TILE_WIDTH;
			y = (_model.tileManager.getRowsCount() * GameModel.TILE_HEIGHT)-_pos.y*GameModel.TILE_HEIGHT;
			if(_model.tileManager.getCell(_model.tileManager.getRowsCount() - 1 - Math.floor(_pos.y),Math.floor(_pos.x)).getAttrib(TileTypes.FINISH_POINT_ATTR)){
				_state = PlayerA.STATE_WIN;
				_model.hud.playerWin(playerName);
			}
		}
		
		public function get playerName():String
		{
			return "A";
		}	
		
		protected function setSkin():void
		{
			var atlas:TextureAtlas = _gameAssets.getAtlas(GameAssetsEnum.general);
			
			skins = new Dictionary;
			skins[-1] = buildSkin('B');
			skins[0]  = buildSkin('N');
			skins[1]  = buildSkin('R');
		}	
		
		protected function buildSkin(pol:String):Sprite
		{
			var atlas:TextureAtlas = _gameAssets.getAtlas(GameAssetsEnum.general);
			var tmp:Sprite = new Sprite();
			tmp.addChild(new Image(atlas.getTexture(playerName + '/' + pol + '/' + '1')));
			tmp.addChild(new Image(atlas.getTexture(playerName + '/' + pol + '/' + '2')));
			var rot:Sprite = new Sprite();
			rot.pivotX = tmp.width/2;
			rot.pivotY = tmp.height/2;
			rot.x = tmp.width/2;
			rot.y = tmp.height/2;
			rot.addChild(new Image(atlas.getTexture(playerName + '/' + pol + '/' + '3')));
			rot.addEventListener(Event.ENTER_FRAME, function ():void {
				rot.rotation = - _angle;
			});
			tmp.addChild(rot);
			tmp.addChild(new Image(atlas.getTexture(playerName + '/' + pol + '/' + '4')));
			return tmp;
		}
		
		override public function spawn():void
		{
			setSkin();
			
			for each( var image:DisplayObject in skins){
				addChild(image);
			}
			selectSkin();
			super.spawn();
			_state = PlayerA.STATE_PLAY;
		}
		
		public function selectSkin():void{
			for each( var image:DisplayObject in skins){
				image.visible = false;
			}
			skins[polarity].visible = true;
		}
		
		public function getKeyMappings():Dictionary 
		{
			var t:Dictionary = new Dictionary;
			t[Keyboard.W] = new Point(0, 1);
			t[Keyboard.S] = new Point(0, -1);
			t[Keyboard.A] = new Point(-1, 0);
			t[Keyboard.D] = new Point(1, 0);
			return t;
		}
		
		public function getPolarityKeyMappings():Dictionary 
		{
			var t:Dictionary = new Dictionary;
			t[Keyboard.R] = -1;
			t[Keyboard.T] = 1;
			return t;
		}
		
		public function getIntendedDirection():Point
		{
			var tmp:Point = new Point(0, 0);
			for each(var keyCode:uint in _model.keyPressed) {
				var matched:Point = getKeyMappings()[keyCode];
				if (matched) {
					tmp = tmp.add(matched);
				}
			}
			return tmp;
		}
		public function getPolarity():int
		{
			polarity = 0;
			selectSkin();
			for each(var keyCode:uint in _model.keyPressed) {
				
				var matched:int = getPolarityKeyMappings()[keyCode];
				if (matched) {
					polarity = getPolarityKeyMappings()[keyCode];
					selectSkin();
					break;
				}
			}
			
			return polarity;
		}
		
		protected var _angle:Number = 0;
		
		override public function setAngle(angle:Number):void
		{	
			_angle = angle;
			updateView();
		}
	}
}