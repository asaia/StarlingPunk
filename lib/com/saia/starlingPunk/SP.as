package com.saia.starlingPunk
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.Stage;
	
	/**
	 * Static catch-all class used to access global properties and functions.
	 */
	public class SP 
	{
		/**
		 * The StarlingPunk version.
		 */
		public static const VERSION:String = "1.3";
		
		/**
		 * Width of the game.
		 */
		public static var width:uint;
		
		/**
		 * Height of the game.
		 */
		public static var height:uint;
		
		/**
		 * The time that has passed since the last frame (in seconds).
		 */
		public static var passedTime:Number;
		
		/**
		 * Half the screen width.
		 */
		public static function get halfWidth():Number { return width / 2; }
		
		/**
		 * Half the screen height.
		 */
		public static function get halfHeight():Number { return height / 2; }
		
		/**
		 * The currently active World object. When you set this, the World is flagged
		 * to switch, but won't actually do so until the end of the current frame.
		 */
		public static function get world():SPWorld { return _world; }
		public static function set world(value:SPWorld):void
		{
			if (_world == value) return;
			_goto = value;
		}
		
		/**
		 * Point used to determine drawing offset in the render loop.
		 */
		public static var camera:SPCamera = new SPCamera;
		
		/**
		 * Finds the sign of the provided value.
		 * @param	value		The Number to evaluate.
		 * @return	1 if value is greater then 0, -1 if value is less then 0, and 0 when value == 0.
		 */
		public static function sign(value:Number):int
		{
			return value < 0 ? -1 : (value > 0 ? 1 : 0);
		}
		
		/**
		 * Finds the angle (in degrees) from point 1 to point 2.
		 * @param	x1		The first x-position.
		 * @param	y1		The first y-position.
		 * @param	x2		The second x-position.
		 * @param	y2		The second y-position.
		 * @return	The angle from (x1, y1) to (x2, y2).
		 */
		public static function angle(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			var a:Number = Math.atan2(y2 - y1, x2 - x1) * DEG;
			return a < 0 ? a + 360 : a;
		}
		
		/**
		 * Sets the x/y values of the provided object to a vector of the specified angle and length.
		 * @param	object		The object whose x/y properties should be set.
		 * @param	angle		The angle of the vector, in degrees.
		 * @param	length		The distance to the vector from (0, 0).
		 * @param	x			X offset.
		 * @param	y			Y offset.
		 */
		public static function angleXY(object:Object, angle:Number, length:Number = 1, x:Number = 0, y:Number = 0):void
		{
			angle *= RAD;
			object.x = Math.cos(angle) * length + x;
			object.y = Math.sin(angle) * length + y;
		}
		
		/**
		 * Rotates the object around the anchor by the specified amount.
		 * @param	object		Object to rotate around the anchor.
		 * @param	anchor		Anchor to rotate around.
		 * @param	angle		The amount of degrees to rotate by.
		 */
		public static function rotateAround(object:Object, anchor:Object, angle:Number = 0, relative:Boolean = true):void
		{
			if (relative) angle += SP.angle(anchor.x, anchor.y, object.x, object.y);
			SP.angleXY(object, angle, SP.distance(anchor.x, anchor.y, object.x, object.y), anchor.x, anchor.y);
		}
		
		/**
		 * Find the distance between two points.
		 * @param	x1		The first x-position.
		 * @param	y1		The first y-position.
		 * @param	x2		The second x-position.
		 * @param	y2		The second y-position.
		 * @return	The distance.
		 */
		public static function distance(x1:Number, y1:Number, x2:Number = 0, y2:Number = 0):Number
		{
			return Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
		}
		
		/**
		 * Find the distance between two rectangles. Will return 0 if the rectangles overlap.
		 * @param	x1		The x-position of the first rect.
		 * @param	y1		The y-position of the first rect.
		 * @param	w1		The width of the first rect.
		 * @param	h1		The height of the first rect.
		 * @param	x2		The x-position of the second rect.
		 * @param	y2		The y-position of the second rect.
		 * @param	w2		The width of the second rect.
		 * @param	h2		The height of the second rect.
		 * @return	The distance.
		 */
		public static function distanceRects(x1:Number, y1:Number, w1:Number, h1:Number, x2:Number, y2:Number, w2:Number, h2:Number):Number
		{
			if (x1 < x2 + w2 && x2 < x1 + w1)
			{
				if (y1 < y2 + h2 && y2 < y1 + h1) return 0;
				if (y1 > y2) return y1 - (y2 + h2);
				return y2 - (y1 + h1);
			}
			if (y1 < y2 + h2 && y2 < y1 + h1)
			{
				if (x1 > x2) return x1 - (x2 + w2);
				return x2 - (x1 + w1)
			}
			if (x1 > x2)
			{
				if (y1 > y2) return distance(x1, y1, (x2 + w2), (y2 + h2));
				return distance(x1, y1 + h1, x2 + w2, y2);
			}
			if (y1 > y2) return distance(x1 + w1, y1, x2, y2 + h2)
			return distance(x1 + w1, y1 + h1, x2, y2);
		}
		
		/**
		 * Find the distance between a point and a rectangle. Returns 0 if the point is within the rectangle.
		 * @param	px		The x-position of the point.
		 * @param	py		The y-position of the point.
		 * @param	rx		The x-position of the rect.
		 * @param	ry		The y-position of the rect.
		 * @param	rw		The width of the rect.
		 * @param	rh		The height of the rect.
		 * @return	The distance.
		 */
		public static function distanceRectPoint(px:Number, py:Number, rx:Number, ry:Number, rw:Number, rh:Number):Number
		{
			if (px >= rx && px <= rx + rw)
			{
				if (py >= ry && py <= ry + rh) return 0;
				if (py > ry) return py - (ry + rh);
				return ry - py;
			}
			if (py >= ry && py <= ry + rh)
			{
				if (px > rx) return px - (rx + rw);
				return rx - px;
			}
			if (px > rx)
			{
				if (py > ry) return distance(px, py, rx + rw, ry + rh);
				return distance(px, py, rx + rw, ry);
			}
			if (py > ry) return distance(px, py, rx, ry + rh)
			return distance(px, py, rx, ry);
		}
		
		/**
		 * Clamps the value within the minimum and maximum values.
		 * @param	value		The Number to evaluate.
		 * @param	min			The minimum range.
		 * @param	max			The maximum range.
		 * @return	The clamped value.
		 */
		public static function clamp(value:Number, min:Number, max:Number):Number
		{
			if (max > min)
			{
				value = value < max ? value : max;
				return value > min ? value : min;
			}
			value = value < min ? value : min;
			return value > max ? value : max;
		}
		
		/**
		 * Clamps the object inside the rectangle.
		 * @param	object		The object to clamp (must have an x and y property).
		 * @param	x			Rectangle's x.
		 * @param	y			Rectangle's y.
		 * @param	width		Rectangle's width.
		 * @param	height		Rectangle's height.
		 */
		public static function clampInRect(object:Object, x:Number, y:Number, width:Number, height:Number, padding:Number = 0):void
		{
			object.x = clamp(object.x, x + padding, x + width - padding);
			object.y = clamp(object.y, y + padding, y + height - padding);
		}
		
		/**
		 * Transfers a value from one scale to another scale. For example, scale(.5, 0, 1, 10, 20) == 15, and scale(3, 0, 5, 100, 0) == 40.
		 * @param	value		The value on the first scale.
		 * @param	min			The minimum range of the first scale.
		 * @param	max			The maximum range of the first scale.
		 * @param	min2		The minimum range of the second scale.
		 * @param	max2		The maximum range of the second scale.
		 * @return	The scaled value.
		 */
		public static function scale(value:Number, min:Number, max:Number, min2:Number, max2:Number):Number
		{
			return min2 + ((value - min) / (max - min)) * (max2 - min2);
		}
		
		/**
		 * Transfers a value from one scale to another scale, but clamps the return value within the second scale.
		 * @param	value		The value on the first scale.
		 * @param	min			The minimum range of the first scale.
		 * @param	max			The maximum range of the first scale.
		 * @param	min2		The minimum range of the second scale.
		 * @param	max2		The maximum range of the second scale.
		 * @return	The scaled and clamped value.
		 */
		public static function scaleClamp(value:Number, min:Number, max:Number, min2:Number, max2:Number):Number
		{
			value = min2 + ((value - min) / (max - min)) * (max2 - min2);
			if (max2 > min2)
			{
				value = value < max2 ? value : max2;
				return value > min2 ? value : min2;
			}
			value = value < min2 ? value : min2;
			return value > max2 ? value : max2;
		}
		
		/**
		 * Returns the next item after current in the list of options.
		 * @param	current		The currently selected item (must be one of the options).
		 * @param	options		An array of all the items to cycle through.
		 * @param	loop		If true, will jump to the first item after the last item is reached.
		 * @return	The next item in the list.
		 */
		public static function next(current:*, options:Array, loop:Boolean = true):*
		{
			if (loop) return options[(options.indexOf(current) + 1) % options.length];
			return options[Math.max(options.indexOf(current) + 1, options.length - 1)];
		}
		
		/**
		 * Returns the item previous to the current in the list of options.
		 * @param	current		The currently selected item (must be one of the options).
		 * @param	options		An array of all the items to cycle through.
		 * @param	loop		If true, will jump to the last item after the first is reached.
		 * @return	The previous item in the list.
		 */
		public static function prev(current:*, options:Array, loop:Boolean = true):*
		{
			if (loop) return options[((options.indexOf(current) - 1) + options.length) % options.length];
			return options[Math.max(options.indexOf(current) - 1, 0)];
		}
		
		/**
		 * Swaps the current item between a and b. Useful for quick state/string/value swapping.
		 * @param	current		The currently selected item.
		 * @param	a			Item a.
		 * @param	b			Item b.
		 * @return	Returns a if current is b, and b if current is a.
		 */
		public static function swap(current:*, a:*, b:*):*
		{
			return current == a ? b : a;
		}
		
		/**
		 * Creates a color value by combining the chosen RGB values.
		 * @param	R		The red value of the color, from 0 to 255.
		 * @param	G		The green value of the color, from 0 to 255.
		 * @param	B		The blue value of the color, from 0 to 255.
		 * @return	The color uint.
		 */
		public static function getColorRGB(R:uint = 0, G:uint = 0, B:uint = 0):uint
		{
			return R << 16 | G << 8 | B;
		}
		
		/**
		 * Creates a color value with the chosen HSV values.
		 * @param	h		The hue of the color (from 0 to 1).
		 * @param	s		The saturation of the color (from 0 to 1).
		 * @param	v		The value of the color (from 0 to 1).
		 * @return	The color uint.
		 */
		public static function getColorHSV(h:Number, s:Number, v:Number):uint
		{
			h = int(h * 360);
			var hi:int = Math.floor(h / 60) % 6,
				f:Number = h / 60 - Math.floor(h / 60),
				p:Number = (v * (1 - s)),
				q:Number = (v * (1 - f * s)),
				t:Number = (v * (1 - (1 - f) * s));
			switch (hi)
			{
				case 0: return int(v * 255) << 16 | int(t * 255) << 8 | int(p * 255);
				case 1: return int(q * 255) << 16 | int(v * 255) << 8 | int(p * 255);
				case 2: return int(p * 255) << 16 | int(v * 255) << 8 | int(t * 255);
				case 3: return int(p * 255) << 16 | int(q * 255) << 8 | int(v * 255);
				case 4: return int(t * 255) << 16 | int(p * 255) << 8 | int(v * 255);
				case 5: return int(v * 255) << 16 | int(p * 255) << 8 | int(q * 255);
				default: return 0;
			}
			return 0;
		}
		
		/**
		 * Finds the red factor of a color.
		 * @param	color		The color to evaluate.
		 * @return	A uint from 0 to 255.
		 */
		public static function getRed(color:uint):uint
		{
			return color >> 16 & 0xFF;
		}
		
		/**
		 * Finds the green factor of a color.
		 * @param	color		The color to evaluate.
		 * @return	A uint from 0 to 255.
		 */
		public static function getGreen(color:uint):uint
		{
			return color >> 8 & 0xFF;
		}
		
		/**
		 * Finds the blue factor of a color.
		 * @param	color		The color to evaluate.
		 * @return	A uint from 0 to 255.
		 */
		public static function getBlue(color:uint):uint
		{
			return color & 0xFF;
		}
		
		/**
		 * Shuffles the elements in the array.
		 * @param	a		The Object to shuffle (an Array or Vector).
		 */
		public static function shuffle(a:Object):void
		{
			if (a is Array || a is Vector.<*>)
			{
				var i:int = a.length, j:int, t:*;
				while (-- i)
				{
					t = a[i];
					a[i] = a[j = Math.random() * (i + 1)];
					a[j] = t;
				}
			}
		}
		
		/**
		 * Sorts the elements in the array.
		 * @param	object		The Object to sort (an Array or Vector).
		 * @param	ascending	If it should be sorted ascending (true) or descending (false).
		 */
		public static function sort(object:Object, ascending:Boolean = true):void
		{
			if (object is Array || object is Vector.<*>) quicksort(object, 0, object.length - 1, ascending);
		}
		
		/**
		 * Sorts the elements in the array by a property of the element.
		 * @param	object		The Object to sort (an Array or Vector).
		 * @param	property	The numeric property of object's elements to sort by.
		 * @param	ascending	If it should be sorted ascending (true) or descending (false).
		 */
		public static function sortBy(object:Object, property:String, ascending:Boolean = true):void
		{
			if (object is Array || object is Vector.<*>) quicksortBy(object, 0, object.length - 1, ascending, property);
		}
		
		/** @private Quicksorts the array. */ 
		private static function quicksort(a:Object, left:int, right:int, ascending:Boolean):void
		{
			var i:int = left, j:int = right, t:Number,
				p:* = a[Math.round((left + right) * .5)];
			if (ascending)
			{
				while (i <= j)
				{
					while (a[i] < p) i ++;
					while (a[j] > p) j --;
					if (i <= j)
					{
						t = a[i];
						a[i ++] = a[j];
						a[j --] = t;
					}
				}
			}
			else
			{
				while (i <= j)
				{
					while (a[i] > p) i ++;
					while (a[j] < p) j --;
					if (i <= j)
					{
						t = a[i];
						a[i ++] = a[j];
						a[j --] = t;
					}
				}
			}
			if (left < j) quicksort(a, left, j, ascending);
			if (i < right) quicksort(a, i, right, ascending);
		}
		
		/** @private Quicksorts the array by the property. */ 
		private static function quicksortBy(a:Object, left:int, right:int, ascending:Boolean, property:String):void
		{
			var i:int = left, j:int = right, t:Object,
				p:* = a[Math.round((left + right) * .5)][property];
			if (ascending)
			{
				while (i <= j)
				{
					while (a[i][property] < p) i ++;
					while (a[j][property] > p) j --;
					if (i <= j)
					{
						t = a[i];
						a[i ++] = a[j];
						a[j --] = t;
					}
				}
			}
			else
			{
				while (i <= j)
				{
					while (a[i][property] > p) i ++;
					while (a[j][property] < p) j --;
					if (i <= j)
					{
						t = a[i];
						a[i ++] = a[j];
						a[j --] = t;
					}
				}
			}
			if (left < j) quicksortBy(a, left, j, ascending, property);
			if (i < right) quicksortBy(a, i, right, ascending, property);
		}
		
		// World information.
		/** @private */ internal static var _world:SPWorld;
		/** @private */ internal static var _goto:SPWorld;
		
		// Used for rad-to-deg and deg-to-rad conversion.
		/** @private */ public static const DEG:Number = -180 / Math.PI;
		/** @private */ public static const RAD:Number = Math.PI / -180;
		
		// Global Flash objects.
		/** @private */ public static var stage:Stage;
		/** @private */ public static var engine:SPEngine;
		
		
		// Global objects used for rendering, collision, etc.
		/** @private */ public static var point:Point = new Point;
		/** @private */ public static var point2:Point = new Point;
		/** @private */ public static var rect:Rectangle = new Rectangle;
	}
}