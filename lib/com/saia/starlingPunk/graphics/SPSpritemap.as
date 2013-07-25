package com.saia.starlingPunk.graphics
{
	import com.saia.starlingPunk.SP;
	import flash.utils.Dictionary;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.display.MovieClip;
	
	public class SPSpritemap extends Sprite 
	{
		private static var spritemapAnimations:Dictionary = new Dictionary();
		
		private var currentAnimationState:String = "default";
		private var newAnimationState:String;
		
		private var atlas:TextureAtlas;
		
		public var callback:Function;
		
		private var errorTold:Boolean = false;
		
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
		}
		
		private function onFrame(e:Event):void 
		{
			try
			{
				//Switch animations if new animation is chosen
				if (currentAnimationState != newAnimationState)
				{
					removeChild(spritemapAnimations[currentAnimationState]);
					Starling.juggler.remove(spritemapAnimations[currentAnimationState]);
					spritemapAnimations[currentAnimationState].removeEventListener(Event.COMPLETE, onFrameFinish);
					
					currentAnimationState = newAnimationState;
				
					addChild(spritemapAnimations[currentAnimationState]);
					Starling.juggler.add(spritemapAnimations[currentAnimationState]);
					spritemapAnimations[currentAnimationState].addEventListener(Event.COMPLETE, onFrameFinish);
				}
			}
			catch(err:TypeError)
			{
				if (!errorTold)
				{
					trace("WARNING: " + this + " has no animations. Please use .add() to create one");
					errorTold = true;
				}
			}
		}
		
		private function onFrameFinish(e:Event):void 
		{
			if (callback != null) { callback(); }
		}
		
		/**
		 * Adds new animation to the spritemap
		 * @param	name		The name of the animation to call
		 * @param	frameRate	The framerate of the animation
		 * @param	prefix		The prefix used in texture atlas
		 * @param	loop		If the animation loops once complete
		 */
		public function add(name:String, frameRate:Number = 1, prefix:String = "_", loop:Boolean = true):void
		{
			//Only get animation if animation has not already been defined
			if (spritemapAnimations[name] == undefined) 
			{
				//Grab frames of animation from atlas
				var aniFrames:Vector.<Texture> = atlas.getTextures(String("name" + prefix));
				
				spritemapAnimations[name] = new MovieClip(aniFrames, frameRate);
				spritemapAnimations[name].loop = loop;
			}
		}
		
		/**
		 * Adds a frame at the end of the specified animation
		 * @param	name	The name of the animation to insert
		 * @param	texture
		 * @param	duration
		 */
		public function addFrame(name:String, texture:Texture, duration:Number = 0.5):void
		{
			if (spritemapAnimations[name] != undefined) { spritemapAnimations[name].addFrame(texture, null, duration) };
		}
		
		/**
		 * Adds a frame at specified frame in specified animation
		 * @param	name
		 * @param	frame
		 * @param	texture
		 * @param	duration
		 */
		public function addFrameAt(name:String, frame:int, texture:Texture, duration:Number = 0.5):void
		{
			if (spritemapAnimations[name] != undefined) { spritemapAnimations[name].addFrame(frame, texture, null, duration); }
		}
		
		/**
		 * Removes a specified frame in specified animation
		 * @param	name
		 * @param	frame
		 */
		public function removeFrameAt(name:String, frame:int):void
		{
			if (spritemapAnimations[name != undefined) { spritemapAnimations[name].removeFrameAt(frame); }
		}
		
		/**
		 * Plays specified animation.
		 * @param	name	The name of the animation to play
		 */
		public function play(name:String):void
		{
			if (spritemapAnimations[currentAnimationState] != undefined) { newAnimationState = name; }
		}
		
		/**
		 * Stops current animation, resetting it's frame to the first
		 */
		public function stop():void
		{
			spritemapAnimations[currentAnimationState].stop();
		}
		
		/**
		 * Pauses current animation
		 */
		public function pause():void
		{
			spritemapAnimations[currentAnimationState].pause();
		}
		
		/**
		 * Resumes current animation
		 */
		public function resume():void
		{
			spritemapAnimations[currentAnimationState].play();
		}
		
		/**
		 * The current frame ID in the current animation
		 */
		public function get currentFrame():int { return spritemapAnimations[name].currentFrame; }
	}

}