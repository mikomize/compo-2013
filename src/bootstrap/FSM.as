package bootstrap
{
	public class FSM
	{
		
		private static const ACTION_PREFIX:String = 'action';
		private static const STATE_PREFIX:String = 'state';
		private static const EVENT_PREFIX:String = 'event';
		
		public static const INIT_STATE:String = STATE_PREFIX + 'init';
		public static const STARTED_STATE:String = STATE_PREFIX + 'started';
		
		public static const STARTED_EVENT:String = EVENT_PREFIX + 'started';
		public static const SELECTOR_STARTED_EVENT:String = EVENT_PREFIX + 'selector_started_event';
		public static const SELECTOR_STATE:String = STATE_PREFIX + 'selector';
		
		public static const START_GAME:String = ACTION_PREFIX + 'start';
		public static const LEVEL_SELECT:String = ACTION_PREFIX + 'level_select';
		public static const FINISH:String = ACTION_PREFIX + 'finish';
		
		public static const fsm : XML = 
			<fsm initial={INIT_STATE}>
				<state name={INIT_STATE}>
					<transition action={LEVEL_SELECT} target={SELECTOR_STATE}/>
				</state>
				<state name={SELECTOR_STATE} changed={SELECTOR_STARTED_EVENT}>
					<transition action={START_GAME} target={STARTED_STATE}/>
				</state>
				<state name={STARTED_STATE} changed={STARTED_EVENT}>
					<transition action={FINISH} target={SELECTOR_STATE}/>
				</state>
			</fsm>;
		
		
		public function FSM()
		{
		}
	}
}