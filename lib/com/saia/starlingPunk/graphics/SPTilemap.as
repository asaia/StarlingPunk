package com.saia.starlingPunk.graphics 
{
	import com.saia.starlingPunk.SP;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * A canvas to which Tiles can be drawn for fast multiple tile rendering.
	 */
	public class SPTilemap extends Sprite
	{
		
		private var _tileList:Vector.<Texture>;
		private var _width:Number;
		private var _height:Number;
		private var _maxWidth:Number;
		private var _maxHeight:Number;
		
		private var _allTileData:Vector.<Vector.<int>>;
		
		/**
		 * Constructor.
		 * @param	tileset			The source tileset image.
		 * @param	width			Width of the tilemap, in pixels.
		 * @param	height			Height of the tilemap, in pixels.
		 * @param	tileWidth		Tile width.
		 * @param	tileHeight		Tile height.
		 */
		public function SPTilemap(width:uint, height:uint, tileWidth:uint, tileHeight:uint) 
		{
			_tileList = new Vector.<Texture>();
			
			// set some tilemap information
			_width = width - (width % tileWidth) + tileWidth;
			_height = height - (height % tileHeight) + tileHeight;
			_columns = _width / tileWidth;
			_rows = _height / tileHeight;
			
			_tileWidth = tileWidth;
			_tileHeight = tileHeight;
			
			_setColumns = uint(width / tileWidth) + tileWidth;
			_setRows = uint(height / tileHeight) + tileHeight;
			_setCount = _setColumns * _setRows;
			
			// create the canvas
			_maxWidth = _setColumns * tileWidth;
			_maxHeight = _setRows * tileHeight;
			
			_spriteCanvas = new SpriteCanvas(this, _maxWidth, _maxHeight);
			
			
			//init all tile data
			_allTileData = new Vector.<Vector.<int>>(_setColumns, true);
			for (var i:int = 0; i < _setColumns; i++) 
			{
				var _rows:Vector.<int> = new Vector.<int>(_setRows, true);
				for (var j:int = 0; j < _setRows; j++) 
				{
					_rows[j] = -1;
				}
				_allTileData[i] = _rows;
			}
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, removed);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			this.blendMode = BlendMode.NONE;
		}
		
		/**
		 * create list of tiles from bitmap data
		 * @param	bitmapData
		 */
		public function createTilesFromBitmapData(bitmapData:BitmapData):void 
		{	
			var tempData:BitmapData = new BitmapData(tileWidth, tileHeight, true, 0x00000000);
			var numColumns:int = bitmapData.width / tileWidth;
			var numRows:int = bitmapData.height / tileHeight;
			for (var i:int = 0; i < numColumns; i++) 
			{
				for (var j:int = 0; j < numRows; j++) 
				{
					var rect:Rectangle = new Rectangle(j * tileWidth, i * tileHeight, tileWidth, tileHeight);
					var tilePixels:ByteArray = new ByteArray();
					tilePixels = bitmapData.getPixels(rect);
					tilePixels.position = 0;
					tempData.setPixels(tempData.rect, tilePixels);
					
					_tileList.push(Texture.fromBitmapData(tempData));
				}
			}
		}
		
		/**
		 * create list of tiles a texture atlas
		 * @param	texture atlas containing tile images
		 * @param   an array of the tile names found on the texture atlas
		 */
		public function createTilesFromTextureAtlas(data:TextureAtlas, tileNames:Array):void
		{
			var numTiles:int = tileNames.length;
			for (var i:int = 0; i < numTiles; i++) 
			{
				var texture:Texture = data.getTexture(tileNames[i]);
				_tileList.push(texture);
			}
		}
		
		/**
		 * create list of tiles from an vector of images
		 * @param	vector of images 
		 */
		public function createTilesFromVector(tiles:Vector.<Image>):void
		{
			var allTextures:Vector.<Texture> = new Vector.<Texture>();
			for (var i:int = 0; i < tiles.length; i++) 
			{
				var tex:Texture = tiles[i].texture;
				allTextures.push(tex);
			}
			_tileList = allTextures;
		}
		
		/**
		 * Sets the index of the tile at the position.
		 * @param	column		Tile column.
		 * @param	row			Tile row.
		 * @param	index		Tile index.
		 * @param   refress sprite calles that sprite's flatten method after tile is added to it
		 */
		public function setTile(column:uint, row:uint, index:uint = 0, refressSprite:Boolean = false):void
		{
			if (!_tileList.length) 
			{
				throw new Error("You need to call one of the createTiles methods in order to use SPTilemaps");
				return;
			}
			
			var sprite:Sprite = _spriteCanvas.getSpriteTile(column * _tileWidth, row * _tileHeight);
			var image:Image = new Image(_tileList[index]);
			
			image.x = (column * _tileWidth) % SP.width;
			image.y = (row * _tileHeight) % SP.height;
			
			image.blendMode = BlendMode.NONE;
			sprite.addChild(image);
			
			if (refressSprite)
				sprite.flatten();
			
			_allTileData[column][row] = index;
		}
		
		/**
		 * Clears the tile at the position.
		 * @param	column		Tile column.
		 * @param	row			Tile row.
		 * @param   updateAfter Whether or not the sprite should be reflattend after the image is removed
		 * @param   refress sprite calles that sprite's flatten method after tile is added to it
		 */
		public function clearTile(column:uint, row:uint, refressSprite:Boolean = false):void
		{
			var sprite:Sprite = _spriteCanvas.getSpriteTile(column * _tileWidth, row * _tileHeight);
			var imageX:Number = (column * _tileWidth) % SP.width;
			var imageY:Number = (row * _tileHeight) % SP.height;
			
			var image:Image = sprite.hitTest(new Point(imageX, imageY)) as Image;
			image.removeFromParent();
			
			if (refressSprite)
				sprite.flatten();
		}
		
		/**
		 * Gets the tile index at the position.
		 * @param	column		Tile column.
		 * @param	row			Tile row.
		 * @return	The tile index. returns -1 if no tile is there
		 */
		public function getTile(column:int, row:int):int
		{
			return _allTileData[column][row];
		}
		
		/**
		 * Sets a rectangular region of tiles to the index.
		 * @param	column		First tile column.
		 * @param	row			First tile row.
		 * @param	width		Width in tiles.
		 * @param	height		Height in tiles.
		 * @param	index		Tile index.
		 */
		public function setRect(column:uint, row:uint, width:uint = 1, height:uint = 1, index:uint = 0):void
		{
			column %= _columns;
			row %= _rows;
			var c:uint = column,
				r:uint = column + width,
				b:uint = row + height;
			while (row < b)
			{
				while (column < r)
				{
					setTile(column, row, index, false);
					column ++;
				}
				column = c;
				row ++;
			}
			
			_spriteCanvas.flattenSpriteTiles();
		}
		
		/**
		 * Clears the rectangular region of tiles.
		 * @param	column		First tile column.
		 * @param	row			First tile row.
		 * @param	width		Width in tiles.
		 * @param	height		Height in tiles.
		 */
		public function clearRect(column:uint, row:uint, width:uint = 1, height:uint = 1):void
		{
			column %= _columns;
			row %= _rows;
			var c:uint = column,
				r:uint = column + width,
				b:uint = row + height;
			while (row < b)
			{
				while (column < r)
				{
					clearTile(column, row, false);
					column ++;
				}
				column = c;
				row ++;
			}
			
			_spriteCanvas.flattenSpriteTiles();
		}
		
		/**
		* Loads the Tilemap tile index data from a string.
		* @param str			The string data, which is a set of tile values separated by the columnSep and rowSep strings.
		* @param columnSep		The string that separates each tile value on a row, default is ",".
		* @param rowSep			The string that separates each row of tiles, default is "\n".
		*/
		public function loadFromString(str:String, columnSep:String = ",", rowSep:String = "\n"):void
		{
			var row:Array = str.split(rowSep),
				rows:int = row.length,
				col:Array, cols:int, x:int, y:int;
			for (y = 0; y < rows; y ++)
			{
				if (row[y] == '') continue;
				col = row[y].split(columnSep),
				cols = col.length;
				
				for (x = 0; x < cols; x ++)
				{
					if (col[x] == '') continue;
					setTile(x, y, uint(col[x]));
				}

			}
			
			_spriteCanvas.flattenSpriteTiles();
		}
		
		/**
		* Saves the Tilemap tile index data to a string.
		* @param columnSep		The string that separates each tile value on a row, default is ",".
		* @param rowSep			The string that separates each row of tiles, default is "\n".
		*/
		public function saveToString(columnSep:String = ",", rowSep:String = "\n"): String
		{
			var s:String = '',
				x:int, y:int;
			for (y = 0; y < _rows; y ++)
			{
				for (x = 0; x < _columns; x ++)
				{
					var tileIndex:int = getTile(x, y);
					if (tileIndex == -1)
						s += '';
					else
						s += String(tileIndex);
					if (x != _columns - 1) s += columnSep;
				}
				if (y != _rows - 1) s += rowSep;
			}
			
			return s;
		}
		
		/**
		 * Gets the index of a tile, based on its column and row in the tileset.
		 * @param	tilesColumn		Tileset column.
		 * @param	tilesRow		Tileset row.
		 * @return	Index of the tile.
		 */
		public function getIndex(tilesColumn:uint, tilesRow:uint):uint
		{
			return (tilesRow % _setRows) * _setColumns + (tilesColumn % _setColumns);
		}
		
		
		//-------------------
		//  event handlers
		//-------------------
		
		private function onEnterFrame(e:Event):void
		{
			_spriteCanvas.update();
		}
		
		
		private function removed(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removed);
			
			while (_tileList.length)
			{
				var texture:Texture = _tileList[0];
				texture.dispose();
				_tileList.splice(0, 1);
			}
			
			_spriteCanvas.destroy();
			removeChildren(0, -1, true);
			removeFromParent(true);
			_allTileData = null;
			removeEventListeners();
		}
		
		//-------------------
		//  getters and setters
		//-------------------
		
		/**
		 * The tile width.
		 */
		public function get tileWidth():uint { return _tileWidth; }
		
		/**
		 * The tile height.
		 */
		public function get tileHeight():uint { return _tileHeight; }
		
		/**
		 * How many columns the tilemap has.
		 */
		public function get columns():uint { return _columns; }
		
		/**
		 * How many rows the tilemap has.
		 */
		public function get rows():uint { return _rows; }
		
		// Tilemap information.
		/** @private */ private var _columns:uint;
		/** @private */ private var _rows:uint;
		
		// Tileset information.
		/** @private */ private var _setColumns:uint;
		/** @private */ private var _setRows:uint;
		/** @private */ private var _setCount:uint;
		/** @private */ private var _tileWidth:uint;
		/** @private */ private var _tileHeight:uint;
		
		// Global objects.
		/** @private */ private var _rect:Rectangle = SP.rect;
		private var _spriteCanvas:SpriteCanvas;
	}
}