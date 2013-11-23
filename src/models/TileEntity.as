package models
{
	import flash.geom.Point;
	
	import maps.Tile;
	import maps.TileTypes;
	
	import starling.display.Quad;

	public class TileEntity extends Entity
	{
		
		private var _tile:Tile;
		
		public function TileEntity(tile:Tile)
		{
			_tile = tile;
			super();
		}
		
		override public function spawn():void
		{
			trace(_tile.getAttrib(TileTypes.ROW_ATTR));
			setPosition(new Point(int(_tile.getAttrib(TileTypes.COLUMN_ATTR)), int(_tile.getAttrib(TileTypes.ROW_ATTR))));
			//addChild(new Quad(30, 30, 0x0348820));
		}
	}
}