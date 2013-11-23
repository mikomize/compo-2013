package models
{
	import flash.geom.Point;
	
	import maps.Tile;
	import maps.TileTypes;
	
	import starling.display.Quad;

	public class TileEntity extends Entity
	{
		
		private var _tile:Tile;
		
		override public function updateView():void
		{
			//TODO: matrix transform, camera, pan
			//TODO: matrix transform, camera, pan
			
			x = _pos.x*GameModel.TILE_WIDTH;
			y = (_model.tileManager.getRowsCount() * GameModel.TILE_HEIGHT)-(_model.tileManager.getRowsCount()-_pos.y)*GameModel.TILE_HEIGHT;
		}
		
		
		public function TileEntity(tile:Tile)
		{
			_tile = tile;
			super();
		}
		
		override public function spawn():void
		{
			setPosition(new Point(int(_tile.getAttrib(TileTypes.COLUMN_ATTR)), int(_tile.getAttrib(TileTypes.ROW_ATTR))));
			if (_tile.getAttrib('material') == 'wood') {
				addChild(new Quad(30, 30, 0x0348820));
			}
		}
	}
}