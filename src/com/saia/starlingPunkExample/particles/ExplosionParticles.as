package com.saia.starlingPunkExample.particles 
{
	import com.saia.starlingPunkExample.embeds.ExampleAssets;
	/**
	 * ...
	 * @author Andy Saia
	 */
	public class ExplosionParticles extends Particles 
	{
		
		public function ExplosionParticles() 
		{
			super(XML(new ExampleAssets.PARTICLE_DATA()), new ExampleAssets.PARTICLE_TEXTURE());
		}
	}
}