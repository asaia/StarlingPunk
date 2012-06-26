package
{
	import com.saia.starlingPunk.SP;
	import com.saia.starlingPunk.SPEngine;
	import com.saia.starlingPunkExample.worlds.PlayWorld;
	
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
			var world:PlayWorld = new PlayWorld();
			SP.world = world;
		}
	}
}