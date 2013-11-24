package maps
{
	public class TileManagerV1 implements ITileManager
	{
		private var rows:int;
		private var columns:int;
		
		private var map:Array = new Array();
		
		private var tiledSets:Array = new Array();
		
		private var _phisicsEngineVersion:String;
		
		private var _bg:String;
		
		private var _bgRepeat:String;
		
		
		public function TileManagerV1():void
		{
		}

		public function getBgRepeat():String
		{
			return _bgRepeat;
		}

		public function getBg():String
		{
			return _bg;
		}

		public function getRowsCount():int{
			return rows;
		}
		
		public function getColumsCount():int{
			return columns;
		}
		
		public function getCell(row:int, column:int):Tile{
			if(map[row] !== undefined && map[row][column] !== undefined)
				return map[row][column];
			return null;
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
				var tiledDeff:Object = {};
				tiledDeff.firstgid = index;
				tiledDeff.properties = tiledSets[index];
				object.tilesets.push(tiledDeff);
			}
			return JSON.stringify(object);
		
		}
		
		public function deserialize(json:Object):ITileManager{
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
			_phisicsEngineVersion = json.properties.phisicsEngineVersion;
			if(json.properties.hasOwnProperty('bg')){
				_bg = json.properties.bg;
			}
			if(json.properties.hasOwnProperty('bgRepeat')){
				_bgRepeat = json.properties.bgRepeat;
			}
			return this;
		}
		
		public function getPhisicsEngineVersion():String{
			return _phisicsEngineVersion;
		}
	}
}