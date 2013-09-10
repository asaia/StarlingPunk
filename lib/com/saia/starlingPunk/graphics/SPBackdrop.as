{
	import com.saia.starlingPunk.SP;
	import flash.display.BitmapData;
	import starling.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.core.RenderSupport;
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author 
	 */
	public class SPBackdrop extends Sprite 
	{
		private var _texture:Image;
		private var _scrollX:Number;
		private var _scrollY:Number;
		private var _cameraPos:Point;
		private var _delta:Point;
		
		/**
		 * Endless repeating texture that scrolls in relation to the camera (e.g. parallax effects)
		 * @param	texture		Source texture.
		 * @param	scrollX		Scroll factor along the x axis, 0.0 follows the camera.
		 * @param	scrollY		Scroll factor along the y axis, 0.0 follows the camera.
		 */
		public function SPBackdrop(texture:*, scrollX:Number = 0.0, scrollY:Number = 0.0) 
		{
			super();
			
			if (texture is Class) _texture = Image.fromBitmap(texture);
			else if (texture is Image) _texture = texture;
			else throw new Error("Invalid image data!");
			
			_delta = new Point();
			_cameraPos = new Point(SP.camera.x, SP.camera.y);
			
			_scrollX = scrollX;
			_scrollY = scrollY;
			
			_texture.texture.repeat = true;
			_texture.x = _texture.width * 0.5;
			_texture.y = _texture.height * 0.5;
			
			if (_texture.width &lt; SP.camera.viewPort.width)
			{
				// if the texture is smaller than the camera dimensions
				// we need to tile the texture accordingly
				var tileX:Number = SP.camera.viewPort.width / _texture.width;
				var tileY:Number = SP.camera.viewPort.height / _texture.height;
				
				_texture.x = (_texture.width * tileX) * 0.5;
				_texture.y = (_texture.height * tileY) * 0.5;
				
				tile(_texture, tileX, tileY);
			}
			else
			{
				// if the texture is larger than the camera dimensions
				// we don't need to tile the texture
				_texture.x = _texture.width * 0.5;
				_texture.y = _texture.height * 0.5;
				
				tile(_texture, 1, 1);
			}
			
			addChild(_texture);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function tile(image:Image, horizontal:Number, vertical:Number):void
		{
			image.setTexCoords(1, new Point(horizontal, 0));
			image.setTexCoords(2, new Point(0, vertical));
			image.setTexCoords(3, new Point(horizontal, vertical));
			image.pivotX = image.width / 2; 
			image.pivotY = image.height / 2; 
			image.width *= horizontal;
			image.height *= vertical;
		}
		
		private function onEnterFrame(e:Event):void
		{
			x = SP.camera.x;
			y = SP.camera.y;
		}
		
		override public function render(support:RenderSupport, parentAlpha:Number):void 
		{
			super.render(support, parentAlpha);
			
			_delta.x = ((SP.camera.x - _cameraPos.x) * _scrollX) / SP.camera.viewPort.width;
			_delta.y = ((SP.camera.y - _cameraPos.y) *_scrollY) / SP.camera.viewPort.height;
			
			var p:Point;
			p = _texture.getTexCoords(0);
			p.x += _delta.x;
			p.y += _delta.y;
			_texture.setTexCoords(0, p);
 
			p = _texture.getTexCoords(1);
			p.x += _delta.x;
			p.y += _delta.y;
			_texture.setTexCoords(1, p);
 
			p = _texture.getTexCoords(2, p);
			p.x += _delta.x;
			p.y += _delta.y;
			_texture.setTexCoords(2, p);
 
			p = _texture.getTexCoords(3, p);
			p.x += _delta.x;
			p.y += _delta.y;
			_texture.setTexCoords(3, p);
			
			_cameraPos.x = SP.camera.x;
			_cameraPos.y = SP.camera.y;
		}
		
	}

}