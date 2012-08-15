package com.saia.starlingPunk.extensions.ogmopunk
{
	/**
	 * ...
	 * @author Erin M Gunn
	 */
	public class OgmoValue 
	{
		internal var mName:String;
		public function get name():String
		{
			return mName;
		}
		
		internal var mValue:Object
		public function get value():Object
		{
			return mValue;
		}
		
		internal var mType:Class;
		public function get type():Class
		{
			return mType;
		}
	}

}