package com.saia.starlingPunkExamples.platformer.worlds 
{
	import com.saia.starlingPunk.extensions.ogmopunk.OgmoProject;
	import com.saia.starlingPunk.SPEntity;
	import com.saia.starlingPunk.SPWorld;
	import com.saia.starlingPunkExamples.embeds.ExampleAssets;
	import com.saia.starlingPunkExamples.helpers.ExampleManager;
	import com.saia.starlingPunkExamples.platformer.entities.GoalEntity;
	import com.saia.starlingPunkExamples.platformer.entities.PlatformerPlayer;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	
	/**
	 * ...
	 * @author Andy Saia
	 */
	public class PlatformerWorld extends SPWorld 
	{
		
		public function PlatformerWorld() 
		{
			//flash doesn't compile classes that aren't refrenced in code and OgmoPunk uses the getDefinitionByName Util to
			//to create instances of our Entities. If the entites aren't compiled getDefinitionByName will give an error message
			//saying that our classes aren't defined... by including these classes into the construction we are telling flash to compile them
			PlatformerPlayer; GoalEntity;
		}
		
		override public function begin():void 
		{
			//load the embedded project file
			OgmoProject.LoadProject(ExampleAssets.OGMO_PROJECT, this as Class);
			var textureAtlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new ExampleAssets.ATLAS_TEXTURE()), XML(new ExampleAssets.ATLAS_DATA()));
			//before loading the level you must tell OgmoPunk which images to use for the tileset
			OgmoProject.createTileSetListFromTextureAtlas("groundTileSet", textureAtlas, ["platformTile", "marioTile"]);
			
			//display example instructions
			ExampleManager.displayText('\ntoggle camera mode by pressing the "space bar"\nzoom in/out using "W/S" and rotate camera using "A/S"');
			super.begin();
		}
		
		override public function end():void 
		{
			super.end();
			removeAll();
			removeChildren(0, -1, true);
		}
		
		override public function update():void 
		{
			super.update();
			//update example manager
			ExampleManager.checkExampleChange();
		}
		
		//-------------------
		//  protected methods
		//-------------------
		
		protected function loadLevel(levelData:Class):void
		{
			var levelLayers:Vector.<SPEntity> = OgmoProject.LoadLevel(levelData);
			for each (var entity:SPEntity in levelLayers) 
			{
				add(entity);
			}
		}
	}
}