package events
{
	import org.robotlegs.utilities.statemachine.StateEvent;

	public class StartGameEvent extends StateEvent
	{
		private var _level:int;
		public function StartGameEvent(type:String, action:String, level:int)
		{
			_level = level
			super(type,action);
		}

		public function get level():int
		{
			return _level;
		}

	}
}