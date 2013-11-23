package maps
{
	public interface ITileManager
	{
		
		function getRowsCount():int;
		
		function getColumsCount():int;
		
		function getCell(row:int, column:int):Tile;
		
		function serialize():String;
		
		function deserialize():void;
	}
}