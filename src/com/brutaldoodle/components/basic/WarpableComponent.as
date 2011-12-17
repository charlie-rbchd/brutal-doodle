package com.brutaldoodle.components.basic
{
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;
	
	import org.flintparticles.common.utils.WeightedArray;
	
	public class WarpableComponent extends EntityComponent
	{
		public var priority:int; 
		private static var _warpableUnits:Vector.<IEntity> = new Vector.<IEntity>;
		private static var _weights:WeightedArray = new WeightedArray();
		
		public function WarpableComponent()
		{
			super();
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			_warpableUnits.push(this.owner);
			_weights.add(this.owner, priority);
		}
		
		override protected function onRemove():void
		{
			super.onRemove();
			var index:int = _warpableUnits.indexOf(this.owner);
			if (index != -1) {
				_warpableUnits.splice(index, 1);
				_weights.removeAt(index);
			}
		}
		
		public static function get priorityWeights():WeightedArray {
			return _weights;
		}
	}
}