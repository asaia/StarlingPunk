package com.saia.starlingPunk.graphics 
{
	import flash.display.BitmapData;
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
	}

}