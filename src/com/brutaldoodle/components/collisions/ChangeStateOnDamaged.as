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

	package com.brutaldoodle.components.collisions
{
	import com.brutaldoodle.components.basic.HealthComponent;
	import com.pblabs.animation.AnimationEvent;
	import com.pblabs.animation.Animator;
	import com.pblabs.animation.AnimatorComponent;
	import com.pblabs.animation.AnimatorType;
	import com.pblabs.engine.components.TickedComponent;
	
	public class ChangeStateOnDamaged extends TickedComponent
	{
		/*
		 * Constants used in order to easily identify damage states
		 */
		public static const STATE_NOT_INJURED:String = "notInjured";
		public static const STATE_BARELY_INJURED:String = "barelyInjured";
		public static const STATE_INJURED:String = "injured";
		public static const STATE_BADLY_INJURED:String = "badlyInjured";
		
		/*
		 * The owner's current damage state
		 */
		private var __currentState:String;
		
		/*
		 * The owner's currently playing animation
		 */
		private var _currentAnimation:Animator;
		
		/*
		 * The owner's animator component
		 */
		private var _animator:AnimatorComponent;
		
		/*
		 * The owner's health component
		 */
		private var _health:HealthComponent;
		
		public function ChangeStateOnDamaged() {
			super();
		}
		
		override protected function onAdd():void {
			super.onAdd();
			_animator = owner.lookupComponentByName("Animator") as AnimatorComponent;
			_health = owner.lookupComponentByName("Health") as HealthComponent;
			_currentState = STATE_NOT_INJURED; // Default state
		}
		
		override public function onTick(deltaTime:Number):void
		{
			super.onTick(deltaTime);
			
			var remainingLife:Number = _health.health;
			
			// The owner is still "not injured" when still above 75 health
			if (remainingLife > 75) return;
			
			// The display of the owner's sprite is modified accordingly to its remaining life
			var state:String;
			if (remainingLife <= 25)
			{
				state = STATE_BADLY_INJURED;
			}
			else if (remainingLife <= 50)
			{
				state = STATE_INJURED;
			}
			else if (remainingLife <= 75)
			{
				state = STATE_BARELY_INJURED;
			}
			
			// Apply the changes only if the state has changed
			if (state != _currentState) {
				// Keep track of where the animation was before it changed position on the spritesheet
				var startFrame:Number = _currentAnimation.currentValue + 9;
				
				_currentState = state; // Change the state
				
				_animator.play(_currentState, startFrame);
				// The duration is adjusted in order to maintain a fluid transition between animation states
				_currentAnimation.duration = (_currentAnimation.duration / 9) * (9 - startFrame % 9);
				_currentAnimation.addEventListener(AnimationEvent.ANIMATION_REPEATED_EVENT, onRepeat);
			}
		}
		
		/*
		 * Reset the animation's duration so that the next animation plays normally
		 */
		private function onRepeat(event:AnimationEvent):void {
			_currentAnimation.removeEventListener(AnimationEvent.ANIMATION_REPEATED_EVENT, onRepeat);
			_currentAnimation.start(_currentAnimation.targetValue - 9, _currentAnimation.targetValue, 4, AnimatorType.LOOP_ANIMATION, -1);
		}
		
		private function set _currentState (value:String):void {
			__currentState = value;
			_currentAnimation = _animator.animations[_currentState] as Animator;
		}
		
		private function get _currentState ():String {
			return __currentState;
		}
	}
}