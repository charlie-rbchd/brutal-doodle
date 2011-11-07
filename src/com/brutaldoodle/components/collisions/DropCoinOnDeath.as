package com.brutaldoodle.components.collisions
{
	import com.brutaldoodle.rendering.CoinRenderer;
	import com.brutaldoodle.entities.Projectile;
	import com.pblabs.components.basic.HealthEvent;
	import com.pblabs.engine.entity.EntityComponent;
	
	public class DropCoinOnDeath extends EntityComponent
	{
		public function DropCoinOnDeath()
		{
			super();
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			owner.eventDispatcher.addEventListener(HealthEvent.DIED, onDeath);
		}
		
		override protected function onRemove():void
		{
			super.onRemove();
			owner.eventDispatcher.removeEventListener(HealthEvent.DIED, onDeath);
		}
		
		private function onDeath (event:HealthEvent):void {
			var p:Projectile = new Projectile(CoinRenderer, owner);
		}
	}
}