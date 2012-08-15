package com.saia.starlingPunk.extensions.ogmopunk 
{
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Erin M Gunn
	 */
	public class OgmoTileSet 
	{
		internal var mTileSet:Object;
		public function get tileSet():Object
		{
			return mTileSet;
		}
		
		internal var mName:String;
		public function get name():String
		{
			return mName;
		}
		
		internal var mFilePath:String;
		public function get filePath():String
		{
			return mFilePath;
		}
		
		internal var mTileSize:Point;
		public function get tileSize():Point
		{
			return mTileSize;
		}
		
		internal var mTileSep:uint;
		public function get tileSep():uint
		{
			return mTileSep;
		}
		
		public function onInitTileset(e:Event):void
		{
			mTileSet = Bitmap(e.target.loader.content).bitmapData;
			OgmoProject.mEventQueue--;
		}
		
		public static function LoadTileset(dataElement:XML, tileSetsContainer:Object):OgmoTileSet
		{
			var t:OgmoTileSet = new OgmoTileSet();
			t.mName = dataElement.Name;
			t.mFilePath = dataElement.FilePath;
			t.mTileSize = new Point(dataElement.TileSize.Width, dataElement.TileSize.Height);
			t.mTileSep = dataElement.TileSep;
			if (tileSetsContainer.hasOwnProperty(t.mName)) t.mTileSet = tileSetsContainer[t.mName];
			
			return t;
		}
	}

}