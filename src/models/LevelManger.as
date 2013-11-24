package models
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import maps.ITileManager;
	import maps.TileManagerFactory;
	import maps.TileManagerV1;
	
	import starling.textures.TextureAtlas;

	public class LevelManger
	{
		[Embed(source="../../maps/main.json",mimeType="application/octet-stream")]
		private var level_0:Class;
		
		[Embed(source="../../maps/level_1.json",mimeType="application/octet-stream")]
		private var level_1:Class;
		
		
		[Inject]
		public var _gameAssets:GameAssets;
		
		public function LevelManger()
		{
		}
		
		public function getLevel(level:int):ITileManager
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
		
		public function getLevels():Dictionary
		{
			var atlas:TextureAtlas = _gameAssets.getAtlas(GameAssetsEnum.general);
			var textures:Dictionary = new Dictionary();
			textures[0] = atlas.getTexture('main');
			textures[1] = atlas.getTexture('level_1');
			
			return textures;
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