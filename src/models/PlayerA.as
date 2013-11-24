package models
{
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import maps.TileTypes;
	
	import starling.display.Image;
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
			skins[-1] = new Image(atlas.getTexture('p1n'));
			skins[0]  = new Image(atlas.getTexture('p1'));
			skins[1]  =  new Image(atlas.getTexture('p1p'));
		}	
		
		override public function spawn():void
		{
			setSkin();
			for each( var image:Image in skins){
				addChild(image);
			}
			selectSkin();
			super.spawn();
			_state = PlayerA.STATE_PLAY;
		}
		
		public function selectSkin():void{
			for each( var image:Image in skins){
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
			t[Keyboard.C] = -1;
			t[Keyboard.V] = 0;
			t[Keyboard.B] = 1;
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
			for each(var keyCode:uint in _model.keyPressed) {
				var matched:int = getPolarityKeyMappings()[keyCode];
				if (getPolarityKeyMappings().hasOwnProperty(keyCode)) {
					polarity = getPolarityKeyMappings()[keyCode];
					selectSkin();
					break;
				}
			}
			
			return polarity;
		}
	}
}