package com.saia.starlingPunkExamples.shipShooter.worlds 
{
	import com.saia.starlingPunk.SP;
	import com.saia.starlingPunk.SPWorld;
	import com.saia.starlingPunk.utils.Key;
	import com.saia.starlingPunk.utils.SPInput;
	import com.saia.starlingPunkExamples.helpers.ExampleManager;
	import com.saia.starlingPunkExamples.shipShooter.controller.ScoreController;
	import com.saia.starlingPunkExamples.shipShooter.entities.AlienEntity;
	import com.saia.starlingPunkExamples.shipShooter.entities.PlayerEntity;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Andy Saia
	 */
	public class PlayWorld extends SPWorld 
	{
		private var _enemySpawnTimer:Number;
		private var _player:PlayerEntity;
		private var _timer:Timer;
		public function PlayWorld() 
		{
		}
		
		//----------
		//  overrides
		//----------
		
		override public function begin():void 
		{
			super.begin();
			createBgFill();
			
			_enemySpawnTimer = 500;
			_timer = new Timer(_enemySpawnTimer);
			_timer.addEventListener(TimerEvent.TIMER, onEnemySpawnTimer);
			_timer.start();
			
			_player = new PlayerEntity();
			add(_player);
			
			ScoreController.init();
			
			//display example instructions
			ExampleManager.displayText();
		}
		
		override public function end():void 
		{
			super.end();
			_timer.removeEventListener(TimerEvent.TIMER, onEnemySpawnTimer);
			_timer.stop();
			_timer = null;
			removeAll();
		}
		
		override public function update():void 
		{
			super.update();
			if (SPInput.pressed(Key.ENTER) && _player.isDead)
			{
				SP.world = new PlayWorld();
			}
			
			//update example manager
			ExampleManager.checkExampleChange();
		}
		
		//----------
		//  event handlers
		//----------
		
		private function onEnemySpawnTimer(e:TimerEvent):void 
		{
			spawnEnemy();
		}
		
		//----------
		//  private methods
		//----------
		
		private function createBgFill():void 
		{
			var bgColor:uint = 0xABCC7D;
			var bmpData:BitmapData = new BitmapData(SP.width, SP.height, false, bgColor);
			var image:Image = new Image(Texture.fromBitmapData(bmpData));
			addChild(image);
		}
		
		private function spawnEnemy():void 
		{
			var enemy:AlienEntity = new AlienEntity();
			add(enemy);
		}
	}
}