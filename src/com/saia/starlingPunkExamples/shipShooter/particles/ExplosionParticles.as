package com.saia.starlingPunkExamples.shipShooter.particles 
{
	import com.saia.starlingPunkExamples.embeds.ExampleAssets;
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