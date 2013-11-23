package framework
{
	
	import starling.animation.IAnimatable;
	import starling.animation.Juggler;

	public class Animated implements IAnimatable
	{
		protected var _juggler:Juggler;
		private var _parentJuggler:Juggler;
		
		public function get juggler():Juggler {
			return _juggler;
		}
		
		public function Animated()
		{
			_juggler = new Juggler();
		}
		
		public function setParentJuggler(parentJuggler:Juggler):IAnimatable {
			_parentJuggler = parentJuggler;
			return this;
		}
		
		public function advanceTime(time:Number):void {
			_juggler.advanceTime(time);
		}
		
		public function start(): void {
			_parentJuggler.add(this);
		}
		
		public function stop():void {
			_parentJuggler.remove(this);
		}
	}
}