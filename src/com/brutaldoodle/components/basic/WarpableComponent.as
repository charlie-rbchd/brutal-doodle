package com.brutaldoodle.components.basic
{
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;
	
	import org.flintparticles.common.utils.WeightedArray;
	
	public class WarpableComponent extends EntityComponent
	{
		public var priority:int; 
		private static var _weights:WeightedArray = new WeightedArray();
		
		public function WarpableComponent()
		{
			super();
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			_weights.add(owner, priority);
		}
		
		override protected function onRemove():void
		{
			super.onRemove();
			_weights.remove(owner);
		}
		
		public static function get priorityWeights():WeightedArray {
			return _weights;
		}
	}
}