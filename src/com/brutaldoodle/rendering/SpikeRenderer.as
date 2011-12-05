package com.brutaldoodle.rendering
{
	import com.brutaldoodle.effects.Spike;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import flash.geom.Point;
	
	import org.flintparticles.twoD.emitters.Emitter2D;
	
	public class SpikeRenderer extends FlintBitmapRenderer
	{
		private var _spikeShotCannibal:Emitter2D;
		
		public function SpikeRenderer()
		{
			super();
		}
		
		override public function addEmitters():void {
			//Start an emitter for any shot made by a cannibal invader
			_spikeShotCannibal = new Spike();
			initializeEmitter(_spikeShotCannibal);
			super.addEmitters();
		}
	}
}