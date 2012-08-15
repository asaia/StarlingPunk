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
	public class ScoreEntity extends SPEntity 
	{
		private var _textField:TextField;
		private var _score:Number;
		
		public function ScoreEntity() 
		{
			
		}
		
		//----------
		//  overrides
		//----------
		
		override public function added():void 
		{
			super.added();
			_score = 0;
			_textField = createTextField();
			addChild(_textField);
			var boarder:Number = 15;
			this.x = SP.width - width - boarder;
			this.y = boarder;
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
			var textfield:TextField = new TextField(100, 100, _score.toString(), bmpFont.name, 50, 0x597137);
			textfield.fontSize = 65;
			textfield.hAlign = HAlign.RIGHT;
			textfield.vAlign = VAlign.TOP;
			return textfield;
		}
		
		//----------
		//  public methods
		//----------
		
		public function addPoint():void
		{
			_score++;
			_textField.text = _score.toString();
		}
	}
}