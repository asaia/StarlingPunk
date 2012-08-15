package com.saia.starlingPunkExamples.shipShooter.controller 
{
	import com.saia.starlingPunk.SP;
	import com.saia.starlingPunkExamples.shipShooter.entities.ScoreEntity;
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