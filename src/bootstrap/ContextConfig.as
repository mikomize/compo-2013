package bootstrap
{
	import flash.events.IEventDispatcher;
	
	import commands.StartGameCommand;
	
	import models.GameAssets;
	
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
			_injector.map(GameAssets).asSingleton();
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