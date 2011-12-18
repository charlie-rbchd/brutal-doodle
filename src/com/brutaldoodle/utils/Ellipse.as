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
		public var center:Point;
		public var width:Number;
		public var height:Number;
		
		public function Ellipse(/*center:Point, width:Number, height:Number*/) {
			/*
			this.center = center;
			this.height = height;
			this.width  = width;
			*/
		}
		
		public function getPointAtAngle (angle:Number):Point {
			var radians:Number = Maths.degreesToRadians(angle);
			return new Point(
				center.x + width/2 * Math.cos(radians),
				center.y + height/2 * Math.sin(radians)
			);
		}
		/* TO BE IMPLEMENTED...
		public function getPointBetweenAngles (angleA:Number, angleB:Number):Point {
			
		}
		
		public function getRandomPoint ():Point {
			
		}
		*/
		public function get majorAxis ():Number {
			return Math.max(width, height);
		}
		
		public function get semiMajorAxis ():Number {
			return Math.max(width, height)/2;
		}
		
		public function get minorAxis ():Number {
			return Math.min(width, height);
		}
		
		public function get semiMinorAxis ():Number {
			return Math.min(width, height)/2;
		}
		/* TO BE IMPLEMENTED...
		public function get eccentricity ():Number {
			
		}
		
		public function get leftFocus ():Point {
			
		}
		
		public function get rightFocus ():Point {
			
		}
		
		public function get foci ():Vector.<Point> {
			
		}
		
		public function get circumference ():Number {
			
		}
		*/
		public function get area ():Number {
			return Math.PI * width/2 * height/2;
		}
	}
}