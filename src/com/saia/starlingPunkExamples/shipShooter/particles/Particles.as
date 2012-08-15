package com.saia.starlingPunkExamples.shipShooter.particles 
{
	import flash.display.Bitmap;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Andy Saia
	 */
	public class Particles 
	{
		private var _particles:PDParticleSystem;
		
		public function Particles(config:XML, textureAsset:Bitmap) 
		{
			var texture:Texture = Texture.fromBitmap(textureAsset);
			_particles = new PDParticleSystem(config, texture);
		}
		
		//----------
		//  getters and setters 
		//----------
		
		public function get particles():PDParticleSystem 
		{
			return _particles;
		}
		
		//----------
		//  public methods
		//----------
		
		public function start(x:Number = 0, y:Number = 0 ):void
		{	
			_particles.start(0.1);
			_particles.emitterX = x;
			_particles.emitterY = y;
			
			Starling.current.stage.addChild(_particles);
			Starling.juggler.add(_particles);
			_particles.addEventListener(Event.COMPLETE, onParticleComplete);
		}
		
		//----------
		//  event handlers
		//----------
		
		private function onParticleComplete(e:Event):void 
		{
			_particles.removeEventListeners();
			Starling.juggler.remove(_particles);
			_particles.removeFromParent(true);
		}
	}
}