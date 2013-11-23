package models
{
	import flash.utils.ByteArray;
	
	import maps.ITileManager;
	import maps.TileManagerV1;

	public class LevelManger
	{
		[Embed(source="../../maps/main.json",mimeType="application/octet-stream")]
		private var level_0:Class;
		
		[Embed(source="../../maps/level_1.json",mimeType="application/octet-stream")]
		private var level_1:Class;
		
		public function LevelManger()
		{
		}
		
		public function init(level:int):ITileManager
		{
			switch(level)
			{
				case 0:
					return loadMaps(level_0);
				case 1:
					return loadMaps(level_1);
				default:
					return null;
			}
		}
		
		private function loadMaps(JSONMap:Class):ITileManager
		{
			var txt:ByteArray = new JSONMap() as ByteArray;
			var jsonArray:Object = JSON.parse(txt.toString());
			return  new TileManagerV1(jsonArray);
		}
	}
}