package com.brutaldoodle.components
{
	import com.pblabs.animation.Animator;
	import com.pblabs.animation.AnimatorComponent;
	import com.pblabs.components.basic.HealthEvent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityComponent;
	
	public class ChangeStateOnDamaged extends EntityComponent
	{
		private var _currentState:String;
		
		public function ChangeStateOnDamaged()
		{
			super();
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			owner.eventDispatcher.addEventListener(HealthEvent.DAMAGED, onDamaged);
		}
		
		
		private function onDamaged (event:HealthEvent):void {
			var animator:AnimatorComponent = owner.lookupComponentByName("Animator") as AnimatorComponent;
			var remainingLife:Number = event.amount;
			
			if (remainingLife > 75)
			{
				return;
			}
			else if (remainingLife <= 25)
			{
				animator.play("badlyInjured");
			}
			else if (remainingLife <= 50)
			{
				animator.play("injured");
			}
			else if (remainingLife <= 75)
			{
				animator.play("barelyInjured");
			}
		}
	}
}