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

package com.brutaldoodle.emitters
{
	import com.brutaldoodle.collisions.CollisionManager;
	import com.brutaldoodle.collisions.CollisionType;
	import com.brutaldoodle.components.basic.HealthComponent;
	import com.brutaldoodle.components.collisions.BoundingBoxComponent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.IEntity;
	
	import org.flintparticles.common.events.ParticleEvent;
	
	public class EnemyCollidableEmitter extends CollidableEmitter
	{
		public function EnemyCollidableEmitter() {
			super();
		}
		
		protected override function onCollide (event:ParticleEvent):void {
			super.onCollide(event);
			
			var owner:IEntity = (event.otherObject as BoundingBoxComponent).owner;
			
			if (owner != null) {
				var health:HealthComponent = owner.lookupComponentByName("Health") as HealthComponent;
				if (health != null) {
					health.damage(_damageAmount, "normal");
					
					
					if (health.isDead) {
						PBE.soundManager.play("../assets/Sounds/EnemyDead.mp3");
						CollisionManager.instance.stopCollisionsWith(event.otherObject, CollisionType.ENEMY);
					} else {
						PBE.soundManager.play("../assets/Sounds/EnemyHit.mp3");
					}
				}
			}
		}
	}
}