package com.brutaldoodle.emitters
{
	import com.brutaldoodle.collisions.CollisionManager;
	import com.brutaldoodle.collisions.CollisionType;
	import com.brutaldoodle.components.basic.HealthComponent;
	import com.brutaldoodle.components.collisions.BoundingBoxComponent;
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
						CollisionManager.instance.stopCollisionsWith(event.otherObject, CollisionType.ENEMY);
					}
				}
			}
		}
	}
}