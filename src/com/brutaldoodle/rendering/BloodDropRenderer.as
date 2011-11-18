package com.brutaldoodle.rendering
{
	import com.brutaldoodle.effects.Blood;
	
	import org.flintparticles.twoD.emitters.Emitter2D;

	public class BloodDropRenderer extends FlintBitmapRenderer
	{
		private var _blood:Emitter2D;
		
		public function BloodDropRenderer() {
			super();
		}
		
		override public function addEmitters():void {
			//Was there for a nice blur effect but we worked on some class and this cannot work for now
			//might try to reimplement this later on in the project
			/*
			_renderer.addFilter(new ColorMatrixFilter([
				1, 0, 0, 0, 0, 0,
				1, 0, 0, 0, 0, 0,
				1, 0, 0, 0, 0, 0,
				0.7, 0
			]));
			*/
			
			//Start an emitter anytime and invader his damaged
			_blood = new Blood();
			initializeEmitter(_blood);
			super.addEmitters();
		}
	}
}