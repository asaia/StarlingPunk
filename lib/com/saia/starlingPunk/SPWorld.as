package com.saia.starlingPunk 
{
	import flash.utils.Dictionary;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import com.saia.starlingPunk.SPEntity;
	/**
	 * Updated by Engine, main game container that holds all currently active Entities.
	 * Useful for organization, eg. "Menu", "Level1", etc.
	 * @author Andy Saia
	 */
	public class SPWorld extends Sprite
	{	
		private var allEntities:Vector.<SPEntity>;
		private var _entityNames:Vector.<SPEntity>
		private var _addList:Vector.<SPEntity>;
		private var _removeList:Vector.<SPEntity>;
		private var _active:Boolean;
		private var _disposeEntities:Boolean;
		private var _layerList:Dictionary;
		private var maxLayers:int = 10;
		
		public function SPWorld() 
		{
			//probably dictionary
			_entityNames = new Vector.<SPEntity>();
			_layerList = new Dictionary();
			allEntities = new Vector.<SPEntity>();
			
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
		 * called my the main StarlinPunk engine every frame, should not be overriden
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
			//entity.world = null;
		}
		
		/**
		* removes all the entities from the world
		* @param overrides the worlds disposeEntities property
		*/
		public function removeAll(dispose:Boolean = true):void
		{
			_disposeEntities = dispose;
			var entity:SPEntity;
			for each (var entities:* in allEntities) 
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
		 * returns a vector of ever entity in the world
		 * @return
		 */
		public function getAllEntities():Vector.<SPEntity>
		{
			var allEnts:Vector.<SPEntity> = allEntities;
			return allEnts;
		}
		
		/**
		 * returns a vector of all entities of that type
		 * @param type The type to check.
		 * @return vector of entities of supplied type
		*/
		public function getType(type:String):Vector.<SPEntity>
		{
			//return _allEntities[type];
			
			var allObjects:Vector.<SPEntity> = allEntities;
			var typeList:Vector.<SPEntity> = new Vector.<SPEntity>();
			
			for each (var ent:SPEntity in allObjects)
			{
				if (ent.type == type)
				{
					typeList.push(ent);
				}
			}
			return typeList;
		}
		
		/**
		 * Returns a Entity by it's unique name. In the case of multiple entities with same name, will grab last
		 * added.
		 * @param	entityName		The entity's name (set "eName" in the entity itself)
		 * @return					The entity matching the specified name
		 */
		public function getInstance(entityName:String):SPEntity
		{
			var objList:Vector.<SPEntity> = allEntities;
			var ent:SPEntity;
			
			for each (var entity:SPEntity in objList)
			{
				if (entity.eName == entityName)
				{
					ent = entity;
				}
			}
			
			return ent;
		}
		

		//----------
		//  private methods
		//----------
		
		private function updateEntities():void 
		{
			var entity:SPEntity;
			//for each (var entities:Vector.<SPEntity> in _allEntities)
			for each (var entities:* in allEntities) 
			{				
				entities.update();
			}
		}
		
		private function processRemoveList():void
		{
			var entity:SPEntity;
			//only execute for as long as there are items left to remove
			while (this._removeList.length) 
			{
				entity = _removeList[0];
				entity.behaviorManager.removeAllBehaviors();
				entity.removed();
				entity.world = null;
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
			allEntities.push(entity);
		}
		
		private function removeFromObjectLookup(entity:SPEntity):void
		{
			var testIndex:int = allEntities.indexOf(entity);
			allEntities.splice(testIndex, 1);
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