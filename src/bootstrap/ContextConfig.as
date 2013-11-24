package bootstrap
{
	import commands.LevelSelectorCommand;
	import commands.StartGameCommand;
	
	import flash.events.IEventDispatcher;
	
	import models.GameAssets;
	import models.Global;
	import models.Stage;
	
	import org.robotlegs.utilities.statemachine.FSMInjector;
	import org.robotlegs.utilities.statemachine.StateMachine;
	
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;
	
	public class ContextConfig implements IConfig
	{
		
		[Inject]
		public var _commandMap:IEventCommandMap;
		
		[Inject]
		public var _injector:IInjector;
		
		[Inject]
		public var _eventDispatcher:IEventDispatcher;
		
		
		public function ContextConfig()
		{
		}
		
		public function configure():void
		{
			_commandMap.map(FSM.STARTED_EVENT).toCommand(StartGameCommand);
			_commandMap.map(FSM.SELECTOR_STARTED_EVENT).toCommand(LevelSelectorCommand);
			_injector.map(GameAssets).asSingleton();
			_injector.map(Stage).asSingleton();
			_injector.map(Global).asSingleton();
			setUpFSM();
		}
		
		private function setUpFSM():void
		{
			trace("StateMachineConfig.configure()");
			var fsmInjector:FSMInjector = new FSMInjector(FSM.fsm);
			var stateMachine : StateMachine = new StateMachine(_eventDispatcher);
			fsmInjector.inject(stateMachine);
			
			_injector.map(StateMachine).toValue(stateMachine);
			
		}
	}
}