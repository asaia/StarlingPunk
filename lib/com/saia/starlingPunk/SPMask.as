package com.saia.starlingPunk
{
	import com.saia.starlingPunk.masks.SPMasklist;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Base class for Entity collision masks.
	 */
	public class SPMask
	{
		/**
		 * The parent Entity of this mask.
		 */
		public var parent:SPEntity;
		
		/**
		 * The parent Masklist of the mask.
		 */
		public var list:SPMasklist;
		
		/**
		 * Constructor.
		 */
		public function SPMask() 
		{
			_class = Class(getDefinitionByName(getQualifiedClassName(this)));
			_check[SPMask] = collideMask;
			_check[SPMasklist] = collideMasklist;
		}
		
		/**
		 * Checks for collision with another Mask.
		 * @param	mask	The other Mask to check against.
		 * @return	If the Masks overlap.
		 */
		public function collide(mask:SPMask):Boolean
		{
			if (_check[mask._class] != null) return _check[mask._class](mask);
			if (mask._check[_class] != null) return mask._check[_class](this);
			return false;
		}
		
		/** @private Collide against an Entity. */
		private function collideMask(other:SPMask):Boolean
		{
			return parent.collideRect(other.parent.getRect(other.parent.x, other.parent.y), parent.x, parent.y);
			return parent.x - parent.pivotX + parent.originX + parent.hitWidth > other.parent.x - other.parent.pivotX - other.parent.originX
				&& parent.y - parent.pivotY + parent.originY + parent.hitHeight > other.parent.y - other.parent.pivotY - other.parent.originY
				&& parent.x - parent.pivotX - parent.originX < other.parent.x - other.parent.pivotX - other.parent.originX + other.parent.hitWidth
				&& parent.y - parent.pivotY - parent.originY < other.parent.y - other.parent.pivotY - other.parent.originY + other.parent.hitHeight;
		}
		
		/** @private Collide against a Masklist. */
		protected function collideMasklist(other:SPMasklist):Boolean
		{
			return other.collide(this);
		}
		
		/** @private Assigns the mask to the parent. */
		internal function assignTo(parent:SPEntity):void
		{
			this.parent = parent;
			if (parent) update();
		}
		
		/** @private Updates the parent's bounds for this mask. */
		protected function update():void
		{
		}
		
		// Mask information.
		/** @private */ private var _class:Class;
		/** @private */ protected var _check:Dictionary = new Dictionary;
	}
}