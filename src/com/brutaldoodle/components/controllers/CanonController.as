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
	import com.brutaldoodle.entities.Projectile;
	import com.brutaldoodle.rendering.CanonShotRenderer;
	import com.pblabs.animation.AnimationEvent;
	import com.pblabs.animation.Animator;
	import com.pblabs.animation.AnimatorType;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.core.InputKey;
	import com.pblabs.engine.entity.PropertyReference;
	
	import flash.geom.Point;
	
	public class CanonController extends TickedComponent {
		/*
		 * The speed at which the canon reloads
		 */
		public static var reloadSpeed:Number;
		
		/*
		 * Whether or not the player can shoot projectiles
		 */
		public static var shootPermission:Boolean = true;
		
		/*
		 * Constants used in order to easily identify the canon's offset
		 */
		public static const NORMAL_OFFSET:Number = -18;
		public static const ALTERNATE_OFFSET:Number = -62;
		
		/*
		 * References to canon's properties
		 */
		public var canonOffset:PropertyReference;
		public var positionProperty:PropertyReference;
		
		/*
		 * The shoot animation
		 */
		private var _shootAnimation:Animator;
		
		/*
		 * The reload animation
		 */
		private var _reloadAnimation:Animator;
		
		public function CanonController() {
			super();
			_shootAnimation = new Animator();
			_reloadAnimation = new Animator();
		}
		
		override public function onTick(deltaTime:Number):void {
			super.onTick(deltaTime);
			
			// Change the canon's offset depending on the player's current state
			var _offset:Number = PlayerController.state == PlayerController.STATE_NORMAL ? CanonController.NORMAL_OFFSET : CanonController.ALTERNATE_OFFSET;
			owner.setProperty(canonOffset, new Point(0, _offset));
			
			// Update the animations at each tick, otherwise, checks for user input
			if (_shootAnimation.isAnimating)
			{
				_shootAnimation.animate(deltaTime);
				owner.setProperty(canonOffset, new Point(0, _shootAnimation.currentValue + _offset));
			}
			else if (_reloadAnimation.isAnimating)
			{
				_reloadAnimation.animate(deltaTime);
				owner.setProperty(canonOffset, new Point(0, _reloadAnimation.currentValue + _offset));
			}
			else
			{
				if (shootPermission) {
					if (PBE.isKeyDown(InputKey.SPACE)) {
						// Shoot a projectile rendered by the CanonShotRenderer
						var p:Projectile = new Projectile(CanonShotRenderer, owner);
						
						// Start the shoot animation
						_shootAnimation.start(0, 26, 0.05, AnimatorType.PLAY_ANIMATION_ONCE);
						_shootAnimation.addEventListener(AnimationEvent.ANIMATION_FINISHED_EVENT, shootAnimationComplete);
					}
				}
			}
		}
		
		/*
		 * Start the reload animation once the shoot animation is done
		 */
		private function shootAnimationComplete(event:AnimationEvent):void {
			_shootAnimation.removeEventListener(AnimationEvent.ANIMATION_FINISHED_EVENT, shootAnimationComplete);
			_reloadAnimation.start(26, 0, CanonController.reloadSpeed, AnimatorType.PLAY_ANIMATION_ONCE);
		}
	}
}