package com.saia.starlingPunk.behaviors 
{
	
	/**
	 * interface that defines what a behavior is
	 */
	public interface IBehavior 
	{
		function added():void;

		function removed():void;
		
		function onUpdate():void;
		
		function get name():String;
	}
}