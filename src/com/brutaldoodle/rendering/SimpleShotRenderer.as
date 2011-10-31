package com.brutaldoodle.rendering
{
	
	import com.brutaldoodle.effects.SimpleShot;
	import com.brutaldoodle.rendering.FlintBitmapRenderer;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
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
			var render:FlintBitmapRenderer = owner.lookupComponentByName("Render") as FlintBitmapRenderer;
			var spatial:SimpleSpatialComponent = (render.trueOwner.lookupComponentByName("Spatial") as SimpleSpatialComponent);
			/**
			 * TypeError: Error #1009: Il est impossible d'accéder à la propriété ou à la méthode d'une référence d'objet nul.
			 * at com.brutaldoodle.rendering::SimpleShotRenderer/addEmitters()[C:\Users\Maxime\Desktop\BrutalDoodle-git\src\com\brutaldoodle\rendering\SimpleShotRenderer.as:30]
			 * at com.brutaldoodle.entities::Projectile()[C:\Users\Maxime\Desktop\BrutalDoodle-git\src\com\brutaldoodle\entities\Projectile.as:31]
			 * at com.brutaldoodle.components.ai::NormalShotAI/think()[C:\Users\Maxime\Desktop\BrutalDoodle-git\src\com\brutaldoodle\components\ai\NormalShotAI.as:24]
			 * at Function/http://adobe.com/AS3/2006/builtin::apply()
			 * at com.pblabs.engine.core::ProcessManager/processScheduledObjects()[/opt/hudson/PBEngine/workspace/src/com/pblabs/engine/core/ProcessManager.as:584]
			 * at com.pblabs.engine.core::ProcessManager/advance()[/opt/hudson/PBEngine/workspace/src/com/pblabs/engine/core/ProcessManager.as:442]
			 * at com.pblabs.engine.core::ProcessManager/onFrame()[/opt/hudson/PBEngine/workspace/src/com/pblabs/engine/core/ProcessManager.as:416]
			 * Happens when a particle is shot at the same time you kill the owner (render.trueOwner becomes null)
			 */
			
			var _emitLocation:PointZone = new PointZone(spatial.position);
			
			_simpleShot = new SimpleShot();
			initializeEmitter(_simpleShot, _emitLocation);
			
			super.addEmitters();
		}
	}
}