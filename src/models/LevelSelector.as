package models
{
	import bootstrap.FSM;
	
	import flash.events.IEventDispatcher;
	import flash.sampler.NewObjectSample;
	
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureAtlas;

	public class LevelSelector
	{
		private var button:Button;
		
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		[Inject]
		public var _gameAssets:GameAssets;
		
		[Inject]
		public var _stage:Stage;
		
		[Inject]
		public var _global:Global;
		
		public function LevelSelector()
		{
		}
		public function attach():void
		{
			var atlas:TextureAtlas = _gameAssets.getAtlas(GameAssetsEnum.general);
			
			button = new Button(atlas.getTexture('main'));
			button.addEventListener( Event.TRIGGERED, onClick );
			_stage.addChild(button);
		}
		protected function onClick():void{
			dispose();
			_global.level = 0;
			eventDispatcher.dispatchEvent(new StateEvent(StateEvent.ACTION, FSM.START_GAME));
		}
		
		protected function dispose():void{
			button.removeFromParent(true);
		}
	}
}