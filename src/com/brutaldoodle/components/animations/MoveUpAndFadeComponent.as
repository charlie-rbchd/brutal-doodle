package com.brutaldoodle.components.animations
{
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import flash.geom.Point;
	
	public class MoveUpAndFadeComponent extends TickedComponent
	{
		public var positionProperty:PropertyReference;
		public var alphaProperty:PropertyReference;
		
		public function MoveUpAndFadeComponent()
		{
			super();
			
		}
		
		override public function onTick(deltaTime:Number):void
		{
			super.onTick(deltaTime);
			
			var alpha:Number = owner.getProperty(alphaProperty);
			alpha -= 0.05;
			
			if (alpha <= 0.05) {
				owner.destroy();
				return;
			}
			
			var pos:Point = owner.getProperty(positionProperty);
			pos.y -= 2;
			pos.x += 0.5;
			
			owner.setProperty(positionProperty, pos);	
			owner.setProperty(alphaProperty, alpha);
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
		}
		
	}
}