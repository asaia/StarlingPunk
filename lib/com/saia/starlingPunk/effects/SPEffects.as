package com.saia.starlingPunk.effects 
{
	/**
	 * Collections of built-in effects 
	 * @author Andy Saia
	 */
	public class SPEffects 
	{
		/**
		 * 
		 * @param	intensity size of randomness of shake effect
		 * @param	duration length of shake
		 * @return  returns an instance of the shake effect class
		 */
		public static function shake(intensity:Number = 10, duration:Number = 1000):ShakeEffect
		{
			var shakeEffect:ShakeEffect = new ShakeEffect(intensity, duration);
			shakeEffect.start();
			return shakeEffect;
		}
	}
}