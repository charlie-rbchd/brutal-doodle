package com.brutaldoodle.rendering
{
	import com.brutaldoodle.components.CanonController;
	import com.brutaldoodle.components.PlayerController;
	import com.brutaldoodle.effects.Bullet;
	import com.brutaldoodle.effects.Smoke;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	import com.pblabs.rendering2D.SpriteRenderer;
	
	import flash.geom.Point;
	
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.zones.PointZone;
	
	public class CanonShotRenderer extends FlintBitmapRenderer
	{
		private var _bullet:Emitter2D;
		private var _smoke:Emitter2D;
		
		public function CanonShotRenderer()
		{
			super();
		}
		
		override public function addEmitters():void
		{
			var _canon:IEntity = 		PBE.nameManager.lookup("Canon");
			var _canonSize:Point = 		(_canon.lookupComponentByName("Spatial") as SimpleSpatialComponent).size;
			var _canonPosition:Point = 	(_canon.lookupComponentByName("Render") as SpriteRenderer).position;
			
			var _emitLocation:PointZone = new PointZone( new Point(_canonPosition.x, _canonPosition.y + (PlayerController.state == PlayerController.STATE_NORMAL ? CanonController.NORMAL_OFFSET : CanonController.ALTERNATE_OFFSET) - _canonSize.y/2) );
			
			_bullet = new Bullet();
			initializeEmitter(_bullet, _emitLocation);
			
			_smoke = new Smoke();
			initializeEmitter(_smoke, _emitLocation);
			
			super.addEmitters();
		}
	}
}