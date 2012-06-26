package com.saia.starlingPunkExample.controller 
{
	import com.saia.starlingPunk.SP;
	import com.saia.starlingPunkExample.entities.ScoreEntity;
	/**
	 * ...
	 * @author Andy Saia
	 */
	public class ScoreController 
	{
		public static var _scoreEntity:ScoreEntity;
		
		public static function init():void 
		{
			_scoreEntity = new ScoreEntity();
			SP.world.add(_scoreEntity);
		}
		
		public static function increaseScore():void
		{
			_scoreEntity.addPoint();
		}
	}
}