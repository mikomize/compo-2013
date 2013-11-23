package models
{
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.TextureAtlas;

	public class PlayerA extends Entity
	{
		[Inject]
		public var _gameAssets:GameAssets;
		
		public function PlayerA()
		{
			super();
		}
		override public function updateView():void
		{
			//TODO: matrix transform, camera, pan
			//TODO: matrix transform, camera, pan
			
			x = _pos.x*GameModel.TILE_WIDTH;
			y = (_model.tileManager.getRowsCount() * GameModel.TILE_HEIGHT)-_pos.y*GameModel.TILE_HEIGHT;
		}
		
		protected function getSkin():Image
		{
			var atlas:TextureAtlas = _gameAssets.getAtlas(GameAssetsEnum.general);
			return new Image(atlas.getTexture('k1')); 
		}
		
		
		override public function spawn():void
		{
			addChild(getSkin());
			//addChild(new Quad(60, 60, 0x000000));
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
	}
}