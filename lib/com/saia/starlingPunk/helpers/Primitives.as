package com.saia.starlingPunk.helpers 
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import starling.display.Image;
	import starling.textures.Texture;
	/**
	 * This Class contains helper classes for drawing primitive shapes usufuly for prototyping
	 * @author Andy Saia
	 */
	public class Primitives 
	{
		public static function rect(width:Number = 100, height:Number = 100, color:uint = 0xFF0000):Image
		{
			var bmpData:BitmapData = new BitmapData(width, height, false, color);
			var image:Image = new Image(Texture.fromBitmapData(bmpData));
			return image;
		}
		
		public static function circle(radius:Number = 50, color:uint = 0xFF0000):Image
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill(color);
			shape.graphics.drawCircle(radius, radius, radius);
			
			var bmpData:BitmapData = new BitmapData(radius * 2, radius * 2, true, 0x00FFFFFF);
			bmpData.draw(shape, null, null, null, null, true);
			var image:Image = new Image(Texture.fromBitmapData(bmpData));
			return image;
		}
	}
}