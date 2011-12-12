package com.brutaldoodle.rendering
{
	import com.brutaldoodle.effects.Beam;
	import org.flintparticles.twoD.emitters.Emitter2D;
	
	public class BeamRenderer extends FlintBitmapRenderer
	{
		private var _beam:Emitter2D;
		
		public function BeamRenderer()
		{
			super();
		}
		
		override public function addEmitters():void {
			//Start an emitter for any shot made by a beamer invader
			_beam = new Beam();
			initializeEmitter(_beam);
			super.addEmitters();
		}	
		
	}
}