package com.brutaldoodle.components.animations
{
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.PropertyReference;
	
	public class FadeComponent extends TickedComponent
	{
		public static const FADE_IN:String = "fadeIn";
		public static const FADE_OUT:String = "fadeOut";
		
		public var alphaProperty:PropertyReference;
		public var type:String;
		public var callback:Function;
		public var rate:Number;
		
		public function FadeComponent()
		{
			super();
		}
		
		override public function onTick (deltaTime:Number):void {
			super.onTick(deltaTime);
			var alpha:Number = owner.getProperty(alphaProperty);
			
			switch (type) {
				case FADE_IN:
					if (alpha <= 1) {
						owner.setProperty(alphaProperty, alpha += rate);	
					} else {
						this.registerForTicks = false;
						if (callback != null) callback();
					}
					break;
				case FADE_OUT:
					if (alpha > 0) {
						owner.setProperty(alphaProperty, alpha -= rate);
					} else {
						this.registerForTicks = false;
						if (callback != null) callback();
					}
					break;
				default:
					throw new Error();
			}
		
		}
	}
}