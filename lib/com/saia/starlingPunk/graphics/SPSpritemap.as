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
		public var spritemapAnimations:Dictionary = new Dictionary();
		
		public var currentAnimationState:String = "default";
		public var newAnimationState:String;
		
		private var atlas:TextureAtlas;
		
		public var callback:Function;
		
		private var errorTold:Boolean = false;
		
		private var nonLoopFuncComplete:Boolean = false;
		
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
					
					currentAnimationState = newAnimationState;
				
					addChild(spritemapAnimations[currentAnimationState]);
					Starling.juggler.add(spritemapAnimations[currentAnimationState]);
					
					nonLoopFuncComplete = false;
				}
				
				if (spritemapAnimations[currentAnimationState].currentFrame == spritemapAnimations[currentAnimationState].numFrames - 1)
				{
					if (spritemapAnimations[currentAnimationState].loop == false)
					{
						if (!nonLoopFuncComplete)
						{
							if (callback != null) { callback(); }
							nonLoopFuncComplete = true;
						}
					}
					else 
					{
						if (callback != null) { callback(); }
					}
					
				}
			}
			catch(err:TypeError)
			{
				if (!errorTold)
				{
					trace("WARNING: " + this + " has no animations, or none are playing. Please use .add() to create one & .play() to play an animation");
					errorTold = true;
				}
			}
		}
		
		/**
		 * Adds new animation to the spritemap
		 * @param	name		The name of the animation to call
		 * @param	frameRate	The framerate of the animation
		 * @param	prefix		The prefix used in texture atlas
		 * @param	loop		If the animation loops once complete
		 */
		public function add(name:String, _aniFrames:Vector.<Texture>, frameRate:Number = 1, loop:Boolean = true):void
		{
			//Only get animation if animation has not already been defined
			if (spritemapAnimations[name] == undefined) 
			{
				//Grab frames of animation from atlas
				var aniFrames:Vector.<Texture> = _aniFrames;
				
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
			if (spritemapAnimations[name] != undefined) { spritemapAnimations[name].removeFrameAt(frame); }
		}
		
		/**
		 * Plays specified animation.
		 * @param	name	The name of the animation to play
		 */
		public function play(name:String):void
		{
			if (spritemapAnimations[name] != undefined) { newAnimationState = name; }
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