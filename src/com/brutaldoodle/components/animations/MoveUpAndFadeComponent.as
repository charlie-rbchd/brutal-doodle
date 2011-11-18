package com.brutaldoodle.components.animations
{
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.entity.PropertyReference;
	
	import flash.geom.Point;
	
	public class MoveUpAndFadeComponent extends TickedComponent
	{
		public var positionProperty:PropertyReference;
		public var alphaProperty:PropertyReference;
		
		public function MoveUpAndFadeComponent() {
			super();
		}
		
		override public function onTick(deltaTime:Number):void {
			super.onTick(deltaTime);
			
			var alpha:Number = owner.getProperty(alphaProperty);
			alpha -= 0.05; // modify the alpha until its pretty much invisible
			
			// delete the object if it turned invisible
			if (alpha <= 0.05) {
				owner.destroy();
				return;
			}
			
			// move up (a bit angled to the right) as long as its visible
			var pos:Point = owner.getProperty(positionProperty);
			pos.y -= 2;
			pos.x += 0.5;
			
			// apply the alpha and position to the owner object
			owner.setProperty(positionProperty, pos);	
			owner.setProperty(alphaProperty, alpha);
		}
	}
}