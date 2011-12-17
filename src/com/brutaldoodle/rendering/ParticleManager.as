package com.brutaldoodle.rendering
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.DisplayObjectRenderer;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.renderers.BitmapRenderer;
	import org.flintparticles.twoD.zones.RectangleZone;

	public class ParticleManager
	{
		// Singleton instance
		private static var _instance:ParticleManager = new ParticleManager();
		
		private var __this:IEntity;
		private var _renderer:BitmapRenderer;
		private var _width:Number;
		private var _height:Number;
		
		public static function get instance ():ParticleManager { return _instance; }
		
		public function ParticleManager() {
			// "Private" constructor
			if (instance) throw new Error("ParticleManager can only be accessed through ParticleManager.instance");
		}
		
		public function initialize (width:Number, height:Number):void {
			_width = width;
			_height = height;
			
			// the Flint renderer used to display all the particles throughout the game
			_renderer = new BitmapRenderer( new Rectangle(-_width/2, -_height/2, _width, _height) );
			
			// the entity that will contain/manage the renderer (much like a Sprite)
			__this = PBE.allocateEntity();
			
			var spatial:SimpleSpatialComponent = new SimpleSpatialComponent();
			spatial.position = new Point(0, 0);
			spatial.size = new Point(_width, _height);
			spatial.spatialManager = PBE.spatialManager;
			__this.addComponent(spatial, "Spatial");
			
			var renderer:DisplayObjectRenderer = new DisplayObjectRenderer();
			renderer.scene = PBE.scene;
			renderer.displayObject = _renderer; // renders the Flint renderer as its displayObject
			renderer.layerIndex = 6;
			renderer.positionProperty = new PropertyReference("@Spatial.position");
			renderer.sizeProperty = new PropertyReference("@Spatial.size");
			__this.addComponent(renderer, "Render");
			
			__this.initialize();
		}
		
		// add an emitter to the renderer so it can be displayed on screen
		public function registerEmitter(emitter:Emitter2D):void {
			_renderer.addEmitter(emitter);
			emitter.start();
		}
		
		// when the emitter is no longer needed...
		public function removeEmitter (emitter:Emitter2D):void {
			emitter.killAllParticles(); // just in case there's some remaining particles that block garbage collecting
			emitter.stop();
			_renderer.removeEmitter(emitter);
		}
		
		public function pause():void {
			for (var i:int = 0; i < _renderer.emitters.length; i++) {
				_renderer.emitters[i].pause();
			}
		}
		
		public function resume():void {
			for (var i:int = 0; i < _renderer.emitters.length; i++) {
				_renderer.emitters[i].resume();
			}
		}
		
		public function removeAllParticles():void {
			for (var i:int = 0; i < _renderer.emitters.length; i++) {
				var emitter:Emitter = _renderer.emitters[i];
				emitter.killAllParticles();
			}
		}
		
		public function get sceneBoundaries():RectangleZone {
			return new RectangleZone(-_width/2, -_height/2, _width, _height);
		}
	}
}