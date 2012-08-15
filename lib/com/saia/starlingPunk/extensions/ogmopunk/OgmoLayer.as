package com.saia.starlingPunk.extensions.ogmopunk
{
	import com.saia.starlingPunk.SPEntity;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Erin M Gunn
	 */
	public class OgmoLayer 
	{
		internal var mName:String;
		public function get name():String
		{
			return mName;
		}
		
		internal var mGrid:Point;
		public function get grid():Point
		{
			return mGrid;
		}
		
		internal var mScrollFator:Point;
		public function get scrollFactor():Point
		{
			return mScrollFator;
		}
		
		internal var mData:XML
		public function get data():XML
		{
			return mData;
		}
		
		public function loadData():Vector.<SPEntity>
		{
			return null;
		}
	}

}