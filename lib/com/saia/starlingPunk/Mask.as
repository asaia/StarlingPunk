package com.saia.starlingPunk
{
	import com.saia.starlingPunk.masks.Masklist;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Base class for Entity collision masks.
	 */
	public class Mask 
	{
		/**
		 * The parent Entity of this mask.
		 */
		public var parent:SPEntity;
		
		/**
		 * The parent Masklist of the mask.
		 */
		public var list:Masklist;
		
		/**
		 * Constructor.
		 */
		public function Mask() 
		{
			_class = Class(getDefinitionByName(getQualifiedClassName(this)));
			_check[Mask] = collideMask;
			_check[Masklist] = collideMasklist;
		}
		
		/**
		 * Checks for collision with another Mask.
		 * @param	mask	The other Mask to check against.
		 * @return	If the Masks overlap.
		 */
		public function collide(mask:Mask):Boolean
		{
			if (_check[mask._class] != null) return _check[mask._class](mask);
			if (mask._check[_class] != null) return mask._check[_class](this);
			return false;
		}
		
		/** @private Collide against an Entity. */
		private function collideMask(other:Mask):Boolean
		{
			return parent.x - parent.pivotX + parent.width > other.parent.x - other.parent.pivotX
				&& parent.y - parent.pivotY + parent.height > other.parent.y - other.parent.pivotY
				&& parent.x - parent.pivotX < other.parent.x - other.parent.pivotX + other.parent.width
				&& parent.y - parent.pivotY < other.parent.y - other.parent.pivotY + other.parent.height;
		}
		
		/** @private Collide against a Masklist. */
		protected function collideMasklist(other:Masklist):Boolean
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