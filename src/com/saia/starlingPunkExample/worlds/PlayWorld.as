package com.saia.starlingPunkExample.worlds 
{
	import com.saia.starlingPunk.SP;
	import com.saia.starlingPunk.SPWorld;
	import com.saia.starlingPunk.utils.Key;
	import com.saia.starlingPunk.utils.SPInput;
	import com.saia.starlingPunkExample.controller.ScoreController;
	import com.saia.starlingPunkExample.entities.AlienEntity;
	import com.saia.starlingPunkExample.entities.PlayerEntity;
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
			var timer:Timer = new Timer(_enemySpawnTimer);
			timer.addEventListener(TimerEvent.TIMER, onEnemySpawnTimer);
			timer.start();
			
			_player = new PlayerEntity();
			add(_player);
			
			ScoreController.init();
		}
		
		private function createBgFill():void 
		{
			var bgColor:uint = 0xABCC7D;
			var bmpData:BitmapData = new BitmapData(SP.width, SP.height, false, bgColor);
			var image:Image = new Image(Texture.fromBitmapData(bmpData));
			addChild(image);
		}
		
		
		override public function end():void 
		{
			super.end();
			removeAll();
		}
		
		override public function update():void 
		{
			super.update();
			if (SPInput.pressed(Key.ENTER) && _player.isDead)
			{
				SP.world = new PlayWorld();
			}
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
		
		private function spawnEnemy():void 
		{
			var enemy:AlienEntity = new AlienEntity();
			add(enemy);
		}
	}
}