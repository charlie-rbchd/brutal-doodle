package com.brutaldoodle.rendering
{
	import com.brutaldoodle.effects.Coin;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.zones.PointZone;
	
	public class CoinRenderer extends FlintBitmapRenderer
	{
		private var _coin:Emitter2D;
		
		public function CoinRenderer() {
			super();
		}
		
		override public function addEmitters():void {
			//position the gold where his owner is (if he has one)
			if (trueOwner != null) {
				var spatial:SimpleSpatialComponent = (trueOwner.lookupComponentByName("Spatial") as SimpleSpatialComponent);
				var _emitLocation:PointZone = new PointZone(spatial.position);
				
				//Start an emitter when an enemy dies (he will drop his jew money)
				_coin = new Coin();
				initializeEmitter(_coin, _emitLocation);
				
				super.addEmitters();
			}
		}
	}
}