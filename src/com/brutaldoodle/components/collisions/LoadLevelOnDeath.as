package com.brutaldoodle.components.collisions
{
	import com.brutaldoodle.collisions.CollisionManager;
	import com.pblabs.engine.core.LevelManager;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;
	
	public class LoadLevelOnDeath extends EntityComponent
	{
		private static var units:Vector.<IEntity> = new Vector.<IEntity>();
		public var level:int;
		
		public function LoadLevelOnDeath() {
			super();
		}
		
		override protected function onAdd():void {
			super.onAdd();
			units.push(owner);
		}
		
		// load a level once all the units have been killed,
		// used to load the next stage of the tutorial
		override protected function onRemove():void {
			super.onRemove();
			units.splice(units.indexOf(owner), 1);
			if (!units.length) {
				Main.resetEverythingAndLoadLevel(level);
			}
		}
	}
}