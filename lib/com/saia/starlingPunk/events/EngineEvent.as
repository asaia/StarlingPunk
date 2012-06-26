package com.saia.starlingPunk.events 
{
	import starling.events.Event;
	
	/**
	 * Called when the engine pauses and unpauses useful for stoping background processes or timers
	 */
	public class EngineEvent extends Event 
	{
		/**
		 * Paused event dispatched when the engine is paused 
		 */
		public static const PAUSED:String = "paused";
		/**
		 * Unpaused event dispatched when the engine is unpaused 
		 */
		public static const UNPAUSED:String = "unpaused";
		
		public function EngineEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles);
			
		} 
		
		public override function toString():String 
		{ 
			return ("EngineEvent" + "type" + "bubbles"+ "cancelable"+ "eventPhase"); 
		}
	}
}