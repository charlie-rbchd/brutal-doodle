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
	import com.brutaldoodle.effects.Warp;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import flash.geom.Point;
	
	import org.flintparticles.twoD.actions.GravityWell;
	import org.flintparticles.twoD.emitters.Emitter2D;
	
	public class WarpRenderer extends FlintBitmapRenderer
	{
		private var _warp:Emitter2D;
		
		public function WarpRenderer()
		{
			super();
		}
		
		override public function addEmitters():void
		{
			// Start an emitter for creating an effect when the warper is about to warp
			if (trueOwner != null) {
				var _position:Point = (trueOwner.lookupComponentByName("Spatial") as SimpleSpatialComponent).position
				
				_warp = new Warp();
				_warp.addAction( new GravityWell( 400, _position.x, _position.y ) );
				this.initializeEmitter(_warp);
				super.addEmitters();
			}
		}
	}
}