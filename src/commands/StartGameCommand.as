package commands
{
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	
	import models.GameModel;
	import models.TestBox;
	
	import robotlegs.bender.bundles.mvcs.Command;
	import robotlegs.bender.framework.api.IInjector;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	
	public class StartGameCommand extends Command
	{
		
		
		[Inject]
		public var _injector:IInjector;
		
		public function StartGameCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			_injector.unmap(GameModel);
			var model:GameModel = _injector.instantiateUnmapped(GameModel).init()
			_injector.map(GameModel).toValue(model);
			
		    
			var box1:TestBox = new TestBox(10,20);
			_injector.injectInto(box1);
			model.addEntity(box1);
			
			var box2:TestBox = new TestBox(50,10);
			_injector.injectInto(box2);
			model.addEntity(box2);

			

			
		}
	}
}