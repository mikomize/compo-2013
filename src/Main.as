package
{
	import flash.display.Screen;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	
	import bootstrap.Shell;
	
	import starling.core.Starling;
	
	public class Main extends flash.display.Sprite
	{
		
		private var _starling:Starling;
		
		public function Main()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			
			
			Starling.handleLostContext = true;
			
			_starling                     = new Starling(Shell, stage, new Rectangle(0, 0, 960,600));
			_starling.start();
			Starling.current.showStats = true;			


			var screenBounds:Rectangle = Screen.mainScreen.bounds;
			stage.nativeWindow.x = (screenBounds.width - 960) / 2;
			stage.nativeWindow.y = (screenBounds.height - 600) / 2;
			
		}
	}
}