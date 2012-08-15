package com.saia.starlingPunk.extensions.ogmopunk
{
	import com.saia.starlingPunk.extensions.ogmopunk.layers.EntityLayer;
	import com.saia.starlingPunk.extensions.ogmopunk.layers.GridLayer;
	import com.saia.starlingPunk.extensions.ogmopunk.layers.TileLayer;
	import com.saia.starlingPunk.SPEntity;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author Erin M Gunn
	 */
	public class OgmoProject 
	{
		private static var mProjectName:String;
		public static function get projName():String
		{
			return mProjectName;
		}
		
		private static var mProjectFilePath:String;
		public static function get projectFilePath():String
		{
			return mProjectFilePath;
		}
		
		private static var mAngleMode:String;
		public static function get angleMode():String
		{
			return mAngleMode;
		}
		
		private static var mLevelDefaultSize:Point;
		public static function get levelDefaultSize():Point
		{
			return mLevelDefaultSize;
		}
		
		private static var mLayers:Vector.<OgmoLayer>;
		public static function get layers():Vector.<OgmoLayer>
		{
			return mLayers;
		}
		
		private static var mTileSets:Array;
		public static function get tileSets():Array
		{
			return mTileSets;
		}
		
		private static var mEntities:Array;
		public static function get entities():Array
		{
			return mEntities;
		}
		
		private static var mLevelDims:Point;
		public static function get levelDims():Point
		{
			return mLevelDims;
		}
		
		private static var mTileSetImages:Dictionary;
		public static function get tileSetImages():Dictionary
		{
			return mTileSetImages;
		}
		
		internal static var mEventQueue:uint;
		public static function get projectLoaded():Boolean
		{
			return mEventQueue == 0;
		}
		
		/**
		 * creates an image vector for each tileset, this method must be called before a level is loaded
		 * @param	the tilesset name as it appears in the Ogmo editor
		 * @param	the texture atlas containing the images
		 * @param	an array of tile names found on the texture atlas
		 */
		public static function createTileSetListFromTextureAtlas(tileSetName:String, data:TextureAtlas, tileNames:Array):void
		{
			var tileList:Vector.<Image> = new Vector.<Image>();
			var numTiles:int = tileNames.length;
			for (var i:int = 0; i < numTiles; i++) 
			{
				var texture:Texture = data.getTexture(tileNames[i]);
				var image:Image = new Image(texture);
				tileList.push(image);
			}
			
			mTileSetImages = new Dictionary();
			mTileSetImages[tileSetName] = tileList;
		}
		
		/**
		 * creates an image vector for each tileset, this method must be called before a level is loaded
		 * @param	the tilesset name as it appears in the Ogmo editor
		 * @param	bitmapData
		 */
		public function createTilesFromBitmapData(tileSetName:String, bitmapData:BitmapData, tileWidth:Number, tileHeight:Number):void 
		{	
			var tileList:Vector.<Image> = new Vector.<Image>();
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
					tileList.push(tileImage);
				}
			}
			
			mTileSetImages = new Dictionary();
			mTileSetImages[tileSetName] = tileList;
		}
		
		public static function getTileSet(tileSetName:String):Vector.<Image>
		{
			return mTileSetImages[tileSetName];
		}
		
		public static function LoadProject(projectFile:Object, tileSetsContainer:Object=null):void
		{
			mEventQueue = 0;
			
			var dataString:String;
			var xmlData:XML;
			if (projectFile is XML)
			{
				xmlData = projectFile as XML;
			}
			else if (projectFile is ByteArray)
			{
				dataString = (projectFile as ByteArray).readUTFBytes((projectFile as ByteArray).length);
				xmlData = new XML(dataString);
			}
			else
			{
				var projectData:ByteArray = new projectFile;
				dataString = projectData.readUTFBytes(projectData.length);
				xmlData = new XML(dataString);
			}
			
			var dataList:XMLList;
			var dataElement:XML;
			var obj:Object;
			
			// Load the project settings
			mProjectName = xmlData.Name;
			mAngleMode = xmlData.AngleMode
			mProjectFilePath = xmlData.Filename;
			mLevelDefaultSize = new Point(xmlData.LevelDefaultSize.Width, xmlData.LevelDefaultSize.Height);
			
			// TODO: Load the Layer Values
			
			// Load the project layers.
			mLayers = new Vector.<OgmoLayer>();
			for each(dataElement in xmlData.LayerDefinitions.children())
			{
				obj = dataElement.attributes()[0];
				if (obj.toString() == "TileLayerDefinition")
				{
					var tLayer:TileLayer = new TileLayer();
					tLayer.mData = dataElement;
					tLayer.mName = dataElement.Name;
					tLayer.mGrid = new Point(dataElement.Grid.Width, dataElement.Grid.Height);
					tLayer.mScrollFator = new Point(dataElement.ScrollFactor.X, dataElement.ScrollFactor.Y);
					tLayer.mExportMode = dataElement.ExportMode;
					mLayers.push(tLayer);
				}
				else if (obj.toString() == "GridLayerDefinition")
				{
					var gLayer:GridLayer = new GridLayer();
					gLayer.mData = dataElement;
					gLayer.mName = dataElement.Name;
					gLayer.mGrid = new Point(dataElement.Grid.Width, dataElement.Grid.Height);
					gLayer.mScrollFator = new Point(dataElement.ScrollFactor.X, dataElement.ScrollFactor.Y);
					gLayer.mExportMode = dataElement.ExportMode;
					mLayers.push(gLayer);
				}
				else if (obj.toString() == "EntityLayerDefinition")
				{
					var eLayer:EntityLayer = new EntityLayer();
					eLayer.mData = dataElement;
					eLayer.mName = dataElement.Name;
					eLayer.mGrid = new Point(dataElement.Grid.Width, dataElement.Grid.Height);
					eLayer.mScrollFator = new Point(dataElement.ScrollFactor.X, dataElement.ScrollFactor.Y);
					mLayers.push(eLayer);
				}
			}
			mLayers.fixed = true;
			
			// Load the TileSets
			if (tileSetsContainer == null)
			{
				tileSetsContainer = new Object();
			}
			mTileSets = new Array();
			for each(dataElement in xmlData.Tilesets.children())
			{
				var t:OgmoTileSet = OgmoTileSet.LoadTileset(dataElement, tileSetsContainer);
				mTileSets[t.mName] = t;
			}
			
			// Load the project entities.
			mEntities = new Array
			for each(dataElement in xmlData.EntityDefinitions.children())
			{
				// TODO: Refactor to internal vars...
				var e:OgmoEntityDefinition = new OgmoEntityDefinition();
				e.name = dataElement.@Name;
				e.className = dataElement.ValueDefinitions.children()[0].@Default;
				e.limit = dataElement.@Limit;
				e.resizableX =  dataElement.@ResizableX == "true";
				e.resizableY = dataElement.@ResizableY == "true";
				e.rotatable = dataElement.@Rotatable == "true";
				e.size = new Point(dataElement.Size.Width, dataElement.Size.Height);
				e.origin = new Point(dataElement.Origin.X, dataElement.Origin.Y);
				e.imageDef = new ImageDefinition();
				e.imageDef.drawMode = dataElement.ImageDefinition.@DrawMode;
				e.imageDef.imagePath = dataElement.ImageDefinition.@ImagePath;
				e.imageDef.tiled = dataElement.ImageDefinition.@Tiled;
				// TODO: Implement image definition color loading.
				// e.imageDef.color
				// TODO: Implement Value Definitions.
				e.values = new Vector.<OgmoValue>();
				var value:OgmoValue;
				for each( var dte:XML in dataElement.ValueDefinitions.children())
				{
					value = new OgmoValue();
					e.values.push(value);
					value.mName = dte.@Name;
					obj = dte.attributes()[0];
					switch(obj.toString())
					{
						case "IntegerValueDefinition":
							value.mType = int;
							break;
						case "FloatValueDefinition":
							value.mType = Number;
							break;
						case "BoolValueDefinition":
							value.mType = Boolean;
							break;
						case "ColorValueDefinition":
							value.mType = uint;
							break;
						case "StringValueDefinition":
						case "EnumValueDefinition":
						default:
							value.mType = String;
					}
					if (value.mValue == null)
					{
						value.mValue = dte.@Default.toString() as value.mType;
					}
				}
				// TODO: Implement Nodes Definitions.
				
				mEntities[e.name] = e;
			}
			mEntities.fixed = true;
		}
		
		public static function LoadLevel(levelFile:Object):Vector.<SPEntity>
		{
			var entities:Vector.<SPEntity> = new Vector.<SPEntity>();
			
			var dataString:String;
			
			if (levelFile is Class)
			{
				var levelData:ByteArray = new levelFile;
				dataString = levelData.readUTFBytes(levelData.length);
			}
			var xmlData:XML = new XML(dataString);
			
			mLevelDims = new Point(xmlData.attribute("width"), xmlData.attribute("height"));
			if (mLevelDims.length == 0)
			{
				mLevelDims = mLevelDefaultSize;
			}
			
			
			var layer:OgmoLayer;
			var e:SPEntity;
			var eToAdd:Vector.<SPEntity>;
			for (var i:uint = 0; i < mLayers.length; i++)
			{
				layer = mLayers[i];
				if (xmlData.child(layer.name).toString() == "")
				{
					layer.mData = null;
					continue;
				}
				layer.mData = new XML(xmlData.child(layer.name));
				eToAdd = layer.loadData();
				
				
				for each(e in eToAdd)
				{
					e.layer = mLayers.length - i;
					entities.push(e);
				}
			}
			
			return entities;
		}
		
	}

} 