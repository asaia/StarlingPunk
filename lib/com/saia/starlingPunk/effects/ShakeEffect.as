package com.saia.starlingPunk.effects 
{
	import com.saia.starlingPunk.SP;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import starling.events.Event;
	/**
	 * Shake effect class randomizes the position of the world for a given duration
	 * @author Andy Saia
	 */
	public class ShakeEffect 
	{
		private var _intensity:Number;
		private var _duration:Number;
		private var _isShakeing:Boolean;
		
		private var _startPos:Point;
		public function ShakeEffect(intensity:Number = 10, duration:Number = 1000) 
		{
			_duration = duration;
			_intensity = intensity;
			
			_startPos = new Point(SP.world.x, SP.world.y);
			_isShakeing = false;
		}
		
		//----------
		//  getters and setters
		//----------
		
		public function get intensity():Number 
		{
			return _intensity;
		}
		
		public function get duration():Number 
		{
			return _duration;
		}
		
		/**
		 * Amount of random variation
		 */
		public function set intensity(value:Number):void 
		{
			_intensity = value;
		}
		
		/**
		 * Length of shakeing in milliseconds
		 * @param length in milliseconds
		 */
		public function set duration(value:Number):void 
		{
			_duration = value;
		}
		
		public function get isShakeing():Boolean 
		{
			return _isShakeing;
		}
		
		//----------
		//  public methods
		//----------
		
		/**
		 * starts the shake effect
		 */
		public function start():void
		{
			var timer:Timer = new Timer(_duration, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete, false, 0, true);
			timer.start();
			SP.world.addEventListener(Event.ENTER_FRAME, enterFrame);
			_isShakeing = true;
		}
		
		//----------
		//  event handlers
		//----------
		
		private function enterFrame(e:Event):void 
		{
			shake();
		}
		
		private function onTimerComplete(e:TimerEvent):void 
		{
			var target:Timer = e.currentTarget as Timer;
			target.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			SP.world.removeEventListener(Event.ENTER_FRAME, enterFrame);
			
			SP.world.x = _startPos.x;
			SP.world.y = _startPos.y;
			_isShakeing = false;
		}
		
		//----------
		//  private methods
		//----------
		
		private function shake():void
		{
			SP.world.x = _startPos.x - (Math.random() * _intensity - (_intensity * .5));
			SP.world.y = _startPos.y - (Math.random() * _intensity - (_intensity * .5));
		}
	}
}