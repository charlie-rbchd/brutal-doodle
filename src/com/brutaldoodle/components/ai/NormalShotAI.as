package com.brutaldoodle.components.ai
{
	import com.brutaldoodle.entities.Projectile;
	import com.brutaldoodle.rendering.SimpleShotRenderer;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import flash.geom.Point;

	public class NormalShotAI extends SimpleAIComponent
	{
		public function NormalShotAI()
		{
			super();
		}
		
		override protected function think():void
		{
			super.think();
			
			// shot a projectile renderer by SimpleShotRenderer
			var p:Projectile = new Projectile(SimpleShotRenderer, owner);
		}
	}
}