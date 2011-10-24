package com.brutaldoodle.rendering
{
	
	import com.brutaldoodle.effects.SimpleShot;
	import com.brutaldoodle.rendering.FlintBitmapRenderer;
	import com.pblabs.engine.PBE;
	import com.pblabs.rendering2D.SpriteRenderer;
	
	import flash.geom.Point;
	
	import org.flintparticles.twoD.emitters.Emitter2D;
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
			var _emitLocation:PointZone = new PointZone(new Point(0,-300));	
			
			_simpleShot = new SimpleShot();
			initializeEmitter(_simpleShot, _emitLocation);
			
			super.addEmitters();
		}
	}
}