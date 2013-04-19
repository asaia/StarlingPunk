package com.saia.starlingPunk.helpers
{
	import com.saia.starlingPunk.SP;
	import starling.display.DisplayObject;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Andy Saia
	 */
	public class Alignment 
	{
		//centers only the image's x axis to the level
		public static function alignXCenterLevel(image:DisplayObject):Number
		{
			image.x = SP.halfWidth - image.width / 2;
			return image.x;
		}
		
		//centers only the image's y axis to the level
		public static function alignYCenterLevel(image:DisplayObject):Number
		{
			image.y = SP.halfHeight - image.height / 2;
			return image.y;
		}
		
		//centers image to the center of the level
		public static function centerToLevel(image:DisplayObject):void
		{
			alignXCenterLevel(image);
			alignYCenterLevel(image);
		}

		//centers only the image's x axis to given rectangle
		public static function alignXCenterRect(image:DisplayObject, rect:Rectangle):Number
		{
			image.x = (rect.width / 2 - image.width / 2) + rect.x;
			return image.x;
		}
		
		//centers only the image's y axis to given rectangle
		public static function alignYCenterRect(image:DisplayObject, rect:Rectangle):Number
		{
			image.y = (rect.height / 2 - image.height / 2) + rect.y;
			return image.y;
		}
		
		//centers image inside given rectangle
		public static function centerAlignToRect(image:DisplayObject, rect:Rectangle):void
		{
			alignXCenterRect(image, rect);
			alignYCenterRect(image, rect);
		}
		
		//distributes objects of the same width and height evently along the x axis
		public static function distributeHorzontalObjects(allObject:Vector.<DisplayObject>, rect:Rectangle, boarder:Number = 0):Number
		{
			var totalObjectWidth:Number = 0;
			
			var numObjects:int = allObject.length;
			for (var i:int = 0; i < numObjects; i++) 
			{
				var obj:DisplayObject = allObject[i];
				totalObjectWidth += obj.width;
			}
			
			if (totalObjectWidth > (rect.width))
				trace("WARNING: the total object width is greater than the width of " + rect.width);
			
			var padding:Number = ((rect.width) - (totalObjectWidth) - (boarder * 2)) / (numObjects - 1);
			var xPos:Number = boarder + rect.x;
			var yPos:Number = (rect.height / 2 - obj.height / 2) + rect.y;
			
			for (var j:int = 0; j < numObjects; j++) 
			{
				obj = allObject[j];
				obj.x = xPos;
				obj.y = yPos;
				xPos += padding + obj.width;
			}
			
			return padding;
		}
		
		//distributes objects of the same width and height evently along the y axis
		public static function distributeVerticalObjects(allObject:Vector.<DisplayObject>, rect:Rectangle, boarder:Number = 0):Number
		{
			var totalObjectHeight:Number = 0;
			
			var numObjects:int = allObject.length;
			for (var i:int = 0; i < numObjects; i++) 
			{
				var obj:DisplayObject = allObject[i];
				totalObjectHeight += obj.height;
			}
			
			if (totalObjectHeight > (rect.height))
				trace("WARNING: the total object height is greater than the height of " + rect.width);
			
			var padding:Number = ((rect.height) - (totalObjectHeight) - (boarder * 2)) / (numObjects - 1);
			var yPos:Number = boarder + rect.y;
			var xPos:Number = (rect.width / 2 - obj.width / 2) + rect.x;
			
			for (var j:int = 0; j < numObjects; j++) 
			{
				obj = allObject[j];
				obj.x = xPos;
				obj.y = yPos;
				yPos += padding + obj.height;
			}
			
			return padding;
		}
		
		/**
		 * scales image to fit inside rectange
		 * @param	image
		 * @param	rect 
		 * @param	boarder
		 * @param	maintainAspectRatio boolean whether or not the aspect ratio should be effected by the scale
		 */
		public static function scaleToRect(image:DisplayObject, rect:Rectangle, boarder:Number = 0, maintainAspectRatio:Boolean = true):void
		{
			image.scaleX = 1;
			image.scaleY = 1;
			var newRect:Rectangle = new Rectangle(rect.x + boarder, rect.y + boarder, rect.width - boarder * 2, rect.height - boarder * 2);
			var scaleX:Number = newRect.width / (image.width );
			var scaleY:Number =  newRect.height / (image.height);
			
			var scaleFactor:Number;
			
			if (maintainAspectRatio)
			{
				if (scaleX < scaleY)
					scaleFactor = scaleX;
				else
					scaleFactor = scaleY;
			
				image.scaleX = scaleFactor;
				image.scaleY = scaleFactor;
					
				if (scaleFactor == scaleX)
				{
					Alignment.alignXCenterRect(image, newRect);
					image.y = rect.y + boarder;
				}
				else
				{
					Alignment.alignYCenterRect(image, newRect);
					image.x = rect.x + boarder;
				}
			}
			else
			{
				image.scaleX = scaleX;
				image.scaleY = scaleY;
				Alignment.centerAlignToRect(image, newRect);
			}
		}
		
		public static function scaleToGameSize(image:DisplayObject, maintainAspectRatio:Boolean = true):void
		{
			var rect:Rectangle = new Rectangle(0, 0, SP.width, SP.height);
			scaleToRect(image, rect, 0, maintainAspectRatio);
		}
		
		public static function getRectangleFromDisplayObject(image:DisplayObject):Rectangle
		{
			var rect:Rectangle = new Rectangle(image.x, image.y, image.width, image.height);
			return rect;
		}
	
		
		//TODO: this is hackey find a better way
		public static function scaleFlashObjectToRect(image:*, rect:Rectangle, boarder:Number = 0, maintainAspectRatio:Boolean = true):void
		{
			image.scaleX = 1;
			image.scaleY = 1;
			var newRect:Rectangle = new Rectangle(rect.x + boarder, rect.y + boarder, rect.width - boarder * 2, rect.height - boarder * 2);
			var scaleX:Number = newRect.width / (image.width );
			var scaleY:Number =  newRect.height / (image.height);
			
			var scaleFactor:Number;
			
			if (maintainAspectRatio)
			{
				if (scaleX < scaleY)
					scaleFactor = scaleX;
				else
					scaleFactor = scaleY;
			
				image.scaleX = scaleFactor;
				image.scaleY = scaleFactor;
					
				if (scaleFactor == scaleX)
				{
					Alignment.alignXCenterRect(image, newRect);
					image.y = rect.y + boarder;
				}
				else
				{
					Alignment.alignYCenterRect(image, newRect);
					image.x = rect.x + boarder;
				}
			}
			else
			{
				image.scaleX = scaleX;
				image.scaleY = scaleY;
				//Alignment.centerAlignToRect(image, newRect);
			}
		}
		
		public static function scaleFlashObjectToGameSize(image:*, maintainAspectRatio:Boolean = true):void
		{
			var rect:Rectangle = new Rectangle(0, 0, SP.width, SP.height);
			scaleFlashObjectToRect(image, rect, 0, maintainAspectRatio);
		}
	}
	
}