package com.saia.starlingPunk.graphics 
{
	import com.saia.starlingPunk.SP;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * A canvas to which Tiles can be drawn for fast multiple tile rendering.
	 */
	public class Tilemap extends Image
	{
		
		private var _tileList:Vector.<Image>;
		private var _width:Number;
		private var _height:Number;
		private var _maxWidth:Number;
		private var _maxHeight:Number;
		private var _renderTexture:RenderTexture;
		
		private var _allTileData:Vector.<Vector.<int>>;
		
		/**
		 * Constructor.
		 * @param	tileset			The source tileset image.
		 * @param	width			Width of the tilemap, in pixels.
		 * @param	height			Height of the tilemap, in pixels.
		 * @param	tileWidth		Tile width.
		 * @param	tileHeight		Tile height.
		 */
		public function Tilemap(width:uint, height:uint, tileWidth:uint, tileHeight:uint) 
		{
			_tileList = new Vector.<Image>();
			
			// set some tilemap information
			_width = width - (width % tileWidth) + tileWidth;
			_height = height - (height % tileHeight) + tileHeight;
			_columns = _width / tileWidth;
			_rows = _height / tileHeight;
			_tile = new Rectangle(0, 0, tileWidth, tileHeight);
			
			// create the canvas
			_maxWidth -= _maxWidth % tileWidth;
			_maxHeight -= _maxHeight % tileHeight;
			
			_renderTexture = new RenderTexture(_width + tileWidth, _height + tileHeight);
			super(_renderTexture);
			
			_setColumns = uint(width / tileWidth) + tileWidth;
			_setRows = uint(height / tileHeight) + tileHeight;
			_setCount = _setColumns * _setRows;
			
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
			Starling.current.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
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
					var tileImage:Image = new Image(Texture.fromBitmapData(tempData));
					_tileList.push(tileImage);
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
				var image:Image = new Image(texture);
				_tileList.push(image);
			}
		}
		
		/**
		 * create list of tiles from an vector of images
		 * @param	vector of images 
		 */
		public function createTilesFromVector(tiles:Vector.<Image>):void
		{
			_tileList = tiles;
		}
		
		/**
		 * Sets the index of the tile at the position.
		 * @param	column		Tile column.
		 * @param	row			Tile row.
		 * @param	index		Tile index.
		 */
		public function setTile(column:uint, row:uint, index:uint = 0):void
		{
			if (!_tileList.length) 
			{
				trace("ERROR: you need to call a createTiles method first");
				return;
			}
			
			var image:Image = _tileList[index];
			image.x = column * _tile.width;
			image.y = row * _tile.height;
			_renderTexture.draw(image);
			
			_allTileData[column][row] = index;
		}
		
		/**
		 * Clears the tile at the position.
		 * @param	column		Tile column.
		 * @param	row			Tile row.
		 */
		public function clearTile(column:uint, row:uint):void
		{
			var image:Image = _tileList[0];
			image.blendMode = BlendMode.ERASE;
			image.x = column * _tile.width;
			image.y = row * _tile.height;
			_renderTexture.draw(image);
			image.blendMode = BlendMode.NORMAL;
			
			_allTileData[column][row] = -1;
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
				_renderTexture.drawBundled(function():void
				{
					while (column < r)
					{
						
						setTile(column, row, index);
						column ++;
					}
				});
				column = c;
				row ++;
			}
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
				_renderTexture.drawBundled(function():void
				{
					while (column < r)
					{
						clearTile(column, row);
						column ++;
					}
					column = c;
					row ++;
				});
			}
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
				
				_renderTexture.drawBundled(function():void
				{
					for (x = 0; x < cols; x ++)
					{
						if (col[x] == '') continue;
						setTile(x, y, uint(col[x]));
					}
				});
			}
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
		
		private function removed(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removed);
			_renderTexture.dispose();
			while (_tileList.length)
			{
				var img:Image = _tileList[0];
				img.dispose();
				_tileList.splice(0, 1);
			}
			
			removeFromParent(true);
			_allTileData = null;
			removeEventListeners();
		}
		
		/**
		 * this reloads the render texture if the device context is lost
		 */
		private function onContextCreated(e:Event):void 
		{
			var str:String = saveToString();
			loadFromString(str);
		}
		
		//-------------------
		//  getters and setters
		//-------------------
		
		/**
		 * The tile width.
		 */
		public function get tileWidth():uint { return _tile.width; }
		
		/**
		 * The tile height.
		 */
		public function get tileHeight():uint { return _tile.height; }
		
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
		/** @private */ private var _tile:Rectangle;
		
		// Global objects.
		/** @private */ private var _rect:Rectangle = SP.rect;
	}
}