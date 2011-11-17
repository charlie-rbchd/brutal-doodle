package com.brutaldoodle.rendering
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.DisplayObjectRenderer;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.renderers.BitmapRenderer;
	import org.flintparticles.twoD.zones.RectangleZone;

	public class ParticleManager
	{
		private static var _instance:ParticleManager = new ParticleManager();
		
		private var __this:IEntity;
		private var _renderer:BitmapRenderer;
		private var _width:Number;
		private var _height:Number;
		
		public static function get instance ():ParticleManager { return _instance; }
		
		public function ParticleManager() {
			if (instance) throw new Error("ParticleManager can only be accessed through ParticleManager.instance");
		}
		
		public function initialize (width:Number, height:Number):void {
			_width = width;
			_height = height;
			
			_renderer = new BitmapRenderer( new Rectangle(-_width/2, -_height/2, _width, _height) );
			
			__this = PBE.allocateEntity();
			
			var spatial:SimpleSpatialComponent = new SimpleSpatialComponent();
			spatial.position = new Point(0, 0);
			spatial.size = new Point(_width, _height);
			spatial.spatialManager = PBE.spatialManager;
			__this.addComponent(spatial, "Spatial");
			
			var renderer:DisplayObjectRenderer = new DisplayObjectRenderer();
			renderer.scene = PBE.scene;
			renderer.displayObject = _renderer;
			renderer.layerIndex = 3;
			renderer.positionProperty = new PropertyReference("@Spatial.position");
			renderer.sizeProperty = new PropertyReference("@Spatial.size");
			__this.addComponent(renderer, "Render");
			
			__this.initialize();
		}
		
		public function registerEmitter(emitter:Emitter2D):void {
			_renderer.addEmitter(emitter);
			emitter.start();
		}
		
		public function removeEmitter (emitter:Emitter2D):void {
			emitter.killAllParticles();
			emitter.stop();
			_renderer.removeEmitter(emitter);
		}
		
		public function get sceneBoundaries():RectangleZone {
			return new RectangleZone(-_width/2, -_height/2, _width, _height);
		}
	}
}