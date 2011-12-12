package com.brutaldoodle.components.ai
{
	import com.brutaldoodle.entities.Projectile;
	import com.brutaldoodle.rendering.HazardousShotRenderer;

	public class ButterflyAIComponent extends SimpleAIComponent
	{
		public function ButterflyAIComponent()
		{
			super();
		}
		
		override protected function think():void
		{
			// TODO Auto Generated method stub
			super.think();
			var p:Projectile = new Projectile(HazardousShotRenderer, owner);
		}
	}
}