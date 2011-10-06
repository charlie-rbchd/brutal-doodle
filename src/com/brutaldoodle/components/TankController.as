package com.brutaldoodle.components
{
	import com.brutaldoodle.events.TankEvent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.core.InputKey;
	import com.pblabs.engine.entity.PropertyReference;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class TankController extends TickedComponent
	{
		public static const STATE_NORMAL:String = "normalState";
		public static const STATE_ALTERNATE:String = "alternateState";
		
		public static var moveSpeed:Number;
		public var positionProperty:PropertyReference;
		public var sizeProperty:PropertyReference;
		public var currentAnimation:String;
		
		private static var _state:String;
		private var _isIdle:Boolean;
		
		public function TankController()
		{
			super();
			TankController.moveSpeed = 10;
			
			_state = TankController.STATE_NORMAL;
			_isIdle = true;
		}
		
		override public function onTick(deltaTime:Number):void
		{
			super.onTick(deltaTime);
			
			var _position:Point = owner.getProperty(positionProperty);
			var _size:Point = owner.getProperty(sizeProperty);
			var _animation:String;
			
			// moving animations when LEFT or RIGHT keys are pressed, idle animations when no keys are pressed
			if (PBE.isKeyDown(InputKey.LEFT) || PBE.isKeyDown(InputKey.RIGHT)) {
				if (_isIdle) {
					_animation = _state == TankController.STATE_NORMAL ? "Move_Normal" : "Move_Alternate";
					updateAnimation(_animation, false);
				}
			} else {
				_animation = _state == TankController.STATE_NORMAL ? "Idle_Normal" : "Idle_Alternate";
				updateAnimation(_animation, true);
			}
			
			// change to alternate state when UP key is pressed
			if (PBE.isKeyDown(InputKey.UP))
			{
				if (!_isIdle || _state != TankController.STATE_ALTERNATE) {
					owner.setProperty(sizeProperty, new Point(55, 100));
					_animation = "Idle_Alternate";
					updateAnimation(_animation, true, TankController.STATE_ALTERNATE);
				}
			}
			
			// change to normal state when DOWN key is pressed
			if (PBE.isKeyDown(InputKey.DOWN))
			{
				if (!_isIdle || _state != TankController.STATE_NORMAL) {
					owner.setProperty(sizeProperty, new Point(100, 55));
					_animation = "Idle_Normal";
					updateAnimation(_animation, true, TankController.STATE_NORMAL);
				}
			}
			
			// position update when keys are pressed
			var _speed:Number = _state == TankController.STATE_ALTERNATE ? TankController.moveSpeed/2 : TankController.moveSpeed;
			if (PBE.isKeyDown(InputKey.LEFT)) _position.x -= _speed;
			if (PBE.isKeyDown(InputKey.RIGHT)) _position.x += _speed;
			
			// collisions with scene boundaries
			var _maxWidth:int = (PBE.mainStage.stageWidth - _size.x)/2;
			if (_position.x < - _maxWidth) _position.x = - _maxWidth;
			if (_position.x >   _maxWidth) _position.x =   _maxWidth;
			owner.setProperty(positionProperty, _position);
		}
		
		private function updateAnimation (animation:String, idle:Boolean, state:String=null):void {
			currentAnimation = animation;
			owner.eventDispatcher.dispatchEvent(new TankEvent(TankEvent.UPDATE_ANIMATION));
			if (state != null) _state = state;
			_isIdle = idle;
		}
		
		public static function get state():String { return _state; }
	}
}