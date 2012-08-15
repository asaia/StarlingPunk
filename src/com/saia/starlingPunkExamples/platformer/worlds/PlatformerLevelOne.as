package com.saia.starlingPunkExamples.platformer.worlds 
{
	import com.saia.starlingPunkExamples.embeds.ExampleAssets;
	
	/**
	 * ...
	 * @author Andy Saia
	 */
	public class PlatformerLevelOne extends PlatformerWorld 
	{
		override public function begin():void 
		{
			super.begin();
			loadLevel(ExampleAssets.LEVEL01);
		}
	}

}