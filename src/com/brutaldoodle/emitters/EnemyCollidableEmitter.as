package com.brutaldoodle.emitters
{
	import com.brutaldoodle.collisions.CollisionManager;
	import com.brutaldoodle.collisions.CollisionType;
	import com.brutaldoodle.components.BoundingBoxComponent;
	import com.brutaldoodle.events.CollisionEvent;
	
	import mx.utils.ObjectUtil;
	
	import org.flintparticles.common.actions.Action;
	import org.flintparticles.common.events.ParticleEvent;
	import org.flintparticles.common.utils.FrameUpdater;
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
					addAction( new CollisionZone (enemies[i], 0) );
				}	
			}
			
			CollisionManager.instance.addEventListener(CollisionEvent.ZONE_UNREGISTERED, onZoneUnregistered);
			addEventListener(ParticleEvent.ZONE_COLLISION, onCollide);
		}
		
		protected function onZoneUnregistered(event:CollisionEvent):void
		{
			for (var i:int = actions.length - 1; i >= 0; i--) {
				var current:Action = actions[i];
				
				if (current is CollisionZone) {
					if ( ObjectUtil.compare((current as CollisionZone).zone, event.zone) )  {
						//useInternalTick = false;
						//removeAction(current);
						return;
					}
				}
			}
		}
		
		protected function onCollide(event:ParticleEvent):void
		{
			try {
				(event.otherObject as BoundingBoxComponent).owner.destroy();
				CollisionManager.instance.stopCollisionsWith(event.otherObject, CollisionType.ENEMY);
				event.particle.isDead = true;
			} catch (err:Error) {
				
			}
		}
	}
}