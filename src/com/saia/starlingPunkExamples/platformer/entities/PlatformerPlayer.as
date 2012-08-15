package com.saia.starlingPunkExamples.platformer.entities 
{
	import com.saia.starlingPunk.SP;
	import com.saia.starlingPunk.SPEntity;
	import com.saia.starlingPunk.utils.Key;
	import com.saia.starlingPunk.utils.SPInput;
	import com.saia.starlingPunkExamples.embeds.ExampleAssets;
	import com.saia.starlingPunkExamples.platformer.controllers.LevelController;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author Andy Saia
	 */
	public class PlatformerPlayer extends SPEntity 
	{
		private static var FRICTION:Number = .5;
		private static var ACEL:Number = 1;
		private static var JUMP_AMOUNT:Number = 7;
		private static var GRAVITY:Number = .2;
		private static var MAX_SPEED:Number = 4;
		private static var JUMP_SPEED:Number = 7;
		
		private var _vel:Point;
		private var _isJumpReleased:Boolean;
		
		public function PlatformerPlayer() 
		{
			super(40, 40, "player");
		}
	
		//-------------------
		//  overrides
		//-------------------
		
		override public function added():void 
		{
			super.added();
			setupGraphic();
			_vel = new Point();
			_isJumpReleased = true;
			
			//define input
			SPInput.define("right", [Key.RIGHT, Key.D]);
			SPInput.define("left", [Key.LEFT, Key.A]);
			SPInput.define("jump", [Key.UP, Key.W]);
		}
		
		override public function removed():void 
		{
			removeChildren(0, -1, true);
			super.removed();
		}
	
		override public function update():void 
		{
			super.update();
			updateMovement();
			updateInput();
			updateCollision();
		}
		
		//-------------------
		//  private methods 
		//-------------------
		
		private function updateInput():void 
		{
			if (SPInput.check("left"))
			{
				_vel.x -= ACEL;
			} else if (SPInput.check("right"))
			{
				_vel.x += ACEL;
			}
			
			if (SPInput.check("jump") && this.collide("collision", x, y + 1) && _isJumpReleased) 
			{
				_vel.y = -JUMP_SPEED;
				_isJumpReleased = false;
			}
			
			if (SPInput.released("jump")) 
			{
				_isJumpReleased = true;
			}
		}
		
		private function updateMovement():void 
		{
			//friction
			if (!SPInput.check("left") && !SPInput.check("right")) 
			{
				_vel.x -= SP.sign(_vel.x) * FRICTION;
				if (Math.abs(_vel.x) <= 0.1) 
				{
					_vel.x = 0;
				}
			}
			
			//fall twice as fast if jump key isn't pressed
			if (!SPInput.check("jump") && _vel.y < 0) 
			{
				_vel.y += GRAVITY;
			}
			
			//sets max speed
			if (Math.abs(_vel.x) > MAX_SPEED) 
			{
				_vel.x = SP.sign(_vel.x) * MAX_SPEED;
			}
			
			//update x and y movement
			for (var i:int = 0; i < Math.abs(_vel.x); i += 1) 
			{
				if (!collide("collision", x + SP.sign(_vel.x), y)) 
				{
					x += SP.sign(_vel.x); 
				} else 
				{
					_vel.x = 0; 
					break;
				}
			}
		
			for (i = 0; i < Math.abs(_vel.y); i += 1) 
			{
				if (!collide("collision", x, y + (SP.sign(_vel.y)))) 
				{
					y += SP.sign(_vel.y); 
				} else 
				{
					_vel.y = 0;
					break; 
				}
			}
			
			_vel.y += GRAVITY;
			
		}
		
		private function updateCollision():void 
		{
			if (collide("goal", x, y))
			{
				SP.world = LevelController.nextLevel();
				world.remove(this);
			}
			
		}
		
		private function setupGraphic():void 
		{
			var textureAtlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new ExampleAssets.ATLAS_TEXTURE()), XML(new ExampleAssets.ATLAS_DATA()));
			var image:Image = new Image(textureAtlas.getTexture("burger"));
			addChild(image);
		}
		
	}

}