package com.brutaldoodle.emitters
{
	import com.brutaldoodle.components.BoundingBoxComponent;
	
	import org.flintparticles.common.events.ParticleEvent;
	import org.flintparticles.twoD.actions.CollisionZone;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.zones.RectangleZone;
	
	public class EnemyCollidableEmitter extends Emitter2D
	{
		public function EnemyCollidableEmitter()
		{
			super();
			
			var enemies:Vector.<RectangleZone> = BoundingBoxComponent.boundingBoxes.enemy;
			
			for (var i:int = 0; i < enemies.length; ++i) {
				addAction( new CollisionZone(enemies[i], 0) );
			}
			
			this.addEventListener(ParticleEvent.ZONE_COLLISION, onCollide);
		}
		
		protected function onCollide(event:ParticleEvent):void
		{
			event.particle.isDead = true;
		}		
		
	}
}