package com.saia.starlingPunk 
{	
	import com.saia.starlingPunk.events.EngineEvent;
	import com.saia.starlingPunk.utils.SPInput;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	
	/**
	 * Main game Sprite class, Manages the game loop.
	 * @author Andy Saia
	 */
	
	public class SPEngine extends Sprite
	{
		/**
		 * If the game should stop updating/rendering.
		 */
		private var _paused:Boolean = false;
		
		/**
		 * Constructor. Defines startup information about your game.
		 * @param	width			The width of your game.
		 * @param	height			The height of your game.
		 * @param	frameRate		The game framerate, in frames per second.
		 * @param	fixed			If a fixed-framerate should be used.
		 */
		public function SPEngine() 
		{	
			// global game objects
			SP.engine = this;
			SP.camera = new SPCamera();
			SP._world = new SPWorld;
			addChild(SP.camera.container);
			SP.camera.container.addChild(SP._world);
			
			// on-stage event listener
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		//----------
		//  getters and setters
		//----------
		
		public function get paused():Boolean 
		{
			return _paused;
		}
		
		public function set paused(value:Boolean):void 
		{
			_paused = value;
			if (value)
				dispatchEvent(new EngineEvent(EngineEvent.PAUSED));
			else
				dispatchEvent(new EngineEvent(EngineEvent.UNPAUSED));
		}
		
		/**
		 * Override this, called after Engine has been added to the stage.
		 */
		public function init():void { }
		
		/**
		 * Updates the game, updating the World and Entities.
		 */
		public function update():void
		{
			if (SP._world.active)
			{
				SP._world.engineUpdate();
			}
			SP._world.updateLists();
			if (SP._goto) checkWorld();
			
		}
		
		/** @private Event handler for stage entry. */
		private function onStage(e:Event = null):void
		{
			// remove event listener
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			
			SP.stage = stage;
			
			// enable input
			SPInput.enable();
			
			// global game properties
			SP.width = stage.stageWidth;
			SP.height = stage.stageHeight;
			
			// switch worlds
			if (SP._goto) checkWorld();
			
			// game start
			init();
			
			// start game loop
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/** @private Framerate independent game loop. */
		private function onEnterFrame(e:EnterFrameEvent):void
		{	
			// update loop
			if (!_paused) update();
			
			SP.passedTime = e.passedTime;
			
			// update input
			SPInput.update();
		}
		
		/** @private Switch Worlds if they've changed. */
		private function checkWorld():void
		{
			if (!SP._goto) return;
			
			SP._world.end();
			SP.camera.container.removeChild(SP._world, true);
			SP._world.updateLists();
			SP._world = SP._goto;
			SP._goto = null;
			SP._world.updateLists();
			SP.camera.container.addChild(SP._world);
			SP.camera.setWorld(SP._world);
			SP._world.begin();
			SP._world.updateLists();
		}
	}
}