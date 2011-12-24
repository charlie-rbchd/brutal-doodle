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
	import com.brutaldoodle.emitters.CollidableEmitter;
	import com.brutaldoodle.emitters.PlayerCollidableEmitter;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.resource.ImageResource;
	
	import flash.geom.Point;
	
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.initializers.CollisionRadiusInit;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.zones.PointZone;
	
	/*
	 * Contain the definition of the look and behavior of the Coin particle emitter
	 * The particles emitted are to collide with any "player" bounding box registered within the CollisionManager
	 */
	public class Coin extends PlayerCollidableEmitter
	{
		public function Coin() {
			super();
			
			// The amount of damage dealt by each particle emitted
			// In this case, it represents the amount of money the coin holds
			_damageAmount = 12;
			
			// The money count will be updated after the collision
			_actionOnCollision = CollidableEmitter.UPDATE_MONEY_COUNT;
			
			// One particle is instantly emitted
			counter = new Blast(1);
			
			// Particle's Appearance
			var coin:ImageResource = PBE.resourceManager.load("../assets/Images/Coin.png", ImageResource) as ImageResource;
			addInitializer( new SharedImage( coin.image ) );
			addInitializer( new Position( new PointZone( new Point(10, 0) ) ) );
			
			// Particle's Behavior
			addInitializer( new CollisionRadiusInit(21) );
			addInitializer( new Velocity( new PointZone( new Point(0, 85) ) ) );
			addAction( new Move() );
		}
	}
}