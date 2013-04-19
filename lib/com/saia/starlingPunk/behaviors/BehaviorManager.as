package com.saia.starlingPunk.behaviors
{
	/**
	 * base behavior manager, adds/removes and updates all behaviors
	 */
	public class BehaviorManager
	{
		protected var _allBehaviors:Vector.<IBehavior>;
		protected var _behaviorsToRemove:Vector.<IBehavior>;
		protected var _behaviorsToAdd:Vector.<IBehavior>;
		
		public function BehaviorManager()
		{
			_allBehaviors = new Vector.<IBehavior>();
			_behaviorsToAdd = new Vector.<IBehavior>();
			_behaviorsToRemove = new Vector.<IBehavior>();
		}
		
		//---------------
		//  public methods
		//---------------
		
		/**
		 * adds the behavior to the list of behaviors to get added on the next frame
		 * @param	behavior
		 */
		public function add(behavior:IBehavior):void
		{
			_behaviorsToAdd.push(behavior);
		}
		
		/**
		 * adds the behavior to the list of behaviors to get removed on the next frame
		 * @param	behavior
		 */
		public function remove(behavior:IBehavior):void
		{
			_behaviorsToRemove.push(behavior);
		}
			
		/**
		 * adds an enables this behavior immediately instead of waiting for the next frame
		 * @param	behavior
		 */
		public function addImmediate(behavior:IBehavior):void
		{
			_allBehaviors.push(behavior);
			behavior.added();
		}
		
		/**
		 * removes an disables this behavior immediately instead of waiting for the next frame
		 * @param	behavior
		 */
		public function removeImmediate(behavior:IBehavior):void
		{
			var index:int = _allBehaviors.indexOf(behavior);
			if (index == -1) return; //return if behavior is not part of behavior list
			
			behavior.removed();
			_allBehaviors.splice(index, 1);
		}

		/**
		 * returns a list of all the behaviors weither they are enabled or not
		 * @return
		 */
		public function getAllBehaviors():Vector.<IBehavior>
		{
			return _allBehaviors;
		}
		
		/**
		 * returns a behavior by its name
		 * @param	name
		 * @return
		 */
		public function getBehaviorByName(name:String):IBehavior
		{
			var numBehaviors:int = _allBehaviors.length;
			var behavior:IBehavior = null;
			for (var i:int = 0; i < numBehaviors; i++) 
			{
				var currentBehavior:IBehavior = _allBehaviors[i];
				if (currentBehavior.name == name)
				{
					behavior = currentBehavior;
					break;
				}
			}
			
			return behavior;
		}
		
		/**
		 * returns a behavior at the supplied index
		 * @param	index
		 * @return
		 */
		public function getBehaviorAt(index:int):IBehavior 
		{
			return _allBehaviors[index];
		}
		
		/**
		 * returns the number of behaviors this manager has regardless whether their enabled or not
		 * @return
		 */
		public function getNumOfBehaviors():int
		{
			return _allBehaviors.length;
		}
		
		/**
		 * removes all this managers behaviors
		 */
		public function removeAllBehaviors():void 
		{
			while (_allBehaviors.length)
			{
				removeImmediate(_allBehaviors[0]);
			}
		}
		
		/**
		 * updates all the behaviors and checks to see if any are ready to be removed or added
		 */
		public function update():void
		{
			var numBehaviors:int = _allBehaviors.length;
			for (var i:int = 0; i < numBehaviors; i++) 
			{
				//updates all the behaviors
				_allBehaviors[i].onUpdate();
			}
			
			if (_behaviorsToRemove.length > 0)
				removeOldBehaviors();
				
			if (_behaviorsToAdd.length > 0)
				addNewBehaviors();
		}
		
		//---------------
		//  protected methods
		//---------------
		
		protected function addNewBehaviors():void 
		{
			while (_behaviorsToAdd.length)
			{
				addImmediate(_behaviorsToAdd[0]);
				_behaviorsToAdd.splice(0, 1);
			}
		}
		
		protected function removeOldBehaviors():void 
		{
			while (_behaviorsToRemove.length)
			{
				removeImmediate(_behaviorsToRemove[0]);
				_behaviorsToRemove.splice(0, 1);
			}
		}
	}
}