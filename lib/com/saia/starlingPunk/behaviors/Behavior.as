package com.saia.starlingPunk.behaviors 
{
	import com.saia.starlingPunk.SPEntity;
	import flash.utils.getQualifiedClassName;
	/**
	 * base class for behaviors
	 */
	public class Behavior implements IBehavior
	{
		protected var _name:String;
		protected var _entity:SPEntity;
		
		public function Behavior(entity:SPEntity = null)
		{
			_entity = entity;
			
			var classPath:String = getQualifiedClassName(this) as String;
			_name = classPath.slice(classPath.lastIndexOf("::") + 2);
		}
		
		//---------------
		//  getters and setters 
		//---------------
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get entity():SPEntity 
		{
			return _entity;
		}
		
		//---------------
		//  abstract methods
		//---------------
		
		public function added():void 
		{
		}
		
		public function removed():void 
		{
			
		}
		
		public function onUpdate():void 
		{
			
		}
	}
}