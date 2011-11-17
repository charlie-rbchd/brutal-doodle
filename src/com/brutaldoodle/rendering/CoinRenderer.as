package com.brutaldoodle.rendering
{
	import com.brutaldoodle.effects.Coin;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.zones.PointZone;
	
	public class CoinRenderer extends FlintBitmapRenderer
	{
		private var _coin:Emitter2D;
		
		public function CoinRenderer()
		{
			super();
		}
		
		override public function addEmitters():void
		{
			if (trueOwner != null) {
				var spatial:SimpleSpatialComponent = (trueOwner.lookupComponentByName("Spatial") as SimpleSpatialComponent);
				var _emitLocation:PointZone = new PointZone(spatial.position);
				
				_coin = new Coin();
				initializeEmitter(_coin, _emitLocation);
				
				super.addEmitters();
			}
		}
	}
}