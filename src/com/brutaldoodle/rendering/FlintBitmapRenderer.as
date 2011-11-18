package com.brutaldoodle.rendering
{
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import org.flintparticles.common.events.EmitterEvent;
	import org.flintparticles.twoD.actions.DeathZone;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.zones.PointZone;
	import org.flintparticles.twoD.zones.Zone2D;
	
	public class FlintBitmapRenderer
	{
		// contains all the emitters that need to be rendered for this specific effect
		protected var _emitters:Vector.<Emitter2D>;
		
		private var _counterCompletedEmitters:uint;
		private var _emptyEmitters:uint;
		
		public var trueOwner:IEntity;
		
		public function FlintBitmapRenderer() {
			super();
			_emptyEmitters = 0;
			_counterCompletedEmitters = 0;
			_emitters = new Vector.<Emitter2D>();
		}
		
		public function addEmitters():void {
			for (var i:int=0; i < _emitters.length; i++) {
				ParticleManager.instance.registerEmitter(_emitters[i]); // render it!
				
				// listeners used for cleaning references when the emitters are done emitting particles
				_emitters[i].addEventListener(EmitterEvent.EMITTER_EMPTY, destroyOwner, false, 0, true);
				_emitters[i].addEventListener(EmitterEvent.COUNTER_COMPLETE, destroyOwner, false, 0, true);
			}
		}
		
		protected function initializeEmitter(emitter:Emitter2D, position:Zone2D=null):void {
			var _emitLocation:Zone2D;
			
			// the emit location is determined by the position of its owner or by the optional parameter "position" if supplied
			if (position != null)
				_emitLocation = position;
			else if (trueOwner != null)
				_emitLocation = new PointZone( (trueOwner.lookupComponentByName("Spatial") as SimpleSpatialComponent).position );
			else return;
			
			// starting location of the particle
			emitter.addInitializer( new Position( _emitLocation ));
			
			// the particles die as soon as they become off-screen
			emitter.addAction( new DeathZone(ParticleManager.instance.sceneBoundaries, true) );
			_emitters.push(emitter);
		}
		
		private function destroyOwner(event:EmitterEvent):void {
			var emitter:Emitter2D = event.target as Emitter2D;
			
			switch (event.type) {
				case EmitterEvent.EMITTER_EMPTY:
					emitter.removeEventListener(EmitterEvent.EMITTER_EMPTY, destroyOwner);
					_emptyEmitters++;
					break;
				case EmitterEvent.COUNTER_COMPLETE:
					emitter.removeEventListener(EmitterEvent.COUNTER_COMPLETE, destroyOwner);
					_counterCompletedEmitters++;
			}
			
			// when one of the emitters is done emitting
			if (emitter.counter.complete && !emitter.particles.length) {
				ParticleManager.instance.removeEmitter(emitter);
			}
			
			// when all emitters are done emitting
			if (_emptyEmitters == _emitters.length && _counterCompletedEmitters == _emitters.length) {
				_emitters = new Vector.<Emitter2D>();
				trueOwner = null;
			}
		}
	}
}