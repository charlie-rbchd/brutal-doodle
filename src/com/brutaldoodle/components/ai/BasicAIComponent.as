package com.brutaldoodle.components.ai
{
	import com.brutaldoodle.entities.Projectile;
	import com.brutaldoodle.rendering.SimpleShotRenderer;

	public class BasicAIComponent extends SimpleAIComponent
	{
		public function BasicAIComponent() {
			super();
		}
		
		override protected function think():void {
			super.think();
			// shot a projectile rendered by SimpleShotRenderer
			var p:Projectile = new Projectile(SimpleShotRenderer, owner);
		}	
	}
}