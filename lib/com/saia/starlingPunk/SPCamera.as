package com.saia.starlingPunk 
{
	import flash.geom.Rectangle;
	import starling.display.Sprite;

	/**
	 * Camera class used for scrolling game worlds. Note that the scale and rotate properties are still somewhat experimental
	 * and your results may vary depending on what you're trying to do. 
	 * @author Andy Saia
	 */
	public class SPCamera
	{	
		private var _x:Number;
		private var _y:Number;
		private var _world:SPWorld;
		private var _zoom:Number;
		private var _rotation:Number;
		private var _viewPort:Rectangle;
		private var _container:Sprite;
		
		public function SPCamera() 
		{
			_container = new Sprite();
		}
		
		//---------------
		//  getters and setters
		//---------------
		
		/**
		 * a rectangle of the camera's visible area
		 */
		public function get viewPort():Rectangle
		{
			return _viewPort;
		}

		/**
		 * x position of the camera
		 */
		public function get x():Number 
		{
			//returns inverted container x pos
			return -_container.x;
		}
		
		public function set x(value:Number):void 
		{
			//inverting container xPos
			_container.x = -value;
			_viewPort.x = value;
		}
		
		/**
		 * y position of the camera
		 */
		public function get y():Number 
		{
			//returns inverted container y pos
			return -_container.y;
		}
		
		public function set y(value:Number):void 
		{
			//inverting container yPos
			_container.y = -value;
			_viewPort.y = value;
		}
		
		/**
		 * the camera container that every world is a child of
		 */
		public function get container():Sprite 
		{
			return _container;
		}
		
		/**
		 * zoom amount of the camera
		 */
		public function get zoom():Number 
		{
			return _zoom;
		}
		
		public function set zoom(value:Number):void 
		{
			_zoom = value;
			_world.scaleX = _zoom;
			_world.scaleY = _zoom;
			
			//TODO: figure out exact viewport postion and size when scaling
			//var scaleAmount:Number = 1 + (1 - _zoom);
			//_viewPort.width = SP.width * scaleAmount;
			//_viewPort.height = SP.height * scaleAmount;
		}
		
		/**
		 * rotation of the camera
		 */
		public function get rotation():Number 
		{
			return _rotation;
		}
		
		public function set rotation(value:Number):void 
		{
			_rotation = value;
			_world.rotation = _rotation;
		}

		//---------------
		//  public methods
		//---------------
		
		public function setWorld(world:SPWorld):void
		{
			_world = world;
			reset();
		}
		
		/**
		 * sets the camera's position
		 * @param	x
		 * @param	y
		 */
		public function setPosition(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		/**
		 * resets camera to orignal position
		 */
		public function reset():void
		{
			_viewPort = new Rectangle(0, 0, SP.width, SP.height);
			zoom = 1;
			rotation = 0;
			setPosition(0, 0);
			focus(SP.halfWidth, SP.halfHeight);
		}
		
		/**
		 * pivot point of the camera when scaling and rotating
		 */
		public function focus(x:Number, y:Number):void
		{
			_world.pivotX = x;
			_world.pivotY = y;
			_world.x = _world.pivotX;
			_world.y = _world.pivotY;
		}
	}
}