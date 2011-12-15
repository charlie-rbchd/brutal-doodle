package com.brutaldoodle.rendering
{
	import com.brutaldoodle.effects.Warp;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import flash.geom.Point;
	
	import org.flintparticles.twoD.actions.GravityWell;
	import org.flintparticles.twoD.emitters.Emitter2D;
	
	public class WarpRenderer extends FlintBitmapRenderer
	{
		private var _warp:Emitter2D;
		
		public function WarpRenderer()
		{
			super();
		}
		
		override public function addEmitters():void
		{
			// Start an emitter for creating an effect when the warper is about to warp
			if (trueOwner != null) {
				var _position:Point = (trueOwner.lookupComponentByName("Spatial") as SimpleSpatialComponent).position
				
				_warp = new Warp();
				_warp.addAction( new GravityWell( 400, _position.x, _position.y ) );
				this.initializeEmitter(_warp);
				super.addEmitters();
			}
		}
	}
}