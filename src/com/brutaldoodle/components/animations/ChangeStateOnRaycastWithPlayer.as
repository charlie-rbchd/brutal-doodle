package com.brutaldoodle.components.animations
{
	import com.pblabs.animation.AnimatorComponent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import flash.geom.Point;
	
	public class ChangeStateOnRaycastWithPlayer extends TickedComponent {
		public var positionProperty:PropertyReference;
		public var sizeProperty:PropertyReference;
		
		private var _isAnimating:Boolean;
		
		public function ChangeStateOnRaycastWithPlayer() {
			super();
			_isAnimating = false;
		}
		
		override public function onTick(deltaTime:Number):void {
			super.onTick(deltaTime);
			
			var tankPosition:Point = (PBE.lookupComponentByName("Player", "Spatial") as SimpleSpatialComponent).position
			var animator:AnimatorComponent = owner.lookupComponentByName("Animator") as AnimatorComponent;
			var position:Point = owner.getProperty(positionProperty);
			var size:Point = owner.getProperty(sizeProperty);
			
			// check for positions between the buttons and the player
			if (tankPosition.x >=  position.x - size.x/2 && tankPosition.x <= position.x + size.x/2)
			{
				// animate the button if the player is under it
				if (!_isAnimating) {
					animator.play("hover");
					_isAnimating = true;
				}
			}
			else
			{
				// otherwise, stop the animation
				if (_isAnimating) {
					animator.play("idle");
					_isAnimating = false;
				}
			}
		}
	}
}