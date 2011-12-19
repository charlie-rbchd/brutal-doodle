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
		/*
		 * The entity that will be created
		 */
		private var __this:IEntity;
		
		/*
		 * Create a dialog box that slowly fades
		 *
		 * @param filePath  The path of the image used for the dialog
		 * @param size  The size of the image (width, height)
		 * @param position  The position at which the image will be placed, centered by default
		 */
		public function Dialog (filePath:String, size:Point, position:Point=null)
		{
			__this = PBE.allocateEntity();
			
			// Spatial properties of the dialog box
			var spatial:SimpleSpatialComponent = new SimpleSpatialComponent();
			spatial.position = position || new Point(0, 0);
			spatial.size = size;
			spatial.spatialManager = PBE.spatialManager;
			__this.addComponent(spatial, "Spatial");
			
			// Render properties of the dialog box
			var renderer:SpriteRenderer = new SpriteRenderer();
			renderer.scene = PBE.scene;
			renderer.fileName = filePath;
			renderer.layerIndex = 10;
			renderer.positionProperty = new PropertyReference("@Spatial.position");
			renderer.sizeProperty = new PropertyReference("@Spatial.size");
			__this.addComponent(renderer, "Render");
			
			// Add a component which makes the dialog box fade
			var fadeOut:FadeComponent = new FadeComponent();
			fadeOut.alphaProperty = new PropertyReference("@Render.alpha");
			fadeOut.type = FadeComponent.FADE_OUT;
			fadeOut.delay = 2000;
			fadeOut.rate = 0.1;
			fadeOut.callback = function():void {
				__this.destroy();
			};
			__this.addComponent(fadeOut, "FadeOut");
			
			
			__this.initialize();
		}
	}
}