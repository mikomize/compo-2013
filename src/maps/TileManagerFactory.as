package maps
{
	public class TileManagerFactory
	{
		public static function getTiledManager(version:int):ITileManager{
			switch(version)
			{
				case 1:
					return new TileManagerV1();
					
				default:
					return null;
			}
		}
	}
}