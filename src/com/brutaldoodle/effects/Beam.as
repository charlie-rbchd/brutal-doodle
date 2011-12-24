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
	
	import org.flintparticles.common.counters.TimePeriod;
	import org.flintparticles.common.displayObjects.RadialDot;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Accelerate;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.ScaleAllInit;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.zones.PointZone;
	import org.flintparticles.twoD.zones.RectangleZone;
	
	/*
	 * Contain the definition of the look and behavior of the Beam particle emitter
	 * The particles emitted are to collide with any "player" bounding box registered within the CollisionManager
	 */
	public class Beam extends PlayerCollidableEmitter
	{		
		public function Beam()
		{
			super();
			
			// The amount of damage dealt by each particle emitted
			_damageAmount = 5;
			
			// A hundred particles are emitted over 500 miliseconds
			counter = new TimePeriod(100, 0.5);
			
			// Particle's appearance
			addInitializer( new SharedImage( new RadialDot(20, 0xf2797c, "screen") ) );
			addInitializer( new Position( new RectangleZone(10, 10, -10, 10) ) );
			addInitializer( new ScaleAllInit(0.6, 1.4) );
			
			// Particle's behavior
			addInitializer( new Velocity( new PointZone( new Point(0, 400) ) ) );
			addAction( new Accelerate(0, 100) );
			addAction( new Move() );
		}
	}
}