package maps
{
	public interface ITileManager
	{
		
		function getRowsCount():int;
		
		function getColumsCount():int;
		
		function getCell(row:int, column:int):Tile;
		
		function getPhisicsEngineVersion():String;
		
		function getBg():String
		
		function serialize():String;
		
		function deserialize(json:Object):ITileManager;
		
		function getBgRepeat():String
	}
}