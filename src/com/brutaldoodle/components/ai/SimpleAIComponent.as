package com.brutaldoodle.components.ai
{
	import com.brutaldoodle.utils.Interval;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.EntityComponent;
	
	public class SimpleAIComponent extends EntityComponent
	{
		public var timeBetweenThinks:Interval;
		public var isThinking:Boolean;
		
		public function SimpleAIComponent() {
			super();
			isThinking = true;
		}
		
		override protected function onAdd():void {
			super.onAdd();
			
			// first schedule for AI check
			if (isThinking) {
				PBE.processManager.schedule(timeBetweenThinks.getTime(), owner, think);
			}
		}
		
		// this function is to be overriden in any child class
		// (specific AI actions are executed here)
		protected function think():void {
			if (isThinking) {
				PBE.processManager.schedule(timeBetweenThinks.getTime(), owner, think);
			}
		}
	}
}