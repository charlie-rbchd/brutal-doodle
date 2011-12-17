package com.brutaldoodle.entities
{
	import com.brutaldoodle.components.animations.FadeComponent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	import com.pblabs.rendering2D.SpriteRenderer;
	
	import flash.geom.Point;
	
	public class Dialog
	{
		private var __this:IEntity;
		
		public function Dialog(filePath:String, size:Point, position:Point=null)
		{
			__this = PBE.allocateEntity();
			
			var spatial:SimpleSpatialComponent = new SimpleSpatialComponent();
			spatial.position = position || new Point(0, 0);
			spatial.size = size;
			spatial.spatialManager = PBE.spatialManager;
			__this.addComponent(spatial, "Spatial");
			
			
			var renderer:SpriteRenderer = new SpriteRenderer();
			renderer.scene = PBE.scene;
			renderer.fileName = filePath;
			renderer.layerIndex = 10;
			renderer.positionProperty = new PropertyReference("@Spatial.position");
			renderer.sizeProperty = new PropertyReference("@Spatial.size");
			__this.addComponent(renderer, "Render");
			
			
			var fadeOut:FadeComponent = new FadeComponent();
			fadeOut.alphaProperty = new PropertyReference("@Render.alpha");
			fadeOut.type = FadeComponent.FADE_OUT;
			fadeOut.rate = 0.01;
			fadeOut.callback = function():void {
				__this.destroy();
			};
			__this.addComponent(fadeOut, "FadeOut");
			
			
			__this.initialize();
		}
	}
}