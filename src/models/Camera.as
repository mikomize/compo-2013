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
		private var size:Rectangle;
		
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
			
			_viewport.clipRect = viewport;
			
			size = viewport.clone();
		}
		
		public function add(obj:DisplayObject):void 
		{
			_canvas.addChild(obj);
		}
		
		public function attach():void
		{
			Starling.current.stage.addChild(_viewport);
		}
		
		public function set y(val:int):void 
		{
			_canvas.y = Math.max(Math.min(0, val), -(_canvas.height - size.height) );
		}
		
		public function stick(val:int):void
		{
			y = -val + size.height / 2;
		}
		
		public function get y():int
		{
			return _canvas.y;
		}
		
		public function scrollBot():void 
		{
			y = -(_canvas.height - size.height);
		}
	}
}