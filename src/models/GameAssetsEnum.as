package models
{
	import framework.Enum;
	
	public class GameAssetsEnum extends Enum
	{
		
		{initEnum(GameAssetsEnum)}
		
		public static const general:GameAssetsEnum = new GameAssetsEnum();
		
		public function GameAssetsEnum()
		{
			super();
		}
	}
}