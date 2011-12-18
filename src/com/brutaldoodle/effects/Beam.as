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
	import com.pblabs.engine.debug.Logger;
	
	import flash.geom.Point;
	
	import org.flintparticles.common.actions.ColorChange;
	import org.flintparticles.common.actions.TargetColor;
	import org.flintparticles.common.counters.Steady;
	import org.flintparticles.common.counters.TimePeriod;
	import org.flintparticles.common.displayObjects.RadialDot;
	import org.flintparticles.common.events.ParticleEvent;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.common.utils.Maths;
	import org.flintparticles.twoD.actions.Accelerate;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.ScaleAllInit;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.zones.DiscSectorZone;
	import org.flintparticles.twoD.zones.PointZone;
	import org.flintparticles.twoD.zones.RectangleZone;
	
	public class Beam extends PlayerCollidableEmitter
	{		
		public function Beam()
		{
			super();
			
			_damageAmount = 10;
			
			//Start a TimePeriod emitter
			counter = new TimePeriod(100, 0.5);
			
			//set the visual
			addInitializer( new SharedImage(new RadialDot(20,0xf2797c,"screen") ) );
			
			//set the velocity
			addInitializer( new Velocity( new PointZone( new Point(0, 400) ) ) );
			
			//set position
			addInitializer( new Position( new RectangleZone(10,10,-10,10 ) ) );
			
			//set scale
			addInitializer( new ScaleAllInit( 0.6 , 1.4 ) );
			
			addAction( new Accelerate( 0 , 100 ) );
			addAction( new Move() );
		}
	}
}