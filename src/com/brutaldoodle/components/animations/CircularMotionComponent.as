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
	import com.brutaldoodle.utils.Maths;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.PropertyReference;
	
	import flash.geom.Point;

	public class CircularMotionComponent extends EntityComponent
	{
		public var positionProperty:PropertyReference;
		public var timeOffset:Number;
		public var ellipse:Ellipse;
		
		public function CircularMotionComponent()
		{
			super();
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			owner.setProperty(positionProperty, ellipse.getPointAtAngle( (new Date().hours + timeOffset) * 15) );
		}
	}
}