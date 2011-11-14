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
	import com.pblabs.rendering2D.DisplayObjectRenderer;
	
	import flash.text.TextField;
	
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
			
			switch(_actionOnCollision){
				
				case CollidableEmitter.UPDATE_MONEY_COUNT:
					var coins:TextField = (PBE.lookupComponentByName("AmountOfCoins", "Render") as DisplayObjectRenderer).displayObject as TextField;
					coins.text = String(int(coins.text)+_damageAmount);
					
					break;
				case CollidableEmitter.DEAL_DAMAGE:				
					var owner:IEntity = (event.otherObject as BoundingBoxComponent).owner;
					
					if (owner != null) {
						var health:HealthComponent = owner.lookupComponentByName("Health") as HealthComponent;
						health.damage(_damageAmount);
						/*
						if (health.isDead) {
							PBE.lookup("Canon").destroy();
							CollisionManager.instance.stopCollisionsWith(event.otherObject, CollisionType.PLAYER);
						}
						*/
					}
					break;
				default:
					throw new Error("maudit attarder(jpense que jo yer mad)");
			
			}
			
		}
	}
}