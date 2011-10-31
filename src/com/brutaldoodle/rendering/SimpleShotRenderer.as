package com.brutaldoodle.rendering
{
	
	import com.brutaldoodle.effects.SimpleShot;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import org.flintparticles.twoD.zones.PointZone;
	
	public class SimpleShotRenderer extends FlintBitmapRenderer
	{
		
		private var _simpleShot:SimpleShot;
		
		public function SimpleShotRenderer()
		{
			super();
		}
		
		override public function addEmitters():void
		{
			var render:FlintBitmapRenderer = owner.lookupComponentByName("Render") as FlintBitmapRenderer;
			
			if (render.trueOwner != null) {
				var spatial:SimpleSpatialComponent = (render.trueOwner.lookupComponentByName("Spatial") as SimpleSpatialComponent);
				var _emitLocation:PointZone = new PointZone(spatial.position);
				
				_simpleShot = new SimpleShot();
				initializeEmitter(_simpleShot, _emitLocation);
				
				super.addEmitters();
			}
		}
	}
}