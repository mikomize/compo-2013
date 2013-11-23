package models
{
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;

	public class Camera
	{
		
		private var _canvas:Sprite;
		private var _viewport:Sprite;
		
		public function Camera(viewport:Rectangle, mapsize:Rectangle)
		{
			_viewport = new Sprite();
			//_viewport.width = viewport.width;
			//_viewport.height = viewport.height;
			
			_viewport.clipRect = viewport;
			
			//_viewport.addChild(new Quad(viewport.width, viewport.height));
			
			_canvas = new Sprite();
			//_canvas.width = mapsize.width;
			//_canvas.height = mapsize.height;
			
			//_canvas.addChild(new Quad(mapsize.width, mapsize.height));
			
			_viewport.addChild(_canvas);
			trace('aaaa');
			trace([_viewport.width, _viewport.height]);
			
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
			_canvas.y = Math.min(Math.max(0, val), _canvas.height - _viewport.height);
			trace(_canvas.y);
		}
		
		public function stick(val:int):void
		{
			
		}
		
		public function get y():int
		{
			return _canvas.y;
		}
		
		public function scrollBot():void 
		{
			y = _canvas.height;
		}
	}
}