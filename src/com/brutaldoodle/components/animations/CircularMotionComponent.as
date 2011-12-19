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
	import com.brutaldoodle.utils.Ellipse;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.entity.PropertyReference;

	public class CircularMotionComponent extends TickedComponent
	{
		/*
		 * References to the owner's properties
		 */
		public var positionProperty:PropertyReference;
		
		/*
		 * The amount of time (in hours) to offset the current time by
		 */
		public var timeOffset:Number;
		
		/*
		 * The ellipse on which the owner will travel
		 */
		public var ellipse:Ellipse;
		
		public function CircularMotionComponent()
		{
			super();
		}
		
		override public function onTick(deltaTime:Number):void
		{
			super.onTick(deltaTime);
			// Retrieve the current time and position the owner of the ellipse depending on what time it is
			var date:Date = new Date();
			owner.setProperty(positionProperty, ellipse.getPointAtAngle( (date.hours + (date.minutes + date.seconds/60)/60 + timeOffset) * 15) );
		}
		
	}
}