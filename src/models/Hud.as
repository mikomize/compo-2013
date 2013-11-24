package models
{
	import feathers.controls.Label;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.text.TextField;

	public class Hud extends Sprite
	{
		private var _winLabel:TextField;
		
		public function Hud(viewport:Rectangle)
		{
			_winLabel = new TextField(viewport.width,viewport.height,"", "Arial",60,0xFF0000,true);

			addChild(_winLabel);
		}
		
		public function attach(stage:Stage):void
		{
			stage.addChild(this);
		}
		
		public function playerWin(player:String):void
		{
			_winLabel.text = "PLAYER "+player+" WON";
		}
	}
}