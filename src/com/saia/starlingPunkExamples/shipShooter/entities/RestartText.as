package com.saia.starlingPunkExamples.shipShooter.entities 
{
	import com.saia.starlingPunk.SP;
	import com.saia.starlingPunk.SPEntity;
	import com.saia.starlingPunkExamples.embeds.ExampleAssets;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author Andy Saia
	 */
	public class RestartText extends SPEntity 
	{
		
		public function RestartText() 
		{
			
		}
		
		//----------
		//  overrides
		//----------
		
		override public function added():void 
		{
			super.added();
			var textField:TextField = createTextField();
			textField.text = "GAME OVER \n PRESS ENTER TO PLAY AGAIN";
			textField.y = SP.halfHeight;
			addChild(textField);
		}
		
		override public function removed():void 
		{
			super.removed();
			removeChildren(0, -1, true);
		}
		
		//----------
		//  private methods
		//----------
		
		private function createTextField():TextField
		{
			var bmpFont:BitmapFont = new BitmapFont(Texture.fromBitmap(new ExampleAssets.BMP_FONT_TEXTURE()), XML(new ExampleAssets.FONT_DATA()));
			TextField.registerBitmapFont(bmpFont);
			var textfield:TextField = new TextField(SP.width, 100, "", bmpFont.name, 50, 0x597137);
			textfield.fontSize = 30;
			textfield.hAlign = HAlign.CENTER;
			textfield.vAlign = VAlign.TOP;
			return textfield;
		}
	}
}