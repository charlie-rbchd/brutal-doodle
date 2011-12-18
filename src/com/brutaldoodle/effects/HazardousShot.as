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

package com.brutaldoodle.effects
{ 
	
	import com.brutaldoodle.emitters.PlayerCollidableEmitter;
	
	import flash.geom.Point;
	
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.displayObjects.Dot;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.actions.MutualGravity;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.zones.PointZone;
	import org.flintparticles.twoD.zones.RectangleZone;
	
	public class HazardousShot extends PlayerCollidableEmitter
	{
		public function HazardousShot() {
			super();
			
			_damageAmount = 8;
			
			//Generate 10 particles instantly
			counter = new Blast(5);
			
			addInitializer( new SharedImage( new Dot(2) ) );
			
			//Give the particle a color between those 2
			addInitializer( new ColorInit(0xFFFF0000, 0xFFFFFF00) );
			
			//Generate the particles in at a random point in this rectangle
			addInitializer( new Position( new RectangleZone(-25, -25, 25, 25) ) );
			addInitializer( new Velocity( new PointZone( new Point(0, 100) ) ) );
			
			addAction( new MutualGravity(1, 30) );
			addAction( new Move() );
		}
	}
}