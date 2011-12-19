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
	public class Interval
	{
		/*
		 * The minimum of the interval
		 */
		public var minTime:Number;
		
		/*
		 * The maximum of the interval
		 */
		public var maxTime:Number;
		
		public function Interval(min:Number=0, max:Number=1000) {
			minTime = min;
			maxTime = max;
		}
		
		/*
		 * @return A number between the minimum and maximum specified at instanciation
		 */
		public function getTime ():Number {
			return minTime + (Math.random() * (maxTime - minTime));
		}
	}
}