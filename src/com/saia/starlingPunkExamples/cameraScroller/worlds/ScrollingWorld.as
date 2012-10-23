package com.saia.starlingPunkExamples.cameraScroller.worlds
{
	import com.saia.starlingPunk.extensions.ogmopunk.OgmoProject;
	import com.saia.starlingPunk.graphics.SPTilemap;
	import com.saia.starlingPunk.SP;
	import com.saia.starlingPunk.SPEntity;
	import com.saia.starlingPunk.SPWorld;
	import com.saia.starlingPunkExamples.embeds.ExampleAssets;
	import com.saia.starlingPunkExamples.helpers.ExampleManager;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	
	
	/**
	 * ...
	 * @author Andy Saia
	 */
	public class ScrollingWorld extends SPWorld
	{
		private var _camXOffset:Number;
		private var _camYOffset:Number;
		private var _camSpeed:Number = 20;
		private var _mouseX:Number = 0;
		private var _mouseY:Number = 0;
		private var _tilemap:SPTilemap;
		
		public function ScrollingWorld()
		{
		}
		
		//-------------------
		//  overrides
		//-------------------
		
		override public function begin():void
		{
			super.begin();
			
			_camXOffset = 0;
			_camYOffset = 0;
			
			//load the embedded project file
			OgmoProject.LoadProject(ExampleAssets.OGMO_SCROLLING_PROJECT, this as Class);
			var textureAtlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new ExampleAssets.ATLAS_TEXTURE()), XML(new ExampleAssets.ATLAS_DATA()));
			//before loading the level you must tell OgmoPunk which images to use for the tileset
			OgmoProject.createTileSetListFromTextureAtlas("groundTileSet", textureAtlas, ["platformTile", "marioTile"]);
			
			loadLevel(ExampleAssets.SCROLLING_LEVEL);
			
			SP.stage.addEventListener(TouchEvent.TOUCH, onTouch);
			
			//display example instructions
			ExampleManager.displayText();
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if (touch)
			{
				_mouseX = touch.globalX;
				_mouseY = touch.globalY;
				_camXOffset = (touch.globalX - SP.halfWidth) / SP.halfWidth;
				_camYOffset = (touch.globalY - SP.halfHeight) / SP.halfHeight;
			}
		
		}
		
		override public function update():void
		{
			super.update();
			checkCameraBounds();
			
			//update example manager
			ExampleManager.checkExampleChange();
		}
		
		override public function remove(entity:SPEntity):void
		{
			super.remove(entity);
		}
		
		//-------------------
		//  private methods
		//-------------------
		
		private function loadLevel(levelData:Class):void
		{
			var levelLayers:Vector.<SPEntity> = OgmoProject.LoadLevel(levelData);
			for each (var entity:SPEntity in levelLayers)
			{
				add(entity);
				_tilemap = SPTilemap(entity.getChildAt(0));
			}
		}
		
		private function checkCameraBounds():void
		{
			var viewPort:Rectangle = SP.camera.viewPort;
			if (viewPort.x + _camXOffset * _camSpeed < 0)
				SP.camera.x = 0;
			else
				SP.camera.x += _camXOffset * _camSpeed;
				
			if (viewPort.y + _camYOffset * _camSpeed < 0)
				SP.camera.y = 0;
			else
				SP.camera.y += _camYOffset * _camSpeed;
				
			if (viewPort.x + _camXOffset * _camSpeed > 5000 - viewPort.width)
				SP.camera.x = 5000 - viewPort.width;
				
			if (viewPort.y + _camYOffset * _camSpeed > 5000 - viewPort.height)
				SP.camera.y = 5000 - viewPort.height;
			
			var focus:Point = SP.camera.container.globalToLocal(new Point(_mouseX, _mouseY));
			SP.camera.focus(focus.x, focus.y);
		}
	}
}