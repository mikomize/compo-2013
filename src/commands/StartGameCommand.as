package commands
{
	import events.StartGameEvent;
	
	import models.GameModel;
	
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	import robotlegs.bender.bundles.mvcs.Command;
	import robotlegs.bender.framework.api.IInjector;
	
	import starling.core.Starling;

	
	
	public class StartGameCommand extends Command
	{
		
		private var _level:int
		[Inject]
		public var _injector:IInjector;
		
//		[Inject]
//		public var _event:StartGameEvent;
		
		public function StartGameCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			if (_injector.hasMapping(GameModel)) {
				_injector.unmap(GameModel);
			}
			var model:GameModel = _injector.instantiateUnmapped(GameModel);
			_injector.map(GameModel).toValue(model);
			model.init(2);
			trace([Starling.current.viewPort, Starling.current.stage.bounds]);
		}
	}
}