package
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import bootstrap.ContextConfig;
	import bootstrap.Shell;
	
	import robotlegs.bender.bundles.mvcs.MVCSBundle;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.Context;
	
	import starling.core.Starling;
	
	public class Main extends flash.display.Sprite
	{
		
		private var _starling:Starling;
		private var _context:IContext;
		public function Main()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			
			Starling.handleLostContext = true;
			stage.frameRate = 60;
			_starling                     = new Starling(Shell, stage);
			_starling.start();
			
			_context = new Context()
				.install(MVCSBundle)
				.configure(ContextConfig, new ContextView(this));
			_context.initialize();
			
			
			
			
		}
	}
}