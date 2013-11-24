package models
{
	import flash.utils.ByteArray;
	
	import maps.ITileManager;
	import maps.TileManagerFactory;
	import maps.TileManagerV1;

	public class LevelManger
	{
		[Embed(source="../../maps/main.json",mimeType="application/octet-stream")]
		private var level_0:Class;
		
		[Embed(source="../../maps/level_1.json",mimeType="application/octet-stream")]
		private var level_1:Class;
		
		[Embed(source="../../maps/miko.json",mimeType="application/octet-stream")]
		private var miko:Class;
		
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
				case 2:
					return loadMaps(miko);
				default:
					return null;
			}
		}
		
		private function loadMaps(JSONMap:Class):ITileManager
		{
			var txt:ByteArray = new JSONMap() as ByteArray;
			var jsonArray:Object = JSON.parse(txt.toString());
			var tiledManager:ITileManager = TileManagerFactory.getTiledManager(jsonArray.version);
			
			return  tiledManager.deserialize(jsonArray);
		}
	}
}