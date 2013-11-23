package models
{
	import framework.Assets;
	
	public class GameAssets extends Assets
	{
		
		[Embed(source="../../resources/gfx/general/general.png")]
		public static const generalAtlas:Class;
		
		[Embed(source="../../resources/gfx/general/general.xml", mimeType="application/octet-stream")]
		public static const generalAtlasXml:Class;
		
		public function GameAssets()
		{
			super();
			//addAtlasDefinition(GameAssetsEnum.atlas, atlas, atlasXml);
		}
	}
}