package bootstrap
{
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	
	import models.Stage;
	
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	import robotlegs.bender.bundles.mvcs.MVCSBundle;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.Context;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	
	
	public class Shell extends starling.display.Sprite
	{
		private var _context:IContext;
		
		public function Shell()
		{
			super();
			_context = new Context()
				.install(MVCSBundle)
				.configure(ContextConfig, new ContextView(new flash.display.Sprite()));
			_context.initialize();
			
			(_context.injector.getInstance(IEventDispatcher) as IEventDispatcher).dispatchEvent(new StateEvent(StateEvent.ACTION, FSM.LEVEL_SELECT));
			Starling.current.stage.addChild(_context.injector.getInstance(Stage) as Stage);
		}
	}
}