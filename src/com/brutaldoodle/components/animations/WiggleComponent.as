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
	
	public class WiggleComponent extends TickedComponent
	{
		/*
		 * References to the owner's properties
		 */
		public var positionProperty:PropertyReference;
		
		/*
		 * The speed at which the object wiggles
		 */
		public var moveSpeed:Number;
		
		/*
		 * The amount of ticks needed to reverse the move speed
		 */
		public var tickRate:Number;
		
		/*
		 * The current amount of ticks since the component was added
		 */
		private var _numTicks:int;
		
		public function WiggleComponent() {
			super();
			_numTicks = 0;
		}
		
		override public function onTick(deltaTime:Number):void {
			super.onTick(deltaTime);
			
			// Reverse the move speed every tickRate number of ticks
			if (_numTicks%tickRate == 0) moveSpeed = -moveSpeed;
			_numTicks++;
			
			// Apply the new position to the object
			var position:Point = owner.getProperty(positionProperty);
			position.y += moveSpeed;
			owner.setProperty(positionProperty, position);

		}
	}
}