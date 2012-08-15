package com.saia.starlingPunkExamples.platformer.worlds 
{
	import com.saia.starlingPunkExamples.embeds.ExampleAssets;
	
	/**
	 * ...
	 * @author Andy Saia
	 */
	public class PlatformerLevelTwo extends PlatformerWorld 
	{
		override public function begin():void 
		{
			super.begin();
			loadLevel(ExampleAssets.LEVEL02);
		}
	}

}