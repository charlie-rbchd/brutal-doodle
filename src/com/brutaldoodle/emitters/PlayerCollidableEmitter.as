package com.brutaldoodle.emitters
{
	import com.brutaldoodle.collisions.CollisionManager;
	import com.brutaldoodle.collisions.CollisionType;
	import com.brutaldoodle.components.BoundingBoxComponent;
	
	import org.flintparticles.common.events.ParticleEvent;
	import org.flintparticles.twoD.actions.CollisionZone;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.zones.Zone2D;
	
	public class PlayerCollidableEmitter extends Emitter2D
	{
		public function PlayerCollidableEmitter()
		{
			super();
			
			var players:Vector.<Zone2D> = CollisionManager.instance.getCollidableObjectsByType(CollisionType.PLAYER);
			
			for (var i:int = 0; i < players.length; ++i) {
				if (players[i] != null)
					addAction( new CollisionZone(players[i], 0) );
			}
			
			this.addEventListener(ParticleEvent.ZONE_COLLISION, onCollide);
		}
		
		protected function onCollide(event:ParticleEvent):void
		{
			event.particle.isDead = true;
		}
	}
}