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
	
	public class MoveUpAndFadeComponent extends TickedComponent
	{
		public var positionProperty:PropertyReference;
		public var alphaProperty:PropertyReference;
		public var delta:Number;
		
		public function MoveUpAndFadeComponent() {
			super();
			delta = 0.05;
		}
		
		override public function onTick(deltaTime:Number):void {
			super.onTick(deltaTime);
			
			var alpha:Number = owner.getProperty(alphaProperty);
			alpha -= delta; // modify the alpha until its pretty much invisible
			
			// delete the object if it turned invisible
			if (alpha <= 0.05) {
				owner.destroy();
				return;
			}
			
			// move up (a bit angled to the right) as long as its visible
			var pos:Point = owner.getProperty(positionProperty);
			pos.y -= 2;
			pos.x += 0.5;
			
			// apply the alpha and position to the owner object
			owner.setProperty(positionProperty, pos);	
			owner.setProperty(alphaProperty, alpha);
		}
	}
}