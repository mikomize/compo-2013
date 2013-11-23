package maps
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class LoadMaps
	{
		[Embed(source="../../maps/level_1.json",mimeType="application/octet-stream")]
		private var JSONMap:Class;
		
		private var _tileManager:ITileManager;
		public function LoadMaps()
		{
			var txt:ByteArray = new JSONMap() as ByteArray;
			var jsonArray:Object = JSON.parse(txt.toString());
			_tileManager = new TileManagerV1(jsonArray);
		}

		public function get tileManager():ITileManager
		{
			return _tileManager;
		}

	}
}