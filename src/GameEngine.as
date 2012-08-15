package
{
	import com.saia.starlingPunk.SP;
	import com.saia.starlingPunk.SPEngine;
	import com.saia.starlingPunkExamples.helpers.ExampleManager;
	import com.saia.starlingPunkExamples.platformer.controllers.LevelController;
	import com.saia.starlingPunkExamples.shipShooter.worlds.PlayWorld;
	
	/**
	 * ...
	 * @author Andy Saia
	 */
	public class GameEngine extends SPEngine
	{	
		public function GameEngine() 
		{
			super();
		}
		
		//-------------------
		//  event handlers
		//-------------------
		
		override public function init():void 
		{
			super.init();
			
			SP.world = LevelController.getCurrentLevel();
			//SP.world = new PlayWorld();
		}
	}
}