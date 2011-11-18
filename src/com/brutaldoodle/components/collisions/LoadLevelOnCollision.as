package com.brutaldoodle.components.collisions
{
	import com.brutaldoodle.collisions.CollisionManager;
	import com.brutaldoodle.collisions.CollisionType;
	import com.brutaldoodle.events.CollisionEvent;
	import com.pblabs.engine.core.LevelManager;
	import com.pblabs.engine.entity.EntityComponent;
	
	public class LoadLevelOnCollision extends EntityComponent
	{
		public var level:int = 0;
		
		public function LoadLevelOnCollision() {
			super();
		}
		
		override protected function onAdd():void {
			super.onAdd();
			CollisionManager.instance.addEventListener(CollisionEvent.COLLISION_OCCURED, loadLevel);
		}
		
		override protected function onRemove():void {
			super.onRemove();
			CollisionManager.instance.stopCollisionsWith(owner.lookupComponentByName("Collisions") as BoundingBoxComponent, CollisionType.ENEMY);
			CollisionManager.instance.removeEventListener(CollisionEvent.COLLISION_OCCURED, loadLevel);
		}
		
		// load a level once a collision has occured with the owner
		// used to load a level when an object collide with a menu element
		private function loadLevel(event:CollisionEvent):void {
			if (owner != null) {
				if (event.zone == owner.lookupComponentByName("Collisions")) {
					CollisionManager.instance.reset();
					LevelManager.instance.loadLevel(level, true);
				}
			}
		}
	}
}