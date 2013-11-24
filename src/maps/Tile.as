package maps
{
	public class Tile
	{
		private var _params:Object = {};
		public function Tile(params:Object):void
		{
			_params = JSON.parse(JSON.stringify(params));
		}
		public function getAttrib(key:String):String{
			if(_params.hasOwnProperty(key)){
				return _params[key];
			}
				return null;
		}
		
		public function setAttrib(key:String, value:String):void{
			_params[key] = value;
		}
		
		public function get row():int
		{
			return int(getAttrib(TileTypes.ROW_ATTR));
		}
		
		public function get col():int
		{
			return int(getAttrib(TileTypes.COLUMN_ATTR));
		}
		
		public function get material():String
		{
			return getAttrib(TileTypes.MATERIAL_ATTR);
		}
	}
}