/*
* Brutal Doodle
* Copyright (C) 2011  Joel Robichaud, Maxime Basque, Maxime St-Louis-Fortier, Raphaelle Cantin & Simon Garnier
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.

* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

package com.brutaldoodle.rendering
{
	import com.pblabs.engine.PBE;
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
		/*
		 * Singleton instance
		 */
		private static var _instance:ParticleManager = new ParticleManager();
		
		/*
		 * The entity that will hold and render all the particles
		 */
		private var __this:IEntity;
		
		/*
		 * The renderer used to render all the particles
		 */
		private var _renderer:BitmapRenderer;
		
		/*
		 * The width of the viewport that will render particles
		 */
		private var _width:Number;
		
		/* 
		 * The height of the viewport that will render particles
		 */
		private var _height:Number;
		
		public static function get instance ():ParticleManager { return _instance; }
		
		/*
		 * Private constructor
		 */
		public function ParticleManager() {
			if (instance) throw new Error("ParticleManager can only be accessed through ParticleManager.instance");
		}
		
		/*
		 * Instanciation of entity used to render all the particles
		 *
		 * @param width  The width of the viewport that will render particles
		 * @param height  The height of the viewport that will render particles
		 */
		public function initialize (width:Number, height:Number):void {
			_width = width;
			_height = height;
			
			// The Flint renderer used to display all the particles throughout the game
			_renderer = new BitmapRenderer( new Rectangle(-_width/2, -_height/2, _width, _height) );
			
			// The entity that will contain/manage the renderer (much like a Sprite)
			__this = PBE.allocateEntity();
			
			var spatial:SimpleSpatialComponent = new SimpleSpatialComponent();
			spatial.position = new Point(0, 0);
			spatial.size = new Point(_width, _height);
			spatial.spatialManager = PBE.spatialManager;
			__this.addComponent(spatial, "Spatial");
			
			var renderer:DisplayObjectRenderer = new DisplayObjectRenderer();
			renderer.scene = PBE.scene;
			renderer.displayObject = _renderer; // Renders the Flint renderer as its displayObject
			renderer.layerIndex = 6;
			renderer.positionProperty = new PropertyReference("@Spatial.position");
			renderer.sizeProperty = new PropertyReference("@Spatial.size");
			__this.addComponent(renderer, "Render");
			
			__this.initialize();
		}
		
		/*
		 * Add an emitter from the particle manager's renderer
		 *
		 * @param emitter The emitter that will be added
		 */
		public function registerEmitter(emitter:Emitter2D):void {
			_renderer.addEmitter(emitter);
			emitter.start();
		}
		
		/*
		 * Remove an emitter from the particle manager's renderer
		 *
		 * @param emitter The emitter that will be removed
		 */
		public function removeEmitter (emitter:Emitter2D):void {
			emitter.killAllParticles(); // Just in case there are remaining particles that block garbage collecting
			emitter.stop();
			_renderer.removeEmitter(emitter);
		}
		
		/*
		 * Pause all the registered emitters (stop all particles)
		 */
		public function pause():void {
			for (var i:int = 0; i < _renderer.emitters.length; i++) {
				_renderer.emitters[i].pause();
			}
		}
		
		/*
		 * Resume all the registered emitters (make the particles continue their movements)
		 */
		public function resume():void {
			for (var i:int = 0; i < _renderer.emitters.length; i++) {
				_renderer.emitters[i].resume();
			}
		}
		
		/*
		 * Remove all the emitters from renderer
		 */
		public function removeAllParticles():void {
			for (var i:int = 0; i < _renderer.emitters.length; i++) {
				var emitter:Emitter = _renderer.emitters[i];
				emitter.killAllParticles();
			}
		}
		
		/*
		 * @return  The zone where particles are rendered
		 */
		public function get sceneBoundaries():RectangleZone {
			return new RectangleZone(-_width/2, -_height/2, _width, _height);
		}
	}
}