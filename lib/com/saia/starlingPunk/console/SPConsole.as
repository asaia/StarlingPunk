package com.saia.starlingPunk.console 
{
	import com.saia.starlingPunk.SP;
	import com.saia.starlingPunk.SPEntity;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	/**
	 * This is the basic placeholder for the console class, very little is working right now and should be avoided by typical users.
	 * @author Andy Saia
	 */
	public class SPConsole 
	{
		private var _enabled:Boolean;
		private var _container:Sprite;
		private var _allHitGraphics:Vector.<Image>;
		
		public function SPConsole() 
		{
		}
		
		//-------------------
		//  public methods
		//-------------------
		
		public function enable():void
		{
			trace("WARNING: the console class has not been implemented yet, this functionality provided here should be considered extremely experimental.");
			
			
			//return if already enabled
			if (_enabled) return;
			
			_enabled = true;
			
			_container = new Sprite();
			SP.camera.container.addChild(_container);
			_allHitGraphics = new Vector.<Image>();
		}
		
		public function update():void
		{
			//get out if console isn't enabled
			if (!_enabled) return;
			_container.parent.setChildIndex(_container, _container.parent.numChildren - 1);
			renderHitBoxes();
		}
		
		//-------------------
		//  private methods
		//-------------------
		
		private function renderHitBoxes():void 
		{
			if (!SP.world) return;
			
			var hitBoxes:Vector.<Rectangle> = getHitBoxes();
			var numHitBoxes:int = hitBoxes.length;
			if (numHitBoxes == 0) return;
			
			//this method isn't working objects pop in and out
			getHitRectsForEntities(hitBoxes);
			
			for (var i:int = 0; i < numHitBoxes; i++) 
			{	
				var hitRect:Rectangle = hitBoxes[i];
				var hitGraphic:Image = _allHitGraphics[i];
				hitGraphic.x = hitRect.x;
				hitGraphic.y = hitRect.y;
				hitGraphic.width = hitRect.width;
				hitGraphic.height = hitRect.height;
			}
		}
		
		private function getHitBoxes():Vector.<Rectangle>
		{
			//sure there are faster ways of doing this
			var entites:Vector.<SPEntity> = SP.world.getAllEntities();
			var hitBoxes:Vector.<Rectangle> = new Vector.<Rectangle>();
			var numEntities:int = entites.length;
			for (var i:int = 0; i < numEntities; i++) 
			{
				var entity:SPEntity = entites[i];
				var hitbox:Rectangle = entity.hitBounds;
				if (hitbox.width != 0 || hitbox.height != 0)
					hitBoxes.push(hitbox);
			}
			
			return hitBoxes;
		}
		
		private function getHitRectsForEntities(allHitBoxes:Vector.<Rectangle>):void
		{
			var numHitBoxes:int = allHitBoxes.length;			
			if (numHitBoxes == _allHitGraphics.length) return;
			
			while(numHitBoxes < _allHitGraphics.length)
			{
				var lastIndex:int = 0;
				var oldImage:Image = _allHitGraphics[lastIndex];
				_allHitGraphics.splice(lastIndex, 1);
				oldImage.removeFromParent(true);
				//TODO: probably should pool these
			}
			
			
			while(numHitBoxes > _allHitGraphics.length)
			{
				var newImage:Image = getHitRectGraphic();
				_allHitGraphics.push(newImage);
				_container.addChild(newImage);
			}
		}
		
		private function getHitRectGraphic():Image
		{
			var shape:Shape = new Shape();
			var lineWidth:Number = 5;
			shape.graphics.lineStyle(lineWidth, 0xFF0000);
			shape.graphics.drawRect(0, 0, 100, 100);
			var bitmapData:BitmapData = new BitmapData(100, 100, true, 0x00FFFFFF);
			bitmapData.draw(shape);
			var hitRectGraphic:Image = new Image(Texture.fromBitmapData(bitmapData));
			hitRectGraphic.touchable = false;
			return hitRectGraphic;
		}
		
		public function destory():void
		{
			//TODO: clean everything up	
		}
	}
}