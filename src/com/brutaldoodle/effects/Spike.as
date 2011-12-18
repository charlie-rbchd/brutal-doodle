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
	import com.brutaldoodle.emitters.EnemyCollidableEmitter;
	
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.initializers.CollisionRadiusInit;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.zones.PointZone;
	
	public class Spike extends EnemyCollidableEmitter
	{
		[Embed(source="assets/Images/Spike.png")]
		private var SpikeAsset:Class;
				
		public function Spike()
		{
			super();
			
			_damageAmount = 1;
			
			//give the image to the particle
			var spike:Bitmap = new SpikeAsset();
			addInitializer( new SharedImage( spike ) );
			
			//Generate one particle
			counter = new Blast(1);
			
			addInitializer( new CollisionRadiusInit(0.01) );
			
			//This var is set to a random value of -1 or 1;
			var direction:int = Math.floor(Math.random() * 2) ? 1 : -1;
			//position and velocity of the particle. 
			addInitializer( new Velocity( new PointZone( new Point(direction * 10, 0) ) ) );
			//We want to spawn the particle on the good side to avoid collision with the owner.
			addInitializer( new Position( new PointZone( new Point(direction * 30, 0) ) ) );
			
			addAction( new Move() );
		}
	}
}