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

package com.brutaldoodle.components.animations
{
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.rendering2D.SpriteRenderer;
	import com.pblabs.rendering2D.modifier.ColorizeModifier;

	public class ChangeEnvironmentComponent extends EntityComponent
	{
		public function ChangeEnvironmentComponent()
		{
			super();
		}
		override protected function onAdd():void
		{
			super.onAdd();
			var renderer:SpriteRenderer = owner.lookupComponentByName("Render") as SpriteRenderer;
			var date:Date = new Date();

			// Change the colors to make them more obscure at night and clearer during the day
			if (date.hours <= 12)
				renderer.modifiers = [ new ColorizeModifier([1,0,0,0,0], [0,1,0,0,0], [0,0,2.5 - 1.7 *(date.hours/12),0,0], [0,0,0,1,0]) ];
			else
				renderer.modifiers = [ new ColorizeModifier([1,0,0,0,0], [0,1,0,0,0], [0,0,2.5 - 1.7 * (date.hours - 12)/12,0,0], [0,0,0,1,0]) ];
		}
	}
}
