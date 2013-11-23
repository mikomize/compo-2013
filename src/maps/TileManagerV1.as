package maps
{
	public class TileManagerV1 implements ITileManager
	{
		private var rows:int;
		private var columns:int;
		
		private var map:Array = new Array();
		
		public function TileManagerV1(json:Object):void
		{
			var layer:Object  = json.layers[0];
			rows = layer.height;
			columns = layer.width;
			for(var row:int = 0 ; row < rows ; row++){
				map[row] = new Array();
				for(var column:int = 0 ; column < columns ; column++){
					map[row][column] = new Tile(layer.data[row*columns+column]);
				}	
			}
		}
		public function getRowsCount():int{
			return rows;
		}
		
		public function getColumsCount():int{
			return columns;
		}
		
		public function getCell(row:int, column:int):Tile{
			return map[row][column];
		}
		
		public function serialize():void{
			
		}
		
		public function deserialize():void{
			
		}
	}
}