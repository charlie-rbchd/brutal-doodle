package com.brutaldoodle.components.animations
{
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.PropertyReference;
	
	public class FadeInComponent extends TickedComponent
	{
		public var alphaProperty:PropertyReference;
		public var rate:Number;
		
		public function FadeInComponent()
		{
			super();
		}
		
		override public function onTick(deltaTime:Number):void {
			super.onTick(deltaTime);
			var alpha:Number = owner.getProperty(alphaProperty);
			
			if (alpha <= 1)
				owner.setProperty(alphaProperty, alpha += rate);	
			else
				this.registerForTicks = false;	
		}
	}
}