package com.brutaldoodle.components.ai
{
	import com.brutaldoodle.utils.Interval;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.EntityComponent;
	
	public class SimpleAIComponent extends EntityComponent
	{
		public var timeBetweenThinks:Interval;
		
		
		public function SimpleAIComponent()
		{
			super();
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			
			PBE.processManager.schedule(timeBetweenThinks.getTime(), owner, think);
		}
		
		protected function think():void
		{
			PBE.processManager.schedule(timeBetweenThinks.getTime(), owner, think);
		}
	}
}