package com.saia.starlingPunk.graphics 
{
	import adobe.utils.CustomActions;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.display.Image;
	
	public class SPImage extends Sprite 
	{
		private var sourceImage:Image;
		
		public function SPImage(texture:Texture) 
		{
			sourceImage = new Image(texture);
			addChild(sourceImage);
		}
		
		public static function drawRect(_width:int, _height:int, _alpha:Number, color:uint):Image
		{
			var img:Image = new Image(Texture.fromBitmapData(new BitmapData(_width, _height, false, color)));
			img.alpha = _alpha;
			
			return img;
		}
		
		public static function drawCircle(radius:uint, color:uint = 0x000000, alpha:Number = 1):Image
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0xFFFFFF);
			shape.graphics.drawCircle(radius, radius, radius);
			var data:BitmapData = new BitmapData(radius * 2, radius * 2, true, 0);
			data.draw(shape);
			
			var image:Image = new Image(Texture.fromBitmapData(data));
			image.color = color;
			image.alpha = alpha;
			
			return image;
		}
	}

}