package com.brutaldoodle.emitters
{
	import com.brutaldoodle.components.basic.HealthComponent;
	import com.brutaldoodle.components.basic.MoneyComponent;
	import com.brutaldoodle.components.collisions.BoundingBoxComponent;
	import com.brutaldoodle.components.collisions.DropCoinOnDeath;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.rendering2D.DisplayObjectRenderer;
	
	import flash.text.TextField;
	
	import org.flintparticles.common.events.ParticleEvent;
	
	public class PlayerCollidableEmitter extends CollidableEmitter
	{
		public function PlayerCollidableEmitter() {
			super();
		}
		
		protected override function onCollide (event:ParticleEvent):void {
			super.onCollide(event);
			
			switch (_actionOnCollision) {
				case CollidableEmitter.UPDATE_MONEY_COUNT:
					var money:MoneyComponent = PBE.lookupComponentByName("AmountOfCoins", "Money") as MoneyComponent;
					
					if (money != null) {
						money.addCoins(_damageAmount);
					}
					break;
				case CollidableEmitter.DEAL_DAMAGE:				
					var owner:IEntity = (event.otherObject as BoundingBoxComponent).owner;
					
					if (owner != null) {
						var health:HealthComponent = owner.lookupComponentByName("Health") as HealthComponent;
						if (health != null) {
							health.damage(_damageAmount);
						}
					}
					break;
				default:
					throw new Error("_actionOnCollision must be a String defined by one of the CollidableEmitter class constants");
			}	
		}
	}
}