package models
{
	import flash.geom.Point;
	
	import maps.Tile;
	import maps.TileTypes;
	
	import starling.display.Image;
	import starling.textures.TextureAtlas;

	public class TileEntity extends Entity
	{
		
		private var _tile:Tile;
		
		[Inject]
		public var _gameAssets:GameAssets;
		
		override public function updateView():void
		{
			x = _pos.x*GameModel.TILE_WIDTH ;
			y = (_model.tileManager.getRowsCount() * GameModel.TILE_HEIGHT)-(_model.tileManager.getRowsCount()-_pos.y)*GameModel.TILE_HEIGHT -8;
		}
		
		
		public function TileEntity(tile:Tile)
		{
			_tile = tile;
			super();
		}
		
		override public function spawn():void
		{
			var materials:Object = {
				'wood': new Array('wood1', 'wood2', 'wood3', 'wood4', 'wood5', 'wood7'),
				'metal': new Array('metal1'),
				'positive': new Array('metalPlus'),
				'negative': new Array('metalMinus')
			};
			
			var material:String = _tile.getAttrib('material');
			if (material == 'air') {
				return;
			}
			setPosition(new Point(_tile.col, _tile.row));
			var textures:Array = materials[material];
			if (!textures) {
				return;
			}
			var atlas:TextureAtlas = _gameAssets.getAtlas(GameAssetsEnum.general);
			var group = (1<textures.length)? (1&(_tile.col^_tile.row)):0;
			var id = Math.floor(Math.random() * Math.floor((textures.length+1-group)/2))*2+group;
			addChild(new Image(atlas.getTexture(textures[id ]))); 
		}
	}
}