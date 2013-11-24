package models
{
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	public class Camera
	{
		
		private var _canvas:Sprite;
		private var _viewport:Sprite;
		private var _viewportSize:Rectangle;
		private var _mapsize:Rectangle;
		
		private var _tmp:int;
		
		public function Camera(viewport:Rectangle, mapsize:Rectangle)
		{
			_viewport = new Sprite();
			
			
			_canvas = new Sprite();
			_canvas.width = mapsize.width;
			_canvas.height = mapsize.height;
			
			
			_viewport.addChild(_canvas);
			_viewport.width = viewport.width;
			_viewport.height = viewport.height;
			
			
			
           	_mapsize = mapsize.clone();		
			_viewportSize = viewport.clone();
		}
		
		public function add(obj:DisplayObject):void 
		{
			_canvas.addChild(obj);
		}
		
		public function attach(stage:Stage):void
		{
			stage.addChild(_viewport);
		}
		public function detach():void
		{
			_viewport.removeFromParent(true);
		}
		
		
		public function set y(val:int):void 
		{
			_canvas.y = Math.max(Math.min(0, val), -(_mapsize.height - _viewportSize.height) );
		}
		
		public function stick(val:int):void
		{
			y = -val + _viewportSize.height / 2;
		}
		
		public function get y():int
		{
			return _canvas.y;
		}
		
	}
}