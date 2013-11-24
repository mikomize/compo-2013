package models
{
	import starling.display.Image;
	import starling.textures.TextureAtlas;

	public class Shadow extends Entity
	{
		
		[Inject]
		public var _gameAssets:GameAssets;
		
		public var _distance:Number = 0;
		
		public function Shadow()
		{
			super();
		}
		public function setDistance(distance:Number):void
		{
			_distance = Math.min(10, Math.floor(distance - 2));
		}
		
		override public function updateView():void
		{
			x = _pos.x*GameModel.TILE_WIDTH - width/2;
			y = (_model.tileManager.getRowsCount() * GameModel.TILE_HEIGHT)-_pos.y*GameModel.TILE_HEIGHT - 14;
			trace(_distance);
			trace(10 - _distance);
			scaleX = scaleY = (10 - _distance) / 10;
		}
		
		override public function spawn():void
		{
			var atlas:TextureAtlas = _gameAssets.getAtlas(GameAssetsEnum.general);
			addChild(new Image(atlas.getTexture('shadow')));
		}
	}
}