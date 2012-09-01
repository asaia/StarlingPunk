package com.saia.starlingPunk.masks 
{
	import com.saia.starlingPunk.SPMask;
	
	/**
	 * A Mask that can contain multiple Masks of one or various types.
	 */
	public class SPMasklist extends SPHitbox
	{
		/**
		 * Constructor.
		 * @param	...mask		Masks to add to the list.
		 */
		public function SPMasklist(...mask) 
		{
			for each (var m:SPMask in mask) add(m);
		}
		
		/** @private Collide against a mask. */
		override public function collide(mask:SPMask):Boolean 
		{
			for each (var m:SPMask in _masks)
			{
				if (m.collide(mask)) return true;
			}
			return false;
		}
		
		/** @private Collide against a Masklist. */
		override protected function collideMasklist(other:SPMasklist):Boolean 
		{
			for each (var a:SPMask in _masks)
			{
				for each (var b:SPMask in other._masks)
				{
					if (a.collide(b)) return true;
				}
			}
			return true;
		}
		
		/**
		 * Adds a Mask to the list.
		 * @param	mask		The Mask to add.
		 * @return	The added Mask.
		 */
		public function add(mask:SPMask):SPMask
		{
			_masks[_count ++] = mask;
			mask.list = this;
			update();
			return mask;
		}
		
		/**
		 * Removes the Mask from the list.
		 * @param	mask		The Mask to remove.
		 * @return	The removed Mask.
		 */
		public function remove(mask:SPMask):SPMask
		{
			if (_masks.indexOf(mask) < 0) return mask;
			_temp.length = 0;
			for each (var m:SPMask in _masks)
			{
				if (m == mask)
				{
					mask.list = null;
					_count --;
					update();
				}
				else _temp[_temp.length] = m;
			}
			var temp:Vector.<SPMask> = _masks;
			_masks = _temp;
			_temp = temp;
			return mask;
		}
		
		/**
		 * Removes the Mask at the index.
		 * @param	index		The Mask index.
		 */
		public function removeAt(index:uint = 0):void
		{
			_temp.length = 0;
			var i:int = _masks.length;
			index %= i;
			while (i --)
			{
				if (i == index)
				{
					_masks[index].list = null;
					_count --;
					update();
				}
				else _temp[_temp.length] = _masks[index];
			}
			var temp:Vector.<SPMask> = _masks;
			_masks = _temp;
			_temp = temp;
		}
		
		/**
		 * Removes all Masks from the list.
		 */
		public function removeAll():void
		{
			for each (var m:SPMask in _masks) m.list = null;
			_masks.length = _temp.length = _count = 0;
			update();
		}
		
		/**
		 * Gets a Mask from the list.
		 * @param	index		The Mask index.
		 * @return	The Mask at the index.
		 */
		public function getMask(index:uint = 0):SPMask
		{
			return _masks[index % _masks.length];
		}
		
		/** @private Updates the parent's bounds for this mask. */
		override protected function update():void 
		{
			// find bounds of the contained masks
			var t:int, l:int, r:int, b:int, h:SPHitbox, i:int = _count;
			while (i --)
			{
				if ((h = _masks[i] as SPHitbox))
				{
					if (h._x < l) l = h._x;
					if (h._y < t) t = h._y;
					if (h._x + h._width > r) r = h._x + h._width;
					if (h._y + h._height > b) b = h._y + h._height;
				}
			}
			
			// update hitbox bounds
			_x = l;
			_y = t;
			_width = r - l;
			_height = b - t;
			super.update();
		}
		
		/**
		 * Amount of Masks in the list.
		 */
		public function get count():uint { return _count; }
		
		// List information.
		/** @private */ private var _masks:Vector.<SPMask> = new Vector.<SPMask>;
		/** @private */ private var _temp:Vector.<SPMask> = new Vector.<SPMask>;
		/** @private */ private var _count:uint;
	}
}