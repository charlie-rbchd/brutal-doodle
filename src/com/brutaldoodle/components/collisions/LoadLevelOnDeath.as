package com.brutaldoodle.components.collisions
{
	import com.pblabs.engine.core.LevelManager;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;
	
	public class LoadLevelOnDeath extends EntityComponent
	{
		private static var units:Vector.<IEntity> = new Vector.<IEntity>();
		public var level:int;
		
		public function LoadLevelOnDeath()
		{
			super();
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			units.push(owner);
		}
		
		override protected function onRemove():void
		{
			super.onRemove();
			units.splice(units.indexOf(owner), 1);
			if (!units.length) LevelManager.instance.loadLevel(level, true);
		}
	}
}