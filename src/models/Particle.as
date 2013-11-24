package models
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.textures.TextureAtlas;

	public class Particle extends Entity
	{
		[Inject]
		public var _gameAssets:GameAssets;
		
		protected var skins:Dictionary;
		
		protected var polarity:int = 1
		
		public function Particle()
		{
			super();
		}
		
		override public function updateView():void
		{
			x = _pos.x*GameModel.TILE_WIDTH;
			y = (_model.tileManager.getRowsCount() * GameModel.TILE_HEIGHT)-_pos.y*GameModel.TILE_HEIGHT;
		}
		
		protected function setSkin():void
		{
			//var atlas:TextureAtlas = _gameAssets.getAtlas(GameAssetsEnum.general);
			
			skins = new Dictionary;
			skins[-1] = new Quad(2,2,0xFF0000)
			skins[1]  =  new Quad(2,2,0x0000FF)
		}	
		
		override public function spawn():void
		{
			setSkin();
			for each( var image:DisplayObject in skins){
				addChild(image);
			}
			selectSkin();
			super.spawn();
		}
		
		public function selectSkin():void{
			for each( var image:DisplayObject in skins){
				image.visible = false;
			}
			
			skins[polarity].visible = true;
		}
		
		public function getPolarity():int
		{
			return polarity
		}
		
		public function setPolarity(value:int):void
		{
			polarity = value;
			
		}
	}
}