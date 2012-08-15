package com.saia.starlingPunkExamples.shipShooter.entities 
{
	import com.saia.starlingPunk.SP;
	import com.saia.starlingPunk.SPEntity;
	import com.saia.starlingPunkExamples.shipShooter.controller.ScoreController;
	import com.saia.starlingPunkExamples.shipShooter.particles.ExplosionParticles;
	import flash.display.BitmapData;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Andy Saia
	 */
	public class BulletEntity extends SPEntity 
	{
		private var _speed:Number;
		public function BulletEntity(x:Number, y:Number) 
		{
			super(x, y, "bullet");
		}
		
		override public function added():void 
		{
			super.added();
			var bmpData:BitmapData = new BitmapData(16, 4, false, 0x597137);
			var img:Image = new Image(Texture.fromBitmapData(bmpData));
			addChild(img);
			
			_speed = 20;
		}
		
		override public function update():void 
		{
			super.update();
			this.x += _speed;
			
			checkBounds();
			checkCollision();
		}
		
		override public function removed():void 
		{
			super.removed();
			removeChildren(0, -1, true);
		}
		
		//----------
		//  private methods
		//----------
		
		private function checkBounds():void 
		{
			if (this.x > SP.width)
			{
				world.remove(this);
			}
		}
		
		private function checkCollision():void
		{
			var alien:SPEntity = collide("alien", x, y)
			if (alien)
			{
				ScoreController.increaseScore();
				var explosion:ExplosionParticles = new ExplosionParticles();
				explosion.start(x, y);
				world.remove(alien);
				world.remove(this);
			}
		}
	}
}