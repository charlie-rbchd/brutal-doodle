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
	import com.brutaldoodle.components.controllers.CanonController;
	import com.brutaldoodle.components.controllers.PlayerController;
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
		/*
		 * The first emitter that will be rendered
		 */
		private var _bullet:Emitter2D;
		
		/*
		 * The second emitter that will be rendered
		 */
		private var _smoke:Emitter2D;
		
		public function CanonShotRenderer() {
			super();
		}
		
		/*
		 * Renderer-specific actions that are needed to properly render the Warp particle emitter
		 */
		override public function addEmitters():void {
			// Retrieved the position of the player and the canon in order to properly position the emitter
			var _canon:IEntity = PBE.nameManager.lookup("Canon");
			var _canonSize:Point = (_canon.lookupComponentByName("Spatial") as SimpleSpatialComponent).size;
			var _canonPosition:Point = (_canon.lookupComponentByName("Render") as SpriteRenderer).position;
			
			// The emitter can be higher, depending on the player's state
			var _emitLocation:PointZone = new PointZone( new Point(_canonPosition.x, _canonPosition.y + (PlayerController.state == PlayerController.STATE_NORMAL ? CanonController.NORMAL_OFFSET : CanonController.ALTERNATE_OFFSET) - _canonSize.y/2) );
			
			_bullet = new Bullet();
			initializeEmitter(_bullet, _emitLocation);
			
			_smoke = new Smoke();
			initializeEmitter(_smoke, _emitLocation);
			
			super.addEmitters();
		}
	}
}