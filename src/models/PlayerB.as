package models
{
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import starling.display.Image;
	import starling.textures.TextureAtlas;

	public class PlayerB extends PlayerA
	{
		public function PlayerB()
		{
			super();
		}
		
		override protected function getSkin():Image
		{
			var atlas:TextureAtlas = _gameAssets.getAtlas(GameAssetsEnum.general);
			return new Image(atlas.getTexture('k2')); 
		}
		
		override public function getKeyMappings():Dictionary 
		{
			var t:Dictionary = new Dictionary;
			t[Keyboard.I] = new Point(0, 1);
			t[Keyboard.K] = new Point(0, -1);
			t[Keyboard.J] = new Point(-1, 0);
			t[Keyboard.L] = new Point(1, 0);
			return t;
		}
	}
}