package com.saia.starlingPunkExamples.shipShooter.entities 
{
	import com.saia.starlingPunk.graphics.Tilemap;
	import com.saia.starlingPunk.masks.Grid;
	import com.saia.starlingPunk.SP;
	import com.saia.starlingPunk.SPEntity;
	import flash.display.Bitmap;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Andy Saia
	 */
	public class LevelTiles extends SPEntity 
	{
		[Embed(source = "../../../../media/textures/tileset.png")]
		private static const TILESET:Class;
		public function LevelTiles() 
		{
		}
		
		override public function added():void 
		{
			super.added();
			type = "tile";
			
			var bmp:Bitmap = new TILESET();
			var texture:Texture = Texture.fromBitmap(bmp);
			
			var tiles:Tilemap = new Tilemap(SP.width, SP.height, 32, 32);
			tiles.createTilesFromBitmapData(bmp.bitmapData);
			
			
			tiles.setRect(0, 0, SP.width / 32, SP.height / 32, 1);
			tiles.setRect(4, 4, 3, 5, 2);
			tiles.setTile(12, 5, 0);
			tiles.setTile(12, 6, 3);
			
			addChild(tiles);
			
			var grid:Grid = new Grid(SP.width, SP.height, 32, 32, 0, 0);
			mask = grid;
			
			grid.setRect(4, 4, 3, 5, true);
			grid.setTile(12, 5, true);
		}
		
	}

}