package com.brutaldoodle.components.ai
{
	import com.brutaldoodle.components.animations.TurnToColorComponent;
	import com.brutaldoodle.components.basic.WarpableComponent;
	import com.brutaldoodle.components.collisions.BoundingBoxComponent;
	import com.brutaldoodle.entities.Projectile;
	import com.brutaldoodle.rendering.WarpRenderer;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class WarperAIComponent extends SimpleAIComponent
	{
		public var positionProperty:PropertyReference;
		public var boundingBoxProperty:PropertyReference;
		
		public function WarperAIComponent()
		{
			super();
		}
				
		override protected function think():void
		{
			super.think();
			
			//make the invader turn white over a 1 second period.
			var filter:TurnToColorComponent = new TurnToColorComponent();
			filter.rate = 0.033;
			filter.color = TurnToColorComponent.COLOR_WHITE;
			if (owner != null) {
				owner.addComponent(filter,"TurnColor");
			}
			
			//start the particle effect.
			var p:Projectile = new Projectile(WarpRenderer, owner);
			//create a timer of one second, the time it take for the to animation to be complete
			
			PBE.processManager.schedule(1000, this, warpIt);
		}
		
		private function warpIt():void {
			//use the getRandomValue() method(who consider priority set in the WarpableComponent) to decide wich ennemy to target
			var warpableUnit:IEntity = WarpableComponent.isWarpablePriority.getRandomValue();
			
			if (warpableUnit != null && owner != null) {
				//get the position and bounding Box where the warper is going to warp to
				var spatial:SimpleSpatialComponent = warpableUnit.lookupComponentByName("Spatial")as SimpleSpatialComponent;
				var boundingBox:BoundingBoxComponent = warpableUnit.lookupComponentByName("Collisions")as BoundingBoxComponent;
				var positionTo:Point = spatial.position;
				var boundingBoxTo:Rectangle = boundingBox.zone;
				
				//get the current position and bounding Box where the targeted ennemy will be sent
				var positionFrom:Point = owner.getProperty(positionProperty);
				var boundingBoxFrom:Rectangle = owner.getProperty(boundingBoxProperty);
				
				//actually exchange the position and bounding Box of the two unit 
				owner.setProperty(positionProperty,positionTo);
				warpableUnit.setProperty(new PropertyReference("@Spatial.position"),positionFrom);
				owner.setProperty(boundingBoxProperty,boundingBoxTo);
				warpableUnit.setProperty(new PropertyReference("@Collisions.zone"),boundingBoxFrom);
			}
		}
	}
}