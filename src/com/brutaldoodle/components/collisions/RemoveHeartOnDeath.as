package com.brutaldoodle.components.collisions
{
	import com.brutaldoodle.collisions.CollisionManager;
	import com.brutaldoodle.collisions.CollisionType;
	import com.brutaldoodle.components.basic.HealthComponent;
	import com.pblabs.components.basic.HealthEvent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.core.LevelEvent;
	import com.pblabs.engine.core.TemplateManager;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.rendering2D.SpriteRenderer;
	
	public class RemoveHeartOnDeath extends EntityComponent
	{
		private var _hearts:Vector.<IEntity>;
		
		public function RemoveHeartOnDeath()
		{
			super();
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			_hearts = new Vector.<IEntity>;
			PBE.levelManager.addEventListener(LevelEvent.LEVEL_LOADED_EVENT, registerHearts);
			owner.eventDispatcher.addEventListener(HealthEvent.DIED, removeHeart);
		}
		
		private function registerHearts(event:LevelEvent):void
		{
			PBE.levelManager.removeEventListener(LevelEvent.LEVEL_LOADED_EVENT, registerHearts);
			var heart:IEntity, i:int = 1;
			
			while (heart = PBE.lookup("Heart"+i) as IEntity) {
				_hearts.push(heart);
				i++;
			}
		}
		
		override protected function onRemove():void
		{
			super.onRemove();
			owner.eventDispatcher.removeEventListener(HealthEvent.DIED, removeHeart);
		}
		
		private function removeHeart (event:HealthEvent):void {
			var length:int = _hearts.length
			if (length) {
				_hearts[length-1].destroy();
				_hearts.pop();
				var healthComponent:HealthComponent = owner.lookupComponentByName("Health") as HealthComponent;
				healthComponent.heal(healthComponent.maxHealth);
			} else {
				CollisionManager.instance.stopCollisionsWith(owner.lookupComponentByName("Collisions") as BoundingBoxComponent, CollisionType.PLAYER);
				owner.destroy();
				PBE.lookup("Canon").destroy();
				(PBE.lookupComponentByName("GameOverScreen", "Render") as SpriteRenderer).alpha = 1;
			}
		}
	}
}