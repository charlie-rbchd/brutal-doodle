package com.brutaldoodle.rendering
{
	import com.brutaldoodle.effects.Blood;
	
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	
	import org.flintparticles.common.initializers.ApplyFilter;
	import org.flintparticles.twoD.emitters.Emitter2D;

	public class BloodDropRenderer extends FlintBitmapRenderer
	{
		private var _blood:Emitter2D;
		
		public function BloodDropRenderer()
		{
			super();
		}
		
		override public function addEmitters():void
		{
			/*
			_renderer.addFilter(new ColorMatrixFilter([
				1, 0, 0, 0, 0, 0,
				1, 0, 0, 0, 0, 0,
				1, 0, 0, 0, 0, 0,
				0.7, 0
			]));
			*/
			
			_blood = new Blood();
			initializeEmitter(_blood);
			
			super.addEmitters();
		}
	}
}