package models
{
	import bootstrap.FSM;
	
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.sampler.NewObjectSample;
	import flash.utils.Dictionary;
	
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureAtlas;

	public class LevelSelector
	{
		private var buttons:Sprite;
		
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		
		
		[Inject]
		public var _stage:Stage;
		
		[Inject]
		public var _global:Global;
		
		[Inject]
		public var _levelManager:LevelManger;
		
		public function LevelSelector()
		{
		}
		public function attach():void
		{
			buttons = new Sprite;
			var levels:Dictionary = _levelManager.getLevels()
			var begin:Point = new Point(100,100);
			for(var index:String in levels){
				var button:Button = new Button(levels[index]);
				button.x = begin.x;
				begin.x += 300;
				button.y = begin.y;
				var cyce:Function = function(bleh:int):void{
					button.addEventListener( Event.TRIGGERED, function():void{
						onClick(Number(bleh));
					});
				}
				cyce(index);
				buttons.addChild(button);
			}
			_stage.addChild(buttons);
			
			
		}
		protected function onClick(level:int):void{
			dispose();
			_global.level = level;
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, FSM.START_GAME));
		}
		
		protected function dispose():void{
			buttons.removeFromParent(true);
		}
	}
}