package com.brutaldoodle.entities
{
	import com.brutaldoodle.rendering.FlintBitmapRenderer;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import flash.geom.Point;
	
	public class Projectile
	{
		private var __this:IEntity;
		
		public function Projectile(RendererClass:Class, owner:IEntity)
		{
			__this = PBE.allocateEntity();
			__this.initialize();
			
			var spatial:SimpleSpatialComponent = new SimpleSpatialComponent();
			spatial.position = new Point(0, 0);
			__this.addComponent(spatial, "Spatial");
			
			var renderer:FlintBitmapRenderer = new RendererClass();
			renderer.scene = PBE.scene;
			renderer.layerIndex = 3;
			renderer.trueOwner = owner;
			renderer.positionProperty = new PropertyReference("@Spatial.position");
			__this.addComponent(renderer, "Render");
			
			renderer.addEmitters();
		}
	}
}