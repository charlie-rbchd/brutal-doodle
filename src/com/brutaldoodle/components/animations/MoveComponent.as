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
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.entity.PropertyReference;
	
	import flash.geom.Point;
	
	public class MoveComponent extends TickedComponent
	{
		/*
		 * References to the owner's properties
		 */
		public var positionProperty:PropertyReference;
		
		/*
		 * The amount by which the x coordinate will be moved each tick
		 */
		public var deltaX:Number;
		
		/*
		 * The amount by which the y coordinate will be moved each tick
		 */
		public var deltaY:Number;
		
		/*
		 * The value of the x coordinate at which the owner will stop moving
		 */
		public var targetX:Number;
		
		/*
		 * The value of the y coordinate at which the owner will stop moving
		 */
		public var targetY:Number;
		
		public function MoveComponent() {
			super();
		}
		
		override public function onTick(deltaTime:Number):void {
			super.onTick(deltaTime);
			// Modifiy the owner's position each tick, making it tween
			var position:Point = owner.getProperty(positionProperty);
			if (position.x != targetX) position.x += deltaX;
			if (position.y != targetY) position.y += deltaY;
			owner.setProperty(positionProperty, position);	
		}
	}
}