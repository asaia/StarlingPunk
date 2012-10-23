package com.saia.starlingPunk 
{
	import flash.utils.Dictionary;
	import starling.display.Sprite;
	/**
	 * Updated by Engine, main game container that holds all currently active Entities.
	 * Useful for organization, eg. "Menu", "Level1", etc.
	 * @author Andy Saia
	 */
	public class SPWorld extends Sprite
	{	
		private var _allEntities:Dictionary;
		private var _addList:Vector.<SPEntity>;
		private var _removeList:Vector.<SPEntity>;
		private var _active:Boolean;
		private var _disposeEntities:Boolean;
		
		public function SPWorld() 
		{
			//probably dictionary
			_allEntities = new Dictionary();
			
			_addList = new Vector.<SPEntity>();
			_removeList = new Vector.<SPEntity>();
			
			_disposeEntities = true;
			_active = true;
		}
		
		//----------
		//  getters and setters
		//----------
		
		
		/**
		 * if the world is inactive entites won't be updated
		 */
		public function get active():Boolean 
		{
			return _active;
		}
		
		public function set active(value:Boolean):void 
		{
			_active = value;
		}
		
		/**
		 * whether or not the world should dispose the entity when removing them, by defualt it is set to true
		 */
		public function get disposeEntities():Boolean 
		{
			return _disposeEntities;
		}
		
		public function set disposeEntities(value:Boolean):void 
		{
			_disposeEntities = value;
		}
		
		//----------
		//  public methods
		//----------
		
		/**
		 * called my the main StarlinPunk engine ever frame, should not be overriden
		 */
		public function engineUpdate():void 
		{
			updateLists();
			if (_active)
			{
				updateEntities();
				update();
			}
		}
		
		/**
		 * called by main StarlingPunk engine, makes sure any entites queued to be removed/add get taken care of 
		 */
		public function updateLists():void
		{
			processAddList();
			processRemoveList();
		}
		
		/**
		 * addeds the entity to the world, entity will be added on next frame tick
		 * @param	entity to be added to the world
		 */
		public function add(entity:SPEntity):void
		{
			if (entity.world) return;
			entity.world = this;
			_addList.push(entity);
		}
		
		/**
		 * removes the entity to the world, entity will be removed on last frame tick
		 * @param	entity to be removed from the world
		 */
		public function remove(entity:SPEntity):void
		{
			if (!entity.world) return;
			_removeList.push(entity);
			entity.world = null;
		}
		
		/**
		* removes all the entities from the world
		* @param overrides the worlds disposeEntities property
		*/
		public function removeAll(dispose:Boolean = true):void
		{
			_disposeEntities = dispose;
			var entity:SPEntity;
			for each (var entities:Vector.<SPEntity> in _allEntities) 
			{
				var numEntities:int = entities.length;
				for (var i:int = 0; i < numEntities; i++) 
				{
					entity = entities[i];
					remove(entity);
				}
			}
		}
		
		/**
		 * returns a vector of all entities of that type
		 * @param type The type to check.
		 * @return vector of entities of supplied type
		*/
		public function getType(type:String):Vector.<SPEntity>
		{
			return _allEntities[type];
		}
		
		/**
		 * this is called by the entity object when ever the type is changed. It will update the allEntites dictionary list
		 * @param the old type of the entity
		 * @param the new type of the entity
		*/
		public function changeEntityTypeName(oldType:String, newType:String):void
		{
			var group:Vector.<SPEntity> = getType(oldType);
			delete _allEntities[oldType];
			
			var newGroup:Vector.<SPEntity> = getType(newType);
			if (!newGroup)
			{
				_allEntities[newType] = group;
			}
			else
			{
				_allEntities[newType] = newGroup.concat(group);
			}
		}
		
		//----------
		//  private methods
		//----------
		
		private function updateEntities():void 
		{
			var entity:SPEntity;
			for each (var entities:Vector.<SPEntity> in _allEntities) 
			{				
				var numEntities:int = entities.length;
				for (var i:int = 0; i < numEntities; i++) 
				{
					entity = entities[i];
					entity.update();
				}
			}
		}
		
		private function processRemoveList():void
		{
			var entity:SPEntity;
			//only execute for as long as there are items left to remove
			while (this._removeList.length) 
			{
				entity = _removeList[0];
				entity.removed();
				removeChild(entity, _disposeEntities);
				removeFromObjectLookup(entity);
				//removes items till none are left
				_removeList.splice(0, 1);
			}
		}
		
		private function processAddList():void
		{
			var entity:SPEntity;
			//only execute for as long as there are items left to add
			while (this._addList.length) 
			{
				entity = _addList[0];
				addEntityToLookUp(entity);
				
				var tempLayer:uint = entity.layer;
				if (tempLayer > numChildren)
					tempLayer = numChildren;
				addChildAt(entity, tempLayer);
				entity.added();
				//removes items till none are left
				_addList.splice(0, 1);
			}
		}
		
		private function addEntityToLookUp(entity:SPEntity):void
		{
			var entityTypeArray:Vector.<SPEntity> = getType(entity.type);
			if (entityTypeArray == null || entityTypeArray.length == 0) 
			{
				//create new array if doesn't exist
				entityTypeArray = new Vector.<SPEntity>();
			}
			entityTypeArray.push(entity);
			_allEntities[entity.type] = entityTypeArray;
		}
		
		private function removeFromObjectLookup(entity:SPEntity):void
		{
			var entityTypeArray:Vector.<SPEntity> = this.getType(entity.type);
			var index:int = entityTypeArray.indexOf(entity);
			entityTypeArray.splice(index, 1);
			
			if (entityTypeArray.length == 0) 
			{
				entityTypeArray = null;
			}
		}
		
		//----------
		//  abstract methods
		//----------
		
		/**
		 * Abstract method that is called when world starts
		 */
		public function begin():void { }
		
		/**
		 * Abstract method that is called when world ends
		 */
		public function end():void { }
		
		/**
		 * Abstract method that is called when world updates
		 */
		public function update():void { }
		
	}

}