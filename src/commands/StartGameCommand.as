package commands
{
	import models.GameModel;
	import models.TestBox;
	import models.PhysicsEngineInterface;
	import models.PhysicsEngine1;
	
	import robotlegs.bender.bundles.mvcs.Command;
	import robotlegs.bender.framework.api.IInjector;
	
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
			if (_injector.hasMapping(GameModel)) {
				_injector.unmap(GameModel);
			}
			var model:GameModel = _injector.instantiateUnmapped(GameModel).init()
			_injector.map(GameModel).toValue(model);
			
		    
			var box1:TestBox = new TestBox(10,20);
			_injector.injectInto(box1);
			model.addEntity(box1);
			
			var box2:TestBox = new TestBox(50,10);
			_injector.injectInto(box2);
			model.addEntity(box2);

			var physicsEngine:PhysicsEngineInterface = new PhysicsEngine1();
			physicsEngine.initialize(model);
			
			
		}
	}
}