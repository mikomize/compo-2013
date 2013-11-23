package maps
{
	public class Tile
	{
		private var _params:Object = {};
		public function Tile(params:Object):void
		{
			_params = params;
		}
		public function getAttrib(key:String):String{
			return _params[key];
		}
		
		public function setAttrib(key:String, value:String):void{
			_params[key] = value;
		}
	}
}