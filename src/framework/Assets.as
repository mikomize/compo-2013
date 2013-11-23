package framework
{
	import flash.display.Bitmap;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Assets
	{
		private var _atlases:Dictionary  = new Dictionary();
		private var _textures:Dictionary = new Dictionary();
		private var _xmls:Dictionary     = new Dictionary();
		private var _sounds:Dictionary   = new Dictionary();
		
		private var _atlasesDefinitions:Dictionary = new Dictionary();
		private var _xmlsClasses:Dictionary        = new Dictionary();
		private var _soundsClasses:Dictionary      = new Dictionary();
		
		public function Assets()
		{
		}
		
		public function getTexture(name:Enum):Texture {
			return _textures[name];
		}
		
		public function getXml(name:Enum):XML {
			if (_xmls[name]) {
				return _xmls[name];	
			}
			_xmls[name] = XML(new (getXmlClass(name))());
			return _xmls[name];
		}
		
		public function getAtlas(name:Enum): TextureAtlas {
			if (_atlases[name]) {
				return _atlases[name];
			}
			var atlasDefinition:Object = getAtlasDefinition(name);
			return createAtlasFromClass(name, atlasDefinition.texture, atlasDefinition.xml);
		}
		
		public function getSound(name:Enum):Sound {
			if (_sounds[name]) {
				return _sounds[name];
			}
			_sounds[name] = Sound(new (getSoundClass(name))());
			return _sounds[name];
		}
		
		public function purge():void {
			for each(var dict:Dictionary in new <Dictionary>[_atlases, _textures]) {
				for (var key:Object in dict) {
					dict[key].dispose();
					dict[key] = null;
				}
			}
		}
		
		protected function addAtlasDefinition(label:Enum, textureClass:Class, xmlClass:Class): void {
			_atlasesDefinitions[label] = {'xml': xmlClass, 'texture': textureClass};
		}
		
		protected function addXmlClass(label:Enum, xmlClass:Class):void {
			_xmlsClasses[label] = xmlClass;
		}
		
		protected function addSoundClass(label:Enum, soundClass:Class):void
		{
			_soundsClasses[label] = soundClass;
		}
		
		private function getAtlasDefinition(label:Enum):Object {
			return _atlasesDefinitions[label];
		}
		
		private function getXmlClass(label:Enum):Class {
			return _xmlsClasses[label];
		}
		
		private function getSoundClass(label:Enum):Class {
			return _soundsClasses[label];
		}
		
		private function createAtlasFromClass(name:Enum, textureClass:Class, xmlClass:Class):TextureAtlas {
			return createAtlas(name,  createTexture(name, new textureClass()), XML(new xmlClass()));
		}
		
		private function createAtlas(name:Enum, texture:Texture, xml:XML):TextureAtlas {
			_atlases[name] = new TextureAtlas(texture, xml);
			return _atlases[name];
		}
		
		private function createTexture(name:Enum, input:*):Texture {
			var texture:Texture;
			if (_textures[name]) {
				return _textures[name];
			}
			if (input is ByteArray) {
				texture = createTextureFromAtf(input);
			} else if(input is Bitmap) {
				texture = createTextureFromBitmap(input);
			}
			_textures[name] = texture;
			return texture;
		}
		
		private function createTextureFromAtf(rawAtfTexture:ByteArray):Texture {
			return Texture.fromAtfData(rawAtfTexture, 1, false);
		}
		
		private function createTextureFromBitmap(bitmap:Bitmap):Texture {
			return Texture.fromBitmap(bitmap, false);
		}
		
	}
}