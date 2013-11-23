package maps
{
	public class TileType
	{
		var image:String;
		var type:int;
		public function TileType(Object json)
		{
			image = json.image;
			type = json.firstgid;
		}
	}
}