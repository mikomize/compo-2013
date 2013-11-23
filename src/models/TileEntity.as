package models
{
	import maps.Tile;

	public class TileEntity extends Entity
	{
		
		private var _tile:Tile;
		
		public function TileEntity(tile:Tile)
		{
			_tile = tile;
			super();
		}
	}
}