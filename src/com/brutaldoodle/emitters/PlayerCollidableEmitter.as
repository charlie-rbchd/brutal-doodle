package com.brutaldoodle.emitters
{
	import com.brutaldoodle.collisions.CollisionManager;
	import com.brutaldoodle.collisions.CollisionType;
	import com.brutaldoodle.components.BoundingBoxComponent;
	import com.pblabs.components.basic.HealthComponent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.IEntity;
	
	import org.flintparticles.common.events.ParticleEvent;
	
	public class PlayerCollidableEmitter extends CollidableEmitter
	{
		public function PlayerCollidableEmitter()
		{
			super();
		}
		
		protected override function onCollide (event:ParticleEvent):void {
			if (event.otherObject != null) {
				event.particle.isDead = true;
				
				var owner:IEntity = (event.otherObject as BoundingBoxComponent).owner;
				var health:HealthComponent = owner.lookupComponentByName("Health") as HealthComponent;
				
				if (health.isDead) {
					PBE.lookup("Canon").destroy();
					CollisionManager.instance.stopCollisionsWith(event.otherObject, CollisionType.ENEMY);
				}
			}
		}
	}
}