package com.saia.starlingPunk.helpers 
{
	/**
	 * Collection of Math helper methods
	 * @author Andy Saia
	 */
	public class SPMath 
	{
		
		/**
		 * returns random number inbetween min and max
		 * @param	minNum
		 * @param	maxNum
		 * @return random number inbetween min and max
		 */
		public static function range(minNum:Number, maxNum:Number):Number 
        {
            return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
        }
		
		/**
		 * returns a random index of the given array
		 */
		public static function getRandomIndex(array:*):int
		{
			var index:int = Math.floor(Math.random() * array.length);
			return index;
		}
		
		/**
		 * converts degrees to radians
		 */
		public static function degreesToRadians(degrees:Number):Number
		{
			return degrees * Math.PI / 180;
		}
		
		/**
		 * converts radians to degrees
		 */
		public static function radiansToDegrees(radians:Number):Number
		{
			return radians * 180 / Math.PI;
		}
	}
}