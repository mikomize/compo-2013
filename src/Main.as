package
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.IEventDispatcher;
	
	import bootstrap.ContextConfig;
	import bootstrap.FSM;
	import bootstrap.Shell;
	
	import org.robotlegs.utilities.statemachine.StateEvent;
	
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
			
			(_context.injector.getInstance(IEventDispatcher) as IEventDispatcher).dispatchEvent(new StateEvent(StateEvent.ACTION, FSM.START));

			
			
		}
	}
}