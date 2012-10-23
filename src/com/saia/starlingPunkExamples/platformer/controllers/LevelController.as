package com.saia.starlingPunkExamples.platformer.controllers 
{
	import com.saia.starlingPunk.SPWorld;
	import com.saia.starlingPunkExamples.cameraScroller.worlds.ScrollingWorld;
	import com.saia.starlingPunkExamples.platformer.worlds.PlatformerLevelOne;
	import com.saia.starlingPunkExamples.platformer.worlds.PlatformerLevelTwo;
	/**
	 * ...
	 * @author Andy Saia
	 */
	public class LevelController 
	{
		private static var levels:Vector.<SPWorld> = new <SPWorld>[new PlatformerLevelOne(), new PlatformerLevelTwo()];
		private static var currentLevelIndex:int = 0;
		
		public static function getCurrentLevel():SPWorld
		{
			return levels[currentLevelIndex];
		}
		
		public static function nextLevel():SPWorld
		{	
			currentLevelIndex++;
			if (currentLevelIndex > levels.length -1)
			{
				currentLevelIndex = 0;
			}
			return getCurrentLevel();
		}
	}
}