package com.saia.starlingPunkExamples.platformer.entities 
{
	import com.saia.starlingPunk.SPEntity;
	import com.saia.starlingPunkExamples.embeds.ExampleAssets;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author Andy Saia
	 */
	public class GoalEntity extends SPEntity 
	{
		
		public function GoalEntity() 
		{
			super(0, 0, "goal");
		}
		
		override public function added():void 
		{
			super.added();
			setupGraphic();
		}
		
		override public function removed():void 
		{
			removeChildren(0, -1, true);
			super.removed();
		}
		
		
		private function setupGraphic():void 
		{
			var textureAtlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new ExampleAssets.ATLAS_TEXTURE()), XML(new ExampleAssets.ATLAS_DATA()));
			var image:Image = new Image(textureAtlas.getTexture("goal"));
			addChild(image);
		}
		
	}

}