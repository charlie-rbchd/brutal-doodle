package com.brutaldoodle.emitters
{
	import com.brutaldoodle.components.BoundingBoxComponent;
	
	import flash.events.Event;
	
	import org.flintparticles.common.events.ParticleEvent;
	import org.flintparticles.twoD.actions.CollisionZone;
	import org.flintparticles.twoD.emitters.Emitter2D;
	
	public class PlayerCollidableEmitter extends Emitter2D
	{
		public function PlayerCollidableEmitter()
		{
			super();
			
			addAction( new CollisionZone(BoundingBoxComponent.boundingBoxes.player, 0) );
			this.addEventListener(ParticleEvent.ZONE_COLLISION, onCollide);
		}
		
		protected function onCollide(event:ParticleEvent):void
		{
			event.particle.isDead = true;
		}
	}
}