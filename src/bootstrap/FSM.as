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
		
		public static const START:String = ACTION_PREFIX + 'start';
		
		public static const fsm : XML = 
			<fsm initial={INIT_STATE}>
				<state name={INIT_STATE}>
					<transition action={START} target={STARTED_STATE}/>
				</state>
				<state name={STARTED_STATE} changed={STARTED_EVENT}>
				</state>
			</fsm>;
		
		
		public function FSM()
		{
		}
	}
}