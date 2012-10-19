package com.saia.starlingPunkExamples.shipShooter.entities 
{
	import com.saia.starlingPunk.SP;
	import com.saia.starlingPunk.SPEntity;
	import com.saia.starlingPunk.masks.SPPixelmask;
	
	import flash.display.Bitmap;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Andy Saia
	 */
	public class TestShape extends SPEntity 
	{
		[Embed(source = "media/textures/TestShape.png")]
		private static const BMP_SHAPE:Class;
		
		public function TestShape() 
		{
			super(SP.halfWidth, SP.halfHeight - 200, "testShape");
		}
		
		override public function added():void 
		{
			super.added();
			
			var bitmap:Bitmap = new BMP_SHAPE();
			var image:Image = new Image(Texture.fromBitmap(bitmap));
			addChild(image);
			
			mask = new SPPixelmask(bitmap.bitmapData);
		}
		
	}

}