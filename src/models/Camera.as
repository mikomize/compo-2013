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
		
		public function Camera(viewport:Rectangle, mapsize:Rectangle)
		{
			_viewport = new Sprite();
			_viewport.width = viewport.width;
			_viewport.height = viewport.height;
			
			_canvas = new Sprite();
			_canvas.width = mapsize.width;
			_canvas.height = mapsize.height;
			
			_viewport.addChild(_canvas);
			
		}
		
		public function add(obj:DisplayObject):void 
		{
			_canvas.addChild(obj);
		}
		
		public function attach():void
		{
			Starling.current.stage.addChild(_viewport);
			
		}
		
		public function set y(val:uint):void 
		{
			_canvas.y = Math.min(_canvas.height - _viewport.height, Math.max(0, val));
		}
		
		public function scrollBot(val:uint):void 
		{
			y = _canvas.height;
		}
	}
}