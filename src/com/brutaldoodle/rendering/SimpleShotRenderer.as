package com.brutaldoodle.rendering
{
	
	import com.brutaldoodle.effects.SimpleShot;
	
	import org.flintparticles.twoD.emitters.Emitter2D;
	
	public class SimpleShotRenderer extends FlintBitmapRenderer
	{
		private var _simpleShot:Emitter2D;
		
		public function SimpleShotRenderer() {
			super();
		}
		
		override public function addEmitters():void {
			_simpleShot = new SimpleShot();
			initializeEmitter(_simpleShot);
			super.addEmitters();
		}
	}
}