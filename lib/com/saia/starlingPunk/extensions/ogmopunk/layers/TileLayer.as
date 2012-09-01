package com.saia.starlingPunk.extensions.ogmopunk.layers
{
	import com.saia.starlingPunk.extensions.ogmopunk.OgmoLayer;
	import com.saia.starlingPunk.extensions.ogmopunk.OgmoProject;
	import com.saia.starlingPunk.extensions.ogmopunk.OgmoTileSet;
	import com.saia.starlingPunk.graphics.SPTilemap;
	import com.saia.starlingPunk.SPEntity;
	/**
	 * ...
	 * @author Erin M Gunn
	 */
	public class TileLayer extends OgmoLayer
	{
		
		public var mExportMode:String;
		public function get exportMode():String 
		{
			return mExportMode;
		}
		
		override public function loadData():Vector.<SPEntity> 
		{
			var tileSet:OgmoTileSet = OgmoProject.tileSets[this.data.@tileset];
			var e:SPEntity = new SPEntity(0, 0, tileSet.name);
			var tilemap:SPTilemap = new SPTilemap(OgmoProject.levelDims.x, OgmoProject.levelDims.y, tileSet.tileSize.x, tileSet.tileSize.y)
			if (!OgmoProject.tileSetImages) throw new Error("You must first call the createTilesFromTextureAtlas method in the OgmoProject class");
			
			//passes the image vector to the tile class
			tilemap.createTilesFromVector(OgmoProject.getTileSet(tileSet.name));
			
			//e.graphic.scrollX = scrollFactor.x;
			//e.graphic.scrollY = scrollFactor.y;
			
			if (exportMode == "CSV")
			{
				var str:String = this.data.toString();
				str = str.replace(new RegExp('-1', 'g'), '');
				tilemap.loadFromString(str);
			}
			
			var es:Vector.<SPEntity> = new Vector.<SPEntity>();
			es.push(e);
			e.addChild(tilemap);
			
			return es;
		}
	}

}