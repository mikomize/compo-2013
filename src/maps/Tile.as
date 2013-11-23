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
	}
}