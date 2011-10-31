package com.brutaldoodle.rendering
{
	import com.brutaldoodle.effects.Blood;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.zones.PointZone;

	public class BloodDropRenderer extends FlintBitmapRenderer
	{
		private var _blood:Emitter2D;
		
		public function BloodDropRenderer()
		{
			super();
		}
		
		override public function addEmitters():void
		{
			_renderer.addFilter(new ColorMatrixFilter([
				1, 0, 0, 0, 0, 0,
				1, 0, 0, 0, 0, 0,
				1, 0, 0, 0, 0, 0,
				0.7, 0
			]));
			
			var render:FlintBitmapRenderer = owner.lookupComponentByName("Render") as FlintBitmapRenderer;
			var spatial:SimpleSpatialComponent = (render.trueOwner.lookupComponentByName("Spatial") as SimpleSpatialComponent);
			
			var _emitLocation:PointZone = new PointZone(spatial.position);
			
			_blood = new Blood();
			initializeEmitter(_blood, _emitLocation);
			
			super.addEmitters();
		}
	}
}