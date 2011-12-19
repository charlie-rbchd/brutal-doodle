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
	import org.flintparticles.common.actions.Fade;
	import org.flintparticles.common.counters.TimePeriod;
	import org.flintparticles.common.displayObjects.RadialDot;
	import org.flintparticles.common.easing.Quadratic;
	import org.flintparticles.common.initializers.ColorsInit;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.actions.RandomDrift;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.zones.DiscSectorZone;
	
	/*
	 * Contain the definition of the look and behavior of the Warp particle emitter
	 */
	public class Smoke extends Emitter2D
	{
		public function Smoke() {
			super();
			
			// Fifteen particles are emitted over 500 miliseconds
			counter = new TimePeriod(15, 0.5);
			
			// Particle's Appearance
			addInitializer( new SharedImage( new RadialDot(6) ) );
			addInitializer( new ColorsInit( new Array(0x444444, 0x666666, 0x888888, 0xAAAAAA, 0xCCCCCC) ) );
			
			// Particle's Behavior
			addInitializer( new Lifetime( 2, 3 ) );
			addInitializer( new Velocity( new DiscSectorZone(new Point(0, 0), 40, 30, -4 * Math.PI / 7, -3 * Math.PI / 7) ) );
			addAction( new Age(Quadratic.easeOut) );
			addAction( new Fade(0.25, 0) );
			addAction( new Move() );
			// Make the particles move hazardously instead of moving straight forward
			addAction( new RandomDrift(15, 15) );
		}
	}
}