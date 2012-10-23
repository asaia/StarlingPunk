package com.saia.starlingPunkExamples.embeds 
{
	/**
	 * ...
	 * @author Andy Saia
	 */
	public class ExampleAssets 
	{
		//------------
		//  Ogmo Levels
		//------------
		[Embed(source = "../../../../media/levels/platformerProject.oep", mimeType = "application/octet-stream")]
		public static const OGMO_PROJECT:Class;
		
		[Embed(source="../../../../media/levels/level01.oel", mimeType="application/octet-stream")]
		public static const LEVEL01:Class;
		
		[Embed(source="../../../../media/levels/level02.oel", mimeType="application/octet-stream")]
		public static const LEVEL02:Class;
		
		
		[Embed(source="../../../../media/levels/scrollingCamera.oep", mimeType="application/octet-stream")]
		public static const OGMO_SCROLLING_PROJECT:Class;
		
		[Embed(source="../../../../media/levels/scrollingLevel.oel", mimeType="application/octet-stream")]
		public static const SCROLLING_LEVEL:Class;
		
		//------------
		//  texture atlas
		//------------
		
		[Embed(source="../../../../media/textures/textureAtlas.png")]
		public static const ATLAS_TEXTURE:Class;
		[Embed(source = "../../../../media/textures/textureAtlas.xml", mimeType = "application/octet-stream")]
		public static const ATLAS_DATA:Class;
		
		//----------
		//  textures
		//----------
		[Embed(source = "../../../../media/textures/Alien.png")]
		public static const ALIEN_TEXTURE:Class;
		
		[Embed(source="../../../../media/textures/Ship.png")]
		public static const SHIP_TEXTURE:Class;
		
		//----------
		//  fonts
		//----------
		[Embed(source = "../../../../media/fonts/bmpFontData.fnt", mimeType = "application/octet-stream")]
		public static const FONT_DATA:Class;
		
		[Embed(source="../../../../media/fonts/bmpFontTexture.png")]
		public static const BMP_FONT_TEXTURE:Class;
		
		//----------
		//  particles
		//----------
		[Embed(source="../../../../media/particles/explosion.pex", mimeType="application/octet-stream")]
		public static const PARTICLE_DATA:Class;
		
		[Embed(source="../../../../media/particles/explosionTexture.png")]
		public static const PARTICLE_TEXTURE:Class;
		
	}
}