package com.brutaldoodle.components.collisions
{
	import com.pblabs.components.basic.HealthEvent;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.rendering2D.SpriteSheetRenderer;
	
	public class DestroyOnAllDead extends EntityComponent
	{
		private static var _units:Vector.<IEntity> = new Vector.<IEntity>();
		private static var _deadCount:int = 0;
		
		public function DestroyOnAllDead()
		{
			super();
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			_units.push(owner);
			owner.eventDispatcher.addEventListener(HealthEvent.DIED, onDeath);
		}
		
		override protected function onRemove():void
		{
			super.onRemove();
			owner.eventDispatcher.removeEventListener(HealthEvent.DIED, onDeath);
		}
		
		private function onDeath (event:HealthEvent):void {
			if (++_deadCount == _units.length) {
				while ( _units.length) {
					_units.shift().destroy();
				}
			} else {
				var renderer:SpriteSheetRenderer = owner.lookupComponentByName("Render") as SpriteSheetRenderer;
				renderer.alpha = 0.5;
			}
		}
		
	}
}