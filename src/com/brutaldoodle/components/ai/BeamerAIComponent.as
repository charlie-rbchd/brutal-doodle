package com.brutaldoodle.components.ai
{
	import com.brutaldoodle.components.animations.TurnToRedComponent;
	import com.brutaldoodle.entities.Projectile;
	import com.brutaldoodle.rendering.BeamRenderer;
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
			if(owner != null)
				owner.addComponent(filter,"TurnRed");
			
			//create a timer of about the same time it take for the invader to turn red(about one second)
			var timer:Timer = new Timer(1000, 2);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, makeBeam);
			timer.start();
		}	
		
		private function makeBeam(pEvt:TimerEvent):void{
			// shot a projectile rendered by SimpleShotRenderer
			var p:Projectile = new Projectile(BeamRenderer, owner);
		}
	}
}