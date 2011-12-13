package com.brutaldoodle.components.ai
{
	import com.brutaldoodle.components.animations.TurnToColorComponent;
	import com.brutaldoodle.entities.Projectile;
	import com.brutaldoodle.rendering.BeamRenderer;
	import com.pblabs.engine.PBE;
	
	public class BeamerAIComponent extends SimpleAIComponent
	{
		public function BeamerAIComponent()
		{
			super();
		}
		
		override protected function think():void {
			super.think();
			
			//make the invader turn red
			var filter:TurnToColorComponent = new TurnToColorComponent();
			filter.color = TurnToColorComponent.COLOR_RED;
			filter.rate = 0.016;
			if (owner != null) {
				owner.addComponent(filter, "TurnRed");
			}
			
			// wait for the invader to turn red (about two seconds)
			PBE.processManager.schedule(2000, this, createBeam);
		}	
		
		private function createBeam():void {
			// shot a projectile rendered by SimpleShotRenderer
			var p:Projectile = new Projectile(BeamRenderer, owner);
		}
	}
}