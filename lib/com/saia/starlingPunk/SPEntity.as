package com.saia.starlingPunk 
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	/**
	 * Main game Entity class updated by World.
	 * @author Andy Saia
	 */
	public class SPEntity extends Sprite
	{
		private var _world:SPWorld;
		private var _type:String;
		private var _hitBounds:Rectangle;
		
		public function SPEntity(x:Number = 0, y:Number = 0, type:String = "") 
		{
			this.x = x;
			this.y = y;
			this._type = type;
		}
		
		//----------
		//  getters and setters
		//----------
		
		public function get world():SPWorld 
		{
			return _world;
		}
		
		public function set world(value:SPWorld):void 
		{
			_world = value;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function set type(value:String):void 
		{
			_type = value;
		}
		
		public function get hitBounds():Rectangle 
		{
			return _hitBounds;
		}
		
		public function set hitBounds(value:Rectangle):void 
		{
			_hitBounds = value;
		}
		
		//-------------------
		//  public methods
		//-------------------
		
		/**
		* Checks if this Entity collides with a specific Entity.
		* @param	entity	The Entity to collide against.
		* @param	x		Virtual x position to place this Entity.
		* @param	y		Virtual y position to place this Entity.
		* @return	The Entity if they overlap, or null if they don't.
		*/
		public function collideWith(entity:SPEntity, x:Number, y:Number):SPEntity
		{
			var tempRect:Rectangle = this.getRect(x, y);
			
			var entityRect:Rectangle = entity.getRect(entity.x, entity.y);
			
			var rectIntersection:Rectangle = tempRect.intersection(entityRect);
			
			var hitEntity:SPEntity = null;
			if (rectIntersection.width != 0 && rectIntersection.height != 0)
			{
				hitEntity = entity;
			}
			return hitEntity;
		}
		
		
		/**
		 * Checks for a collision against an Entity type.
		 * @param	type		The Entity type to check for.
		 * @param	x			Virtual x position to place this Entity.
		 * @param	y			Virtual y position to place this Entity.
		 * @return	The first Entity collided with, or null if none were collided.
		*/
		public function collide(type:String, x:Number, y:Number):SPEntity
		{
			if (!this.world) return null;
			var entity:SPEntity;
			
			var allEnitiesOfType:Vector.<SPEntity> = this.world.getType(type);
			//if undefined return
			if (!allEnitiesOfType) return null;
			var numEnities:int = allEnitiesOfType.length;
			//if 0 return
			if (!numEnities) return null;
			
			for (var i:int = 0; i < numEnities; i++) 
			{
				var currentEntity:SPEntity = allEnitiesOfType[i];
				entity = this.collideWith(currentEntity, x, y);
				if (entity) 
					return entity;
			}
			return entity;
		}
		
		/**
		 * gets the correct rectange based of bounds of entity and pivot point
		 * @param	xOffset Virtual x position to place this Entity.
		 * @param	yOffset Virtual y position to place this Entity.
		 * @return
		 */
		public function getRect(xOffset:Number, yOffset:Number):Rectangle
		{
			var rect:Rectangle = this.getBounds(this);
			if (_hitBounds)
				rect = _hitBounds;
			else
				rect = this.getBounds(this);
			rect.x = xOffset - this.pivotX;
			rect.y = yOffset - this.pivotY;
			return rect;
		}
		
		/**
		 * displays hitbox for debug purposes 
		 */
		public function showHitBox():void
		{
			var shape:Shape = new Shape();
			var hitRect:Rectangle = getRect(this.x, this.y);
			shape.graphics.lineStyle(1, 0xFF0000);
			shape.graphics.drawRect(0, 0, hitRect.width, hitRect.height);
			
			if (hitRect.width == 0) return;
			var bmpData:BitmapData = new BitmapData(hitRect.width + 2, hitRect.height + 2, true, 0xFF);
			bmpData.draw(shape, shape.transform.matrix, shape.transform.colorTransform);
			var image:Image = new Image(Texture.fromBitmapData(bmpData));
			addChild(image);
			
			
		}
		
		/**
		 * sets the hit bounds width
		 * @param	width
		 */
		public function setHitWidth(width:Number):void
		{
			var rect:Rectangle = getRect(this.x, this.y);
			rect.width = width;
			_hitBounds = rect;
		}
		
		/**
		 * sets the hit bounds height
		 * @param	width
		 */
		public function setHitHeight(height:Number):void
		{
			var rect:Rectangle = getRect(this.x, this.y);
			rect.height = height;
			_hitBounds = rect;
		}
		
		
		//----------
		//  abstract methods
		//----------
		
		
		/**
		* Override this; called when Entity updates
		*/
		public function update():void { }
		
		/**
		* Override this, called when the Entity is added to a World.
		*/
		public function added():void { }
		
		/**
		* Override this, called when the Entity is removed from a World.
		*/
		public function removed():void { }
		
		/**
		* Override this not called internally 
		*/
		public function destroy():void { }
		
	}
}