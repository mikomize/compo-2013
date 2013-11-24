package models
{
	import starling.display.Quad;

	public class Shadow extends Entity
	{
		public function Shadow()
		{
			super();
		}
		public function setDistance(distance:Number):void
		{
			
		}
		
		override public function updateView():void
		{
			x = _pos.x*GameModel.TILE_WIDTH;
			y = (_model.tileManager.getRowsCount() * GameModel.TILE_HEIGHT)-_pos.y*GameModel.TILE_HEIGHT;
		}
		
		override public function spawn():void
		{
			addChild(new Quad(30,10, 0x000000));
		}
	}
}