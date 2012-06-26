package com.saia.starlingPunkExample.embeds 
{
	/**
	 * ...
	 * @author Andy Saia
	 */
	public class ExampleAssets 
	{
		//----------
		//  textures
		//----------
		
		[Embed(source = "../../../../media/textures/Alien.png")]
		public static const ALIEN_TEXTURE:Class;
		
		[Embed(source = "../../../../media/textures/Ship.png")]
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