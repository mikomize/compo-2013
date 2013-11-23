package maps
{
	public class TileManagerV1 implements ITileManager
	{
		private var rows:int;
		private var columns:int;
		
		private var map:Array = new Array();
		
		private var tiledSets:Array = new Array();
		
		public function TileManagerV1(json:Object):void
		{
			var layer:Object  = json.layers[0];
			rows = layer.height;
			columns = layer.width;
			
			for each(var tileDesc:Object in json.tilesets){
				tiledSets[tileDesc.firstgid] = tileDesc.properties;
			}
			for(var row:int = 0 ; row < rows ; row++){
				map[row] = new Array();
				for(var column:int = 0 ; column < columns ; column++){
					var tileId:int = layer.data[row*columns+column];
					var tile:Tile = new Tile(tiledSets[tileId]);
					tile.setAttrib('tileId',tileId.toString());
					tile.setAttrib(TileTypes.ROW_ATTR,row.toString());
					tile.setAttrib(TileTypes.COLUMN_ATTR,column.toString());
					map[row][column] = tile;
				}	
			}
			
			trace(serialize());
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
		
		public function serialize():String{
			var object:Object = new Object();
			object.layers = new Array();
			object.layers[0] = new Object();
			object.layers[0].height = rows;
			object.layers[0].width = columns;
			object.layers[0].data = new Array();
			for(var row:int = 0 ; row < rows ; row++){
				for(var column:int = 0 ; column < columns ; column++){
					object.layers[0].data[row*columns+column] = (map[row][column] as Tile).getAttrib('tileId');
				}
			}
			object.tilesets = new Array();
			for(var index:Object in tiledSets){
				var tiledDeff:Object = tiledSets[index];
				tiledDeff.firstgid = index;
				object.tilesets.push(tiledDeff);
			}
			return JSON.stringify(object);
		
		}
		
		public function deserialize():void{
			
		}
	}
}