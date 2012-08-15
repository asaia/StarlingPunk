package com.saia.starlingPunkExamples.shipShooter.entities 
{
	import com.saia.starlingPunk.helpers.SPMath;
	import com.saia.starlingPunk.SP;
	import com.saia.starlingPunk.SPEntity;
	import com.saia.starlingPunkExamples.embeds.ExampleAssets;
	import starling.display.Image;
	
	/**
	 * ...
	 * @author Andy Saia
	 */
	public class AlienEntity extends SPEntity 
	{
		private var _speed:Number;
		public function AlienEntity() 
		{
			type = "alien";
		}
		
		//----------
		//  overrides
		//----------
		
		override public function added():void 
		{
			super.added();
			
			var image:Image = Image.fromBitmap(new ExampleAssets.ALIEN_TEXTURE());
			addChild(image);
			
			this.x = SP.width - width;
			this.y = Math.random() * SP.height;
			
			_speed = SPMath.range(3, 7);
		}
		
		override public function removed():void 
		{
			super.removed();
			removeChildren(0, -1, true);
		}
		
		override public function update():void 
		{
			super.update();
			this.x -= _speed;
			this.y += Math.cos(x / 30) * 3;
			
			checkBounds();
		}
		
		//----------
		//  private methods
		//----------
		
		private function checkBounds():void 
		{
			if (x < -width)
			{
				world.remove(this);
			}
		}
	}
}