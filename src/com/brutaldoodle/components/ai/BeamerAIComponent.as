package com.brutaldoodle.components.ai
{
	import com.brutaldoodle.components.animations.TurnToRedComponent;
	import com.brutaldoodle.entities.Projectile;
	import com.brutaldoodle.rendering.BeamRenderer;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.debug.Logger;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class BeamerAIComponent extends SimpleAIComponent
	{
		public function BeamerAIComponent()
		{
			super();
		}
		
		override protected function think():void {
			super.think();
			
			//make the invader turn red
			var filter:TurnToRedComponent = new TurnToRedComponent();
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