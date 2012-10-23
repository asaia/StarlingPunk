package com.saia.starlingPunk 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import starling.display.Sprite;
	
	/**
	 * Main game Entity class updated by World.
	 * @author Andy Saia
	 */
	
	public class SPEntity extends Sprite
	{
		private var _world:SPWorld;
		private var _type:String;
		private var _hitBounds:Rectangle;
		private var _collidable:Boolean;
		private var _layer:uint;
		private var _originX:Number;
		private var _originY:Number;
		public var _worldX:Number;
		private var _worldY:Number
		
		// Collision information.
		private const HITBOX:SPMask = new SPMask;
		private var _mask:SPMask;
		internal var _class:Class;
		
		public function SPEntity(x:Number = 0, y:Number = 0, type:String = "", mask:SPMask = null) 
		{
			_layer = 1;
			_originX = 0;
			_originY = 0;
			_collidable = true;
			_worldX = 0;
			_worldY = 0;
			
			this.x = x;
			this.y = y;
			if (type == "")
				type = getQualifiedClassName(this);
			this._type = type;
			
			if (mask) this.mask = mask;
			HITBOX.assignTo(this);
			_class = Class(getDefinitionByName(getQualifiedClassName(this)));
		}
		
		//----------
		//  getters and setters
		//----------
		
		/**
		 * The World object this Entity has been added to.
		 */
		public function get world():SPWorld {	return _world; }
		public function set world(value:SPWorld):void 
		{
			_world = value;
		}
		
		/**
		 * The collision type, used for collision checking.
		 */
		public function get type():String { return _type; }
		public function set type(value:String):void 
		{
			if (world)
				world.changeEntityTypeName(_type, value);
			_type = value;
		}
		
		/**
		 * The rectange bounds of the entity used for rectangle collision detection
		 */
		public function get hitBounds():Rectangle { return _hitBounds; }
		public function set hitBounds(value:Rectangle):void 
		{
			_hitBounds = value;
		}
		
		/**
		 * If the Entity should respond to collision checks.
		 */
		public function get collidable():Boolean { return _collidable; }
		public function set collidable(value:Boolean):void 
		{
			_collidable = value;
		}
		
		/**
		 * An optional Mask component, used for specialized collision. If this is
		 * not assigned, collision checks will use the Entity's hitbox by default.
		 */
		public function get mask():SPMask { return _mask; }
		public function set mask(value:SPMask):void 
		{	
			if (_mask == value) return;
			if (_mask) _mask.assignTo(null);
			_mask = value;
			if (value) _mask.assignTo(this);
		}
		
		/**
		 * The rendering layer of this Entity. Higher layers are rendered first.
		 */
		public function get layer():uint 
		{ return _layer; }
		public function set layer(value:uint):void 
		{
			var temp:uint = value
			if (world && this.parent)
			{
				if (temp > world.numChildren)
					temp = world.numChildren;
				world.setChildIndex(this, temp);
			}
			_layer = value;
		}
		
				
		/**
		 * X origin of the Entity's hitbox.
		 */
		public function get originX():Number 
		{
			return _originX;
		}
		
		public function set originX(value:Number):void 
		{
			_originX = value;
		}
		
		/**
		 * Y origin of the Entity's hitbox.
		 */
		public function get originY():Number 
		{
			return _originY;
		}
		
		public function set originY(value:Number):void 
		{
			_originY = value;
		}
		
		/**
		 * returns the width of the entities hit box
		 */
		public function get hitWidth():Number 
		{
			return getRect(x, y).width;
		}
		
		public function set hitWidth(value:Number):void 
		{
			setHitWidth(value);
		}
		
		/**
		 * returns the height of the entities hit box
		 */
		public function get hitHeight():Number 
		{
			return getRect(x, y).height;
		}
		
		public function set hitHeight(value:Number):void 
		{
			setHitHeight(value);
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
			if (!_world || !this.collidable || !entity.collidable) return null;
			
			var oldPos:Point = new Point(this.x, this.y);
			this.x = x;
			this.y = y;
			
			var entityRect:Rectangle = entity.getRect(entity.x, entity.y);
			var hitEntity:SPEntity = null;
			if (collideRect(entityRect, this.x, this.y))
			{
				if (!_mask)
				{
					//trace(!entity._mask);
					if (!entity._mask || entity._mask.collide(HITBOX))
					{
						this.x = oldPos.x;
						this.y = oldPos.y;
						return entity;
					}
					this.x = oldPos.x;
					this.y = oldPos.y;
					return null;
				}
				if (_mask.collide(entity._mask ? entity._mask : entity.HITBOX))
				{
					this.x = oldPos.x;
					this.y = oldPos.y;
					return entity;
				}
			}
			
			this.x = oldPos.x;
			this.y = oldPos.y;
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
		 * Checks for collision against multiple Entity types.
		 * @param	types		An Array or Vector of Entity types to check for.
		 * @param	x			Virtual x position to place this Entity.
		 * @param	y			Virtual y position to place this Entity.
		 * @return	The first Entity collided with, or null if none were collided.
		 */
		public function collideTypes(types:Object, x:Number, y:Number):SPEntity
		{
			if (!_world) return null;
			var entity:SPEntity;
			for each (var type:String in types)
			{
				if ((entity = collide(type, x, y))) return entity;
			}
			return null;
		}
		
		/**
		 * collide Rectangle
		 * @param	rect
		 */
		public function collideRect(rect:Rectangle, xOffset:Number, yOffset:Number):Boolean 
		{
			var tempRect:Rectangle = this.getRect(xOffset, yOffset);
			var bool:Boolean = false;
			var rectIntersection:Rectangle = tempRect.intersection(rect);
			if (rectIntersection.width != 0 && rectIntersection.height != 0)
			{
				bool = true;
			}
			return bool;
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
				
			rect.x = xOffset - pivotX - _originX;
			rect.y = yOffset - pivotY - _originY;
			return rect;
		}
		
		/**
		 * Sets the Entity's hitbox properties.
		 * @param	width		Width of the hitbox.
		 * @param	height		Height of the hitbox.
		 * @param	originX		X origin of the hitbox.
		 * @param	originY		Y origin of the hitbox.
		 */
		public function setHitbox(width:int = 0, height:int = 0, originX:int = 0, originY:int = 0):void
		{
			this.width = width;
			this.height = height;
			this.originX = originX;
			this.originY = originY;
		}
		
		/**
		 * Sets the origin of the Entity.
		 * @param	x		X origin.
		 * @param	y		Y origin.
		 */
		public function setOrigin(x:int = 0, y:int = 0):void
		{
			originX = x;
			originY = y;
		}
		
		/**
		 * Center's the Entity's origin (half width and height).
		 */
		public function centerOrigin():void
		{
			originX = (hitWidth / 2) - width / 2;
			originY = (hitHeight / 2) - height / 2;
		}
		
		/**
		 * displays hitbox for debug purposes 
		 */
		/*
		 * This method doesn't seem to reliably display the position of the entites hitbox so its been commented out until a better way to do this is figured out
		 * 
		public function showHitBox(x:Number, y:Number):void
		{
			var shape:Shape = new Shape();
			var hitRect:Rectangle = getRect(x, y);
			shape.graphics.lineStyle(1, 0xFF0000);
			shape.graphics.drawRect(0, 0, hitRect.width, hitRect.height);
			
			if (hitRect.width == 0) return;
			var bmpData:BitmapData = new BitmapData(hitRect.width + 2, hitRect.height + 2, true, 0xFF);
			bmpData.draw(shape, shape.transform.matrix, shape.transform.colorTransform);
			var image:Image = new Image(Texture.fromBitmapData(bmpData));
			addChild(image);
			image.x = x - this.x;
			image.y = y - this.y;
		}
		*/
		
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
		public function update():void 
		{
			var point:Point = new Point(x, y);
			point = localToGlobal(point);
			_worldX = point.x;
		}
		
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