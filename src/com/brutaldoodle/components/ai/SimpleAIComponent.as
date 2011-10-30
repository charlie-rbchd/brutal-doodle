package com.brutaldoodle.components.ai
{
	import com.brutaldoodle.utils.Interval;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.EntityComponent;
	
	public class SimpleAIComponent extends EntityComponent
	{
		public var timeBetweenThinks:Interval;
		public var isThinking:Boolean;
		
		public function SimpleAIComponent()
		{
			super();
			isThinking = true;
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			
			if (isThinking) {
				PBE.processManager.schedule(timeBetweenThinks.getTime(), owner, think);
			}
		}
		
		protected function think():void
		{
			if (isThinking) {
				PBE.processManager.schedule(timeBetweenThinks.getTime(), owner, think);
			}
		}
	}
}