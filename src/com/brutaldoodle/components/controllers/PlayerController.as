/*
* Brutal Doodle
* Copyright (C) 2011  Joel Robichaud, Maxime Basque, Maxime St-Louis-Fortier, Raphaelle Cantin & Simon Garnier
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.

* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

package com.brutaldoodle.components.controllers
{
	import com.brutaldoodle.events.TankEvent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.core.InputKey;
	import com.pblabs.engine.entity.PropertyReference;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class PlayerController extends TickedComponent {
		/*
		 * The speed at which the player moves
		 */
		public static var moveSpeed:Number;
		
		/*
		 * Constants used in order to easily identify the player's state
		 */
		public static const STATE_NORMAL:String = "normalState";
		public static const STATE_ALTERNATE:String = "alternateState";
		
		/*
		 * References to player's properties
		 */
		public var positionProperty:PropertyReference;
		public var sizeProperty:PropertyReference;
		public var boundingBoxProperty:PropertyReference;
		
		/*
		 * The name of the player's current animation
		 */
		public var currentAnimation:String;
		
		/*
		 * The player's current state (normal or alternate)
		 */
		private static var _state:String;
		
		/*
		 * Whether the player is currently idle or moving
		 */
		private var _isIdle:Boolean;
		
		public function PlayerController() {
			super();
			_state = PlayerController.STATE_NORMAL;
			_isIdle = true;
		}
		
		override public function onTick(deltaTime:Number):void {
			super.onTick(deltaTime);
			
			// Retrieve the needed properties from the Entity
			var _position:Point = owner.getProperty(positionProperty);
			var _size:Point = owner.getProperty(sizeProperty);
			var _boundingBox:Rectangle = owner.getProperty(boundingBoxProperty);
			var _animation:String;
			
			// Change the player's current animation to "moving" when either the LEFT or RIGHT key is pressed
			// Revert it back to "idle" when no keys are pressed
			if (PBE.isKeyDown(InputKey.LEFT) || PBE.isKeyDown(InputKey.RIGHT)) {
				if (_isIdle) {
					_animation = _state == PlayerController.STATE_NORMAL ? "Move_Normal" : "Move_Alternate";
					updateAnimation(_animation, false);
				}
			} else {
				_animation = _state == PlayerController.STATE_NORMAL ? "Idle_Normal" : "Idle_Alternate";
				updateAnimation(_animation, true);
			}
			
			// Change the player's state to alternate when the UP key is pressed
			if (PBE.isKeyDown(InputKey.UP))
			{
				if (!_isIdle || _state != PlayerController.STATE_ALTERNATE) {
					owner.setProperty(sizeProperty, new Point(55, 100));
					_animation = "Idle_Alternate";
					updateAnimation(_animation, true, PlayerController.STATE_ALTERNATE);
				}
			}
			
			// Change the player's state to normal when the UP key is pressed
			if (PBE.isKeyDown(InputKey.DOWN))
			{
				if (!_isIdle || _state != PlayerController.STATE_NORMAL) {
					owner.setProperty(sizeProperty, new Point(100, 55));
					_animation = "Idle_Normal";
					updateAnimation(_animation, true, PlayerController.STATE_NORMAL);
				}
			}
			
			// Update the position depending on which key is pressed
			var _speed:Number = _state == PlayerController.STATE_ALTERNATE ? PlayerController.moveSpeed/2 : PlayerController.moveSpeed;
			if (PBE.isKeyDown(InputKey.LEFT))  _position.x -= _speed;
			if (PBE.isKeyDown(InputKey.RIGHT)) _position.x += _speed;
			
			// Check for collisions with scene boundaries
			var _maxWidth:int = (PBE.mainStage.stageWidth - _size.x)/2;
			if (_position.x < - _maxWidth) _position.x = - _maxWidth;
			if (_position.x >   _maxWidth) _position.x =   _maxWidth;
			
			// Reposition the bounding box used for particle collisions
			_boundingBox.left = _position.x - _size.x/2 + 10;
			_boundingBox.right = _position.x + _size.x/2 - 10;
			_boundingBox.top = _position.y - _size.y/2 + 15;
			_boundingBox.bottom = _position.y + _size.y/2 - 10;
			
			owner.setProperty(positionProperty, _position);
			owner.setProperty(boundingBoxProperty, _boundingBox);
		}
		
		/*
		 * Change the player's animation
		 *
		 * @animation  The new animation's name
		 * @idle  Whether the player is idle or moving
		 * @state  The player's state (normal or alternate)
		 */
		private function updateAnimation (animation:String, idle:Boolean, state:String=null):void {
			currentAnimation = animation;
			owner.eventDispatcher.dispatchEvent(new TankEvent(TankEvent.UPDATE_ANIMATION));
			if (state != null) _state = state;
			_isIdle = idle;
		}
		
		public static function get state():String { return _state; }
	}
}