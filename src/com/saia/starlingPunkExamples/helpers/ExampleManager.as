package com.saia.starlingPunkExamples.helpers 
{
	import com.saia.starlingPunk.SP;
	import com.saia.starlingPunk.utils.Key;
	import com.saia.starlingPunk.utils.SPInput;
	import com.saia.starlingPunkExamples.cameraScroller.worlds.ScrollingWorld;
	import com.saia.starlingPunkExamples.platformer.controllers.LevelController;
	import com.saia.starlingPunkExamples.shipShooter.worlds.PlayWorld;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	/**
	 * ...
	 * @author Andy Saia
	 */
	public class ExampleManager 
	{
		
		public function ExampleManager() 
		{
			
		}
		
		public static function displayText(message:String = ""):void
		{
			var textField:TextField = createTextField();
			textField.text = "use numbers keys (1-3) to see other examples " + message;
			textField.hAlign = HAlign.LEFT;
			
			SP.world.addChildAt(textField, SP.world.numChildren);
			textField.x = 200;
			textField.y = 40;
		}
		
		public static function checkExampleChange():void
		{
			if (SPInput.check(Key.DIGIT_1))
			{
				SP.world = LevelController.getCurrentLevel();
			}
			
			if (SPInput.check(Key.DIGIT_2))
			{
				SP.world = new ScrollingWorld();
			}
			
			if (SPInput.check(Key.DIGIT_3))
			{
				SP.world = new PlayWorld();
			}
		}
		
		private static function createTextField():TextField
		{
			var textfield:TextField = new TextField(SP.width, 100, "");
			textfield.fontSize = 16;
			textfield.color = Color.BLACK;
			textfield.hAlign = HAlign.CENTER;
			textfield.vAlign = VAlign.TOP;
			return textfield;
		}
		
	}

}