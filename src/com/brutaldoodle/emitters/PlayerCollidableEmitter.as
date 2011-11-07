package com.brutaldoodle.emitters
{
	import com.brutaldoodle.collisions.CollisionManager;
	import com.brutaldoodle.collisions.CollisionType;
	import com.brutaldoodle.components.collisions.BoundingBoxComponent;
	import com.brutaldoodle.effects.Coin;
	import com.pblabs.components.basic.HealthComponent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.IEntity;
	
	import org.flintparticles.common.events.ParticleEvent;
	import org.flintparticles.twoD.particles.Particle2D;
	
	public class PlayerCollidableEmitter extends CollidableEmitter
	{
		public function PlayerCollidableEmitter()
		{
			super();
		}
		
		protected override function onCollide (event:ParticleEvent):void {
			super.onCollide(event);
			event.particle.isDead = true;
			
			if (_damageAmount == 0) {
				// update the amount of coins if its a coin that collided with the player
			}
			
			var owner:IEntity = (event.otherObject as BoundingBoxComponent).owner;
			
			if (owner != null) {
				var health:HealthComponent = owner.lookupComponentByName("Health") as HealthComponent;
				health.damage(_damageAmount);
				
				if (health.isDead) {
					PBE.lookup("Canon").destroy();
					CollisionManager.instance.stopCollisionsWith(event.otherObject, CollisionType.PLAYER);
				}
			}
		}
	}
}