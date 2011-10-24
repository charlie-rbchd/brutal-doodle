package com.brutaldoodle.emitters
{
	import com.brutaldoodle.collisions.CollisionManager;
	import com.brutaldoodle.collisions.CollisionType;
	import com.brutaldoodle.components.BoundingBoxComponent;
	
	import org.flintparticles.common.events.ParticleEvent;
	import org.flintparticles.twoD.actions.CollisionZone;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.zones.Zone2D;
	
	public class EnemyCollidableEmitter extends Emitter2D
	{
		public function EnemyCollidableEmitter()
		{
			super();
			
			var enemies:Vector.<Zone2D> = CollisionManager.instance.getCollidableObjectsByType(CollisionType.ENEMY);
			
			for (var i:int = 0; i < enemies.length; ++i) {
				if (enemies[i] != null) {
					addAction( new CollisionZone(enemies[i], 0) );
				}	
			}
			
			addEventListener(ParticleEvent.ZONE_COLLISION, onCollide);
		}
		
		protected function onCollide(event:ParticleEvent):void
		{
			if (event.otherObject != null) {
				(event.otherObject as BoundingBoxComponent).owner.destroy();
				event.particle.isDead = true;
				CollisionManager.instance.stopCollisionsWith(event.otherObject, CollisionType.ENEMY);
			}
		}
	}
}