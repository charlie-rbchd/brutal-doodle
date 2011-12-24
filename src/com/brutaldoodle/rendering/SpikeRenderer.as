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
	import com.brutaldoodle.effects.Spike;
	
	import org.flintparticles.twoD.emitters.Emitter2D;
	
	public class SpikeRenderer extends FlintBitmapRenderer
	{
		/*
		 * The emitter that will be rendered
		 */
		private var _spikeShotCannibal:Emitter2D;
		
		public function SpikeRenderer()
		{
			super();
		}
		
		/*
		 * Renderer-specific actions that are needed to properly render the Spike particle emitter
		 */
		override public function addEmitters():void {
			_spikeShotCannibal = new Spike();
			initializeEmitter(_spikeShotCannibal);
			super.addEmitters();
		}
	}
}