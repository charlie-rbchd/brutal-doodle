package com.brutaldoodle.effects
{
	import com.brutaldoodle.components.CanonController;
	import com.brutaldoodle.components.PlayerController;
	import com.brutaldoodle.rendering.FlintBitmapRenderer;
	import com.pblabs.engine.PBE;
	import com.pblabs.rendering2D.SpriteRenderer;
	
	import flash.geom.Point;
	
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.zones.PointZone;
	
	public class CanonShotRenderer extends FlintBitmapRenderer
	{
		private var _bullet:Emitter2D;
		private var _explosion:Emitter2D;
		private var _smoke:Emitter2D;
		
		public function CanonShotRenderer()
		{
			super();
		}
		
		override public function addEmitters():void
		{
			var _canonPosition:Point = (PBE.nameManager.lookupComponentByName("Canon", "Render") as SpriteRenderer).position;
			var _emitLocation:PointZone = new PointZone( new Point(_canonPosition.x, _canonPosition.y + (PlayerController.state == PlayerController.STATE_NORMAL ? CanonController.NORMAL_OFFSET : CanonController.ALTERNATE_OFFSET) - 13) );
			
			_bullet = new Bullet();
			initializeEmitter(_bullet, _emitLocation);
			
			_smoke = new Smoke();
			initializeEmitter(_smoke, _emitLocation);
			
			/*
			_explosion = new Explosion();
			initializeEmitter(_explosion, _emitLocation);
			*/
			
			super.addEmitters();
		}
	}
}