package com.saia.starlingPunk.helpers 
{
	/**
	 * ...
	 * @author Andy Saia
	 */
	public class ColorUtils 
	{
		public static function RGBToHex(r:uint, g:uint, b:uint):uint
		{
			var hex:uint = (r << 16 | g << 8 | b);
			return hex;
		}
		 
		public static function HexToRGB(hex:uint):Vector.<int>
		{
			var rgb:Vector.<int> = new Vector.<int>();
			 
			var r:uint = hex >> 16 & 0xFF;
			var g:uint = hex >> 8 & 0xFF;
			var b:uint = hex & 0xFF;
			 
			rgb.push(r, g, b);
			return rgb;
		}
		
		public static function HexToDeci(hex:String):uint
		{
			if (hex.substr(0, 2) != "0x") 
			{
				hex = "0x" + hex;
			}
			return new uint(hex);
		}
		
		public static function hexToHsv(color:uint):Vector.<int>
		{
			var colors:Vector.<int> = HexToRGB(color);
			return RGBtoHSV(colors[0], colors[1], colors[2]);
		}
		
		public static function hsvToHex(h:Number, s:Number, v:Number):uint
		{
			var colors:Vector.<int> = HSVtoRGB(h, s, v);
			return RGBToHex(colors[0], colors[1], colors[2]);
		}
		
		/**
		 * Converts Red, Green, Blue to Hue, Saturation, Value
		 * @r channel between 0-255
		 * @s channel between 0-255
		 * @v channel between 0-255
		 */
		public static function RGBtoHSV(r:uint, g:uint, b:uint):Vector.<int>
		{
			var max:uint = Math.max(r, g, b);
			var min:uint = Math.min(r, g, b);
			 
			var hue:Number = 0;
			var saturation:Number = 0;
			var value:Number = 0;
			 
			var hsv:Vector.<int> = new Vector.<int>();
			 
			//get Hue
			if (max == min)
				hue = 0;
			else if (max == r)
				hue = (60 * (g-b) / (max-min) + 360) % 360;
			else if (max == g)
				hue = (60 * (b-r) / (max-min) + 120);
			else if (max == b)
				hue = (60 * (r-g) / (max-min) + 240);
			 
			//get Value
			value = max;
			 
			//get Saturation
			if(max == 0)
				saturation = 0;
			else
				saturation = (max - min) / max;
			 
			hsv = Vector.<int>([Math.round(hue), Math.round(saturation * 100), Math.round(value / 255 * 100)]);
			return hsv;
		}
		
		
		/**
		 * Converts Hue, Saturation, Value to Red, Green, Blue
		 * @h Angle between 0-360
		 * @s percent between 0-100
		 * @v percent between 0-100
		 */
		public static function HSVtoRGB(h:Number, s:Number, v:Number):Vector.<int>
		{
			var r:Number = 0;
			var g:Number = 0;
			var b:Number = 0;
			var rgb:Vector.<int> = new Vector.<int>();
			 
			var tempS:Number = s / 100;
			var tempV:Number = v / 100;
			 
			var hi:int = Math.floor(h/60) % 6;
			var f:Number = h/60 - Math.floor(h/60);
			var p:Number = (tempV * (1 - tempS));
			var q:Number = (tempV * (1 - f * tempS));
			var t:Number = (tempV * (1 - (1 - f) * tempS));
			 
			switch(hi)
			{
				case 0: r = tempV; g = t; b = p; break;
				case 1: r = q; g = tempV; b = p; break;
				case 2: r = p; g = tempV; b = t; break;
				case 3: r = p; g = q; b = tempV; break;
				case 4: r = t; g = p; b = tempV; break;
				case 5: r = tempV; g = p; b = q; break;
			}
			 
			rgb = Vector.<int>([Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)]);
			return rgb;
		}
		
	}

}