package com.saia.starlingPunk.graphics 
{
	import com.saia.starlingPunk.SP;
	import flash.geom.Rectangle;
	import starling.display.BlendMode;
	import starling.display.Sprite;

	/**
	 * This class is used interally for StarlingPunk's Tilemap system. Its optimized for displaying thousands of images by only rendering what's visible by the camera
	 * @author Andy Saia
	 */
	public class SpriteCanvas
	{
		private var _width:Number;
		private var _height:Number;
		private var _numColumns:int;
		private var _numRows:int;

		private var _spriteColumns:Vector.<Vector.<Sprite>>;
		private var _refreshFlag:Boolean;
		private var _spriteRect:Rectangle;
		private var _rect:Rectangle;
		private var _viewPadding:int = 20;
		private var _container:Sprite;
		
		public function SpriteCanvas(container:Sprite, width:Number, height:Number) 
		{
			_container = container;
			_width = width;
			_height = height;
			
			_numColumns = Math.ceil(_width / SP.width);
			_numRows = Math.ceil(_height / SP.height);
			_spriteRect = new Rectangle(0, 0, SP.width, SP.height);
			_rect = new Rectangle();
			
			populateSpriteArray();
		}
		
		//-------------------
		//  public methods
		//-------------------
		
		/**
		 * returns the sprite object at the given column and row index
		 * @param	column
		 * @param	row
		 * @return
		 */
		public function getSpriteTile(column:int, row:int):Sprite
		{
			var columnIndex:int = Math.floor(column / SP.width);
			var rowIndex:int =  Math.floor(row / SP.height);
			var sprite:Sprite = _spriteColumns[columnIndex][rowIndex];
			sprite.x = columnIndex * SP.width;
			sprite.y = rowIndex * SP.height;
			sprite.blendMode = BlendMode.NONE;
			
			return sprite;
		}
		
		/**
		 * flattens all the sprite tiles in order to batch their rendering
		 */
		public function flattenSpriteTiles():void
		{
			for (var x:int = 0; x < _numColumns; x++)
			{
				for (var y:int = 0; y < _numRows; y++) 
				{
					if (x != 0 || y != 0)
					{
						_spriteColumns[x][y].flatten();
					}
				}
			}
		}
		
		/**
		 * called internally by SPTilemap, checks if each tile is visible by the game camera
		 */
		public function update():void
		{	
			checkSpriteVisibilites();
			
			//this drastically reduces the number of draw calls but there is a pretty serious delay when it reflattens the container sprite
			//hopefully future versions will further optimise this
			/*
			if (_refreshFlag)
			{
				_container.flatten();
				_refreshFlag = false;
			}
			*/
		}
		
		/**
		 * remove all sprites and dispose of everything for garbage collector
		 */
		public function destroy():void 
		{
			for (var x:int = 0; x < _numColumns; x++)
			{
				for (var y:int = 0; y < _numRows; y++) 
				{
					if (x != 0 || y != 0)
					{
						var sprite:Sprite = _spriteColumns[x][y];
						sprite.removeFromParent(true);
					}
				}
			}
			_spriteColumns = null;
		}
		
		//---------------
		//  private methods
		//---------------
		
		private function populateSpriteArray():void
		{
			_refreshFlag = false;
			
			_spriteColumns = new Vector.<Vector.<Sprite>>([_numColumns]);
			for (var x:int = 0; x < _numColumns; x++) 
			{
				var spriteRows:Vector.<Sprite> = new Vector.<Sprite>([_numRows]);
				for (var y:int = 0; y < _numRows; y++) 
				{
					spriteRows[y] = new Sprite();
				}
				_spriteColumns[x] = spriteRows;
			}
		}
		
		private function checkSpriteVisibilites():void
		{	
			//the collision rectangle gets offset in case where scrolling quickly
			var viewPort:Rectangle = SP.camera.viewPort;
			_rect.width = viewPort.width + _viewPadding;
			_rect.height = viewPort.height + _viewPadding;
			_rect.x = viewPort.x - _viewPadding;
			_rect.y = viewPort.y - _viewPadding;
			
			var activeTileX:int = Math.floor(viewPort.x / SP.width);
			var activeTileY:int = Math.floor(viewPort.y / SP.height);
			if (activeTileX - 1 >= 0)
				activeTileX -= 1; 
			else 
				activeTileX = 0;
			
			if (activeTileY - 1 >= 0)
				activeTileY -= 1; 
			else 
				activeTileY = 0;
			
			for (var x:int = activeTileX; x < activeTileX + 3; x++)
			{	
				if (x >= _numColumns) return;
				for (var y:int = activeTileY; y < activeTileY + 3; y++) 
				{
					if (y >= _numRows) return;
					var sprite:Sprite = _spriteColumns[x][y];
					
					_spriteRect.x = x * SP.width;
					_spriteRect.y = y * SP.height;
					if (_rect.intersects(_spriteRect))
					{
						if (!sprite.parent)
						{
							_container.addChild(sprite);
							_refreshFlag = true;
						}
					}
					else if (sprite.parent)
					{
						sprite.removeFromParent();
						_refreshFlag = true;
					}
				}
			}
		}
	}
}