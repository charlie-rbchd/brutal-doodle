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
	import flash.geom.Point;
	
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.displayObjects.RadialDot;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.zones.DiscZone;
	
	/*
	 * Contain the definition of the look and behavior of the Warp particle emitter
	 */
	public class Warp extends Emitter2D
	{		
		public function Warp()
		{
			super();
			
			// Fifty particles are instantly emitted
			counter = new Blast(50);
			
			// Particle's Appearance
			addInitializer( new SharedImage( new RadialDot(3, 0xFFFFFFF) ) );
			addInitializer( new Position( new DiscZone( new Point(0, 0), 40 ) ));
			
			// Particle's Behavior
			addInitializer( new Lifetime(1) );
			addAction( new Move() );
			addAction( new Age() );
		}
	}
}