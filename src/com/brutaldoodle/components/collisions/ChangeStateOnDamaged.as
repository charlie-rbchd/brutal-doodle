package com.brutaldoodle.components.collisions
{
	import com.pblabs.animation.AnimationEvent;
	import com.pblabs.animation.Animator;
	import com.pblabs.animation.AnimatorComponent;
	import com.pblabs.animation.AnimatorType;
	import com.pblabs.components.basic.HealthEvent;
	import com.pblabs.engine.entity.EntityComponent;
	
	public class ChangeStateOnDamaged extends EntityComponent
	{
		private var __currentState:String;
		private var _currentAnimation:Animator;
		private var _animator:AnimatorComponent;
		
		public function ChangeStateOnDamaged()
		{
			super();
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			owner.eventDispatcher.addEventListener(HealthEvent.DAMAGED, onDamaged);
			_animator = owner.lookupComponentByName("Animator") as AnimatorComponent;
			_currentState = "notInjured";
		}
		
		
		private function onDamaged (event:HealthEvent):void {
			var remainingLife:Number = event.amount;
			
			if (remainingLife > 75)
			{
				return;
			}
			
			var startFrame:Number = _currentAnimation.currentValue + 9;
			
			if (remainingLife <= 25)
			{
				_currentState = "badlyInjured";
			}
			else if (remainingLife <= 50)
			{
				_currentState = "injured";
			}
			else if (remainingLife <= 75)
			{
				_currentState = "barelyInjured";
			}
			
			_animator.play(_currentState, startFrame);
			_currentAnimation.duration = (_currentAnimation.duration / 9) * (9 - startFrame % 9);
			_currentAnimation.addEventListener(AnimationEvent.ANIMATION_REPEATED_EVENT, onRepeat);
		}
		
		protected function onRepeat(event:AnimationEvent):void
		{
			_currentAnimation.removeEventListener(AnimationEvent.ANIMATION_REPEATED_EVENT, onRepeat);
			_currentAnimation.start(_currentAnimation.targetValue - 9, _currentAnimation.targetValue, 4, AnimatorType.LOOP_ANIMATION, -1);
		}
		
		private function set _currentState (value:String):void {
			__currentState = value;
			_currentAnimation = _animator.animations[_currentState] as Animator;
		}
		
		private function get _currentState ():String {
			return __currentState;
		}
	}
}