package com.brutaldoodle.components.basic
{
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;
	
	import org.flintparticles.common.utils.WeightedArray;
	
	public class WarpableComponent extends EntityComponent
	{
		public var priority:int; 
		public static var isWarpable:Vector.<IEntity> = new Vector.<IEntity>;
		public static var isWarpablePriority:WeightedArray = new WeightedArray();
		
		public function WarpableComponent()
		{
			super();
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			
			isWarpable.push(this.owner);
			isWarpablePriority.add(this.owner, priority);
		}
		
		override protected function onRemove():void
		{
			super.onRemove();
			
			var index:int = isWarpable.indexOf(this.owner);
			if (index != -1) {
				isWarpable.splice(index, 1);
				isWarpablePriority.removeAt(index);
			}
		}
	}
}