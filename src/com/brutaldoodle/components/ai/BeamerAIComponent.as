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

package com.brutaldoodle.components.ai
{
	import com.brutaldoodle.components.animations.TurnToColorComponent;
	import com.brutaldoodle.entities.Projectile;
	import com.brutaldoodle.rendering.BeamRenderer;
	import com.pblabs.engine.PBE;
	
	public class BeamerAIComponent extends SimpleAIComponent
	{
		public function BeamerAIComponent()
		{
			super();
		}
		
		override protected function think():void {
			super.think();
			
			//make the invader turn red
			var filter:TurnToColorComponent = new TurnToColorComponent();
			filter.color = TurnToColorComponent.COLOR_RED;
			filter.rate = 0.016;
			if (owner != null) {
				owner.addComponent(filter, "TurnRed");
			}
			
			// wait for the invader to turn red (about two seconds)
			PBE.processManager.schedule(2000, this, createBeam);
		}	
		
		private function createBeam():void {
			// shot a projectile rendered by SimpleShotRenderer
			var p:Projectile = new Projectile(BeamRenderer, owner);
		}
	}
}