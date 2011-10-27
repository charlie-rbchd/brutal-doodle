package com.brutaldoodle.components
{
	import com.brutaldoodle.collisions.CollisionManager;
	import com.brutaldoodle.events.CollisionEvent;
	import com.pblabs.engine.core.LevelManager;
	import com.pblabs.engine.entity.EntityComponent;
	
	public class LoadLevelOnCollision extends EntityComponent
	{
		public var level:int = 0;
		
		public function LoadLevelOnCollision()
		{
			super();
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			CollisionManager.instance.addEventListener(CollisionEvent.COLLISION_OCCURED, loadLevel);
		}
		
		override protected function onRemove():void
		{
			super.onRemove();
			CollisionManager.instance.removeEventListener(CollisionEvent.COLLISION_OCCURED, loadLevel);
		}
		
		
		protected function loadLevel(event:CollisionEvent):void
		{
			LevelManager.instance.loadLevel(level, true);
		}
	}
}