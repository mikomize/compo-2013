package maps
{
	public class Tile
	{
		private var params:Object = {};
		public function Tile(id:int):void
		{
			params['type'] = id;
		}
		public function getAttrib(key:String):String{
			return params['key'];
		}
		
		public function setAttrib(key:String, value:String):void{
			params['key'] = value;
		}
	}
}