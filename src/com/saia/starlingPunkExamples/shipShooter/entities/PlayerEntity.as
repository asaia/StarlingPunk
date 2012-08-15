package com.saia.starlingPunkExamples.shipShooter.entities 
{
	import com.saia.starlingPunk.effects.SPEffects;
	import com.saia.starlingPunk.SP;
	import com.saia.starlingPunk.SPEntity;
	import com.saia.starlingPunk.utils.Key;
	import com.saia.starlingPunk.utils.SPInput;
	import com.saia.starlingPunkExamples.embeds.ExampleAssets;
	import com.saia.starlingPunkExamples.shipShooter.particles.ExplosionParticles;
	import starling.display.Image;
	
	/**
	 * ...
	 * @author Andy Saia
	 */
	public class PlayerEntity extends SPEntity 
	{
		private var _speed:Number = 5;
		private var _isDead:Boolean;
		
		public function PlayerEntity() 
		{
			type = "player";
		}
		
		//----------
		//  getters and setters
		//----------
		
		public function get isDead():Boolean 
		{
			return _isDead;
		}
		
		//----------
		//  overrides
		//----------
		
		override public function added():void 
		{
			super.added();
			var image:Image = Image.fromBitmap(new ExampleAssets.SHIP_TEXTURE());
			addChild(image);
			
			this.x = width;
			this.y = SP.halfHeight - height / 2;
			_isDead = false;
		}
		
		override public function removed():void 
		{
			super.removed();
			removeChildren(0, -1, true);
			_isDead = true;
		}
		
		override public function update():void 
		{
			super.update();
			handleInput();
			checkBounds();
			checkCollision();
		}
		
		//----------
		//  private methods
		//----------
		
		private function handleInput():void 
		{
			if (SPInput.check(Key.LEFT))
			{
				x -= _speed;
			}
			
			if (SPInput.check(Key.RIGHT))
			{
				x += _speed;
			}
			
			if (SPInput.check(Key.UP))
			{
				y -= _speed;
			}
			
			if (SPInput.check(Key.DOWN))
			{
				y += _speed;
			}
			
			if (SPInput.pressed(Key.SPACE))
			{
				world.add(new BulletEntity(x + width, y + height * .5));
			}
		}
		
		private function checkBounds():void 
		{
			if (x > SP.width - width)
			{
				x = SP.width - width;
			}else if (x < 0)
			{
				x = 0;
			}
			
			if (y > SP.height - height)
			{
				y = SP.height - height;
			} else if (y < 0)
			{
				y = 0;
			}
		}
		
		private function checkCollision():void 
		{
			var enemy:SPEntity = collide("alien", x, y);
			if (enemy)
			{
				SPEffects.shake(25, 500);
				destroyAllEnemies();
				var restartText:RestartText = new RestartText();
				world.add(restartText);
				world.remove(this);
			}
		}
		
		private function destroyAllEnemies():void 
		{
			var allEnemies:Vector.<SPEntity> = world.getType("alien");
			if (!allEnemies) return;
			for each (var enemy:SPEntity in allEnemies) 
			{
				world.remove(enemy);
				var explosion:ExplosionParticles = new ExplosionParticles();
				explosion.start(x, y);
			}
		}
	}
}