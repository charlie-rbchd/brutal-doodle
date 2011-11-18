package com.brutaldoodle.components.collisions
{
	import com.brutaldoodle.entities.Projectile;
	import com.brutaldoodle.rendering.BloodDropRenderer;
	import com.pblabs.components.basic.HealthEvent;
	import com.pblabs.engine.entity.EntityComponent;
	
	public class DropBloodOnDamaged extends EntityComponent
	{
		public function DropBloodOnDamaged() {
			super();
		}
		
		override protected function onAdd():void {
			super.onAdd();
			owner.eventDispatcher.addEventListener(HealthEvent.DAMAGED, onDamaged);
		}
		
		override protected function onRemove():void {
			super.onRemove();
			owner.eventDispatcher.removeEventListener(HealthEvent.DAMAGED, onDamaged);
		}
		
		// drop blood when the owner is damaged, there's not much to it...
		private function onDamaged (event:HealthEvent):void {
			var p:Projectile = new Projectile(BloodDropRenderer, owner);
		}
	}
}