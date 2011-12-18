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

package com.brutaldoodle.components.animations
{
	import com.pblabs.animation.AnimatorComponent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import flash.geom.Point;
	
	public class ChangeStateOnRaycastWithPlayer extends TickedComponent {
		public var positionProperty:PropertyReference;
		public var sizeProperty:PropertyReference;
		
		private var _isAnimating:Boolean;
		
		public function ChangeStateOnRaycastWithPlayer() {
			super();
			_isAnimating = false;
		}
		
		override public function onTick(deltaTime:Number):void {
			super.onTick(deltaTime);
			
			var tankPosition:Point = (PBE.lookupComponentByName("Player", "Spatial") as SimpleSpatialComponent).position
			var animator:AnimatorComponent = owner.lookupComponentByName("Animator") as AnimatorComponent;
			var position:Point = owner.getProperty(positionProperty);
			var size:Point = owner.getProperty(sizeProperty);
			
			// check for positions between the buttons and the player
			if (tankPosition.x >=  position.x - size.x/2 && tankPosition.x <= position.x + size.x/2)
			{
				// animate the button if the player is under it
				if (!_isAnimating) {
					animator.play("hover");
					_isAnimating = true;
				}
			}
			else
			{
				// otherwise, stop the animation
				if (_isAnimating) {
					animator.play("idle");
					_isAnimating = false;
				}
			}
		}
	}
}