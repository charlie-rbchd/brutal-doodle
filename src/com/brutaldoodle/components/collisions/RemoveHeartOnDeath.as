package com.brutaldoodle.components.collisions
{
	import com.brutaldoodle.collisions.CollisionManager;
	import com.brutaldoodle.collisions.CollisionType;
	import com.brutaldoodle.components.basic.HealthComponent;
	import com.pblabs.components.basic.HealthEvent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.core.LevelEvent;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.rendering2D.SpriteRenderer;
	
	public class RemoveHeartOnDeath extends EntityComponent
	{
		public static var life:int;
		private var _hearts:Vector.<IEntity>;
		
		public function RemoveHeartOnDeath() {
			super();
		}
		
		override protected function onAdd():void {
			super.onAdd();
			_hearts = new Vector.<IEntity>;
			PBE.levelManager.addEventListener(LevelEvent.LEVEL_LOADED_EVENT, registerHearts);
			owner.eventDispatcher.addEventListener(HealthEvent.DIED, removeHeart);
		}
		
		// wait until the whole level is loaded before registering the hearts to the static vector
		private function registerHearts(event:LevelEvent):void {
			PBE.levelManager.removeEventListener(LevelEvent.LEVEL_LOADED_EVENT, registerHearts);
			var heart:IEntity, i:int = 1;
			
			while ( heart = PBE.lookup("Heart"+i) as IEntity ) {
				if (i <= RemoveHeartOnDeath.life)
					_hearts.push(heart);
				else
					heart.destroy();
				
				i++;
			}
		}
		
		override protected function onRemove():void {
			super.onRemove();
			owner.eventDispatcher.removeEventListener(HealthEvent.DIED, removeHeart);
		}
		
		// when the played dies, a heart is removed
		private function removeHeart (event:HealthEvent):void {
			var length:int = _hearts.length
			if (length) {
				// remove a heart if there's one or more remaining
				_hearts[length-1].destroy();
				_hearts.pop();
				RemoveHeartOnDeath.life--;
				// heal the player to max life once a heart has been removed
				var healthComponent:HealthComponent = owner.lookupComponentByName("Health") as HealthComponent;
				healthComponent.heal(healthComponent.maxHealth);
			} else {
				// if there's no more heart, the player just died...
				
				// remove collisions with the player
				CollisionManager.instance.stopCollisionsWith(owner.lookupComponentByName("Collisions") as BoundingBoxComponent, CollisionType.PLAYER);
				
				// kill the player
				owner.destroy();
				PBE.lookup("Canon").destroy();
				
				// display the game over screen
				(PBE.lookupComponentByName("GameOverScreen", "Render") as SpriteRenderer).alpha = 1;
			}
		}
	}
}