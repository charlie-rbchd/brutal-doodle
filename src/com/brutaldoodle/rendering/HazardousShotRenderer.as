package com.brutaldoodle.rendering
{
	import com.brutaldoodle.effects.HazardousShot;
	
	import flash.geom.Point;
	
	import org.flintparticles.twoD.zones.PointZone;
	
	public class HazardousShotRenderer extends FlintBitmapRenderer
	{
		private var _hazardousShot:HazardousShot; 
		
		public function HazardousShotRenderer()
		{
			super();
		}
		
		override public function addEmitters():void
		{
			var _emitLocation:PointZone = new PointZone(new Point(0, -300));	
			
			_hazardousShot = new HazardousShot();
			initializeEmitter(_hazardousShot, _emitLocation);
			
			super.addEmitters();
		}
	}
}