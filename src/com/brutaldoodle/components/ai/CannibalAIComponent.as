package com.brutaldoodle.components.ai
{
	import com.brutaldoodle.entities.Projectile;
	import com.brutaldoodle.rendering.SpikeRenderer;
	
	public class CannibalAIComponent extends SimpleAIComponent
	{
		public function CannibalAIComponent()
		{
			super();
		}
		
		override protected function think():void {
			super.think();
			// shot a projectile rendered by SimpleShotRenderer
			var p:Projectile = new Projectile(SpikeRenderer, owner);
		}	
	}
}