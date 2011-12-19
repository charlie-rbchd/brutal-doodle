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

package com.brutaldoodle.utils
{
	import flash.geom.Point;

	public class Ellipse
	{
		/*
		 * The position of the center of the ellipse
		 */
		public var center:Point;
		
		/*
		 * The width of the ellipse
		 */
		public var width:Number;
		
		/*
		 * The height of the ellipse
		 */
		public var height:Number;
		
		public function Ellipse() {}
		
		/*
		 * Retrieve the position of a point on an ellipse at a specific angle
		 *
		 * @param angle  The angle in degrees
		 * @return The position of the point
		 */
		public function getPointAtAngle (angle:Number):Point {
			var radians:Number = Maths.degreesToRadians(angle);
			return new Point(
				center.x + width/2 * Math.cos(radians),
				center.y + height/2 * Math.sin(radians)
			);
		}
	}
}