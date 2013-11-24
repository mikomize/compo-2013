package commands
{
	import models.GameModel;
	import models.LevelSelector;
	
	import robotlegs.bender.bundles.mvcs.Command;
	import robotlegs.bender.framework.api.IInjector;
	
	import starling.core.Starling;

	public class LevelSelectorCommand extends Command
	{
		
		[Inject]
		public var _injector:IInjector;
		
		public function LevelSelectorCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			
			if (_injector.hasMapping(LevelSelector)) {
				_injector.unmap(LevelSelector);
			}
			var _levelSelector:LevelSelector = _injector.instantiateUnmapped(LevelSelector);
			_injector.map(LevelSelector).toValue(_levelSelector);
			
			_levelSelector.attach();
		}
	}
}