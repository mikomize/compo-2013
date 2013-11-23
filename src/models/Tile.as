package models
{
	public class Tile extends Entity
	{
		
		private var _row:uint;
		private var _col:uint;
		
		public function Tile(row:uint, col:uint)
		{
			_row = row;
			_col = col;
			super();
		}
	}
}