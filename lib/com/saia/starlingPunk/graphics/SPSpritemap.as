package com.saia.starlingPunk.graphics 
{
	import flash.utils.Dictionary;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.display.MovieClip;
	
	public class SPSpritemap extends Sprite 
	{
		[Embed(source = "dummyAtlasXML.png")] private static const dummyImage:Class;
		[Embed(source = "dummyAtlasXML.xml", mimeType = "application/octet-stream")] private static const dummyImageXML:Class;
		
		private static var spritemapAnimations:Dictionary = new Dictionary();
		
		private var currentAnimationState:String = "default";
		private var newAnimationState:String;
		
		private var atlas:TextureAtlas;
		
		public var callback:Function;
		
		private var dummyClip:MovieClip;
		
		/**
		 * Holds & controls multiple movieClips
		 * @param	_atlas		The texture atlas
		 * @param	_callback	Optional callback function
		 */
		public function SPSpritemap(_atlas:TextureAtlas, _callback:Function = null) 
		{
			atlas = _atlas;
			callback = _callback;
			
			this.addEventListener(Event.ENTER_FRAME, onFrame);
			
			//Create a dummy movie clip, the default state if no animations have been added or told to play
			var dummyAtlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new dummyImage()), XML(new dummyImageXML()));
			dummyClip = new MovieClip(dummyAtlas.getTextures("test_"), 1);
			spritemapAnimations["default"] = dummyClip;
			addChild(dummyClip);
			dummyClip.visible = false;
			currentAnimationState = "default";
			
		}
		
		private function onFrame(e:Event):void 
		{
			//Switch animations if new animation is chosen
			if (currentAnimationState != newAnimationState)
			{
				removeChild(spritemapAnimations[currentAnimationState]);
				Starling.juggler.remove(spritemapAnimations[currentAnimationState]);
				
				currentAnimationState = newAnimationState;
				
				addChild(spritemapAnimations[currentAnimationState]);
				Starling.juggler.add(spritemapAnimations[currentAnimationState]);
			}
			
			//At the end of the current frame, call optional function
			if (spritemapAnimations[currentAnimationState].currentFrame == (spritemapAnimations[currentAnimationState].numFrames - 1))
			{
				if (callback != null) { callback(); }
			}
		}
		
		/**
		 * Add a new animation to the spritemap
		 * @param	name		The name of the animation. Use prefix, sans "_"
		 * @param	frameRate	The frame-rate of the animation
		 * @param	loop		If the animation will loop once complete
		 */
		public function add(name:String, frameRate:Number = 1, loop:Boolean = true):void
		{
			//Only get animation if animation has not already been defined
			if (spritemapAnimations[name] == undefined) 
			{
				//Grab frames of animation from atlas
				var aniFrames:Vector.<Texture> = atlas.getTextures(String(name + "_"));
				
				spritemapAnimations[name] = new MovieClip(aniFrames, frameRate);
				spritemapAnimations[name].loop = loop;
			}
		}
		
		/**
		 * Plays specified animation.
		 * @param	name	The name of the animation to play
		 */
		public function play(name:String):void
		{
			if (spritemapAnimations[name] != undefined) { newAnimationState = name; }
		}
	}

}