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

package com.brutaldoodle.components.collisions
{
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;
	
	public class LoadLevelOnDeath extends EntityComponent
	{
		/*
		 * Contains all the units that need to die before loading the level
		 */
		private static var units:Vector.<IEntity> = new Vector.<IEntity>();
		
		/*
		 * The level to load once all the units are dead
		 */
		public var level:int;
		
		public function LoadLevelOnDeath() {
			super();
		}
		
		override protected function onAdd():void {
			super.onAdd();
			units.push(owner);
		}
		
		
		override protected function onRemove():void {
			super.onRemove();
			units.splice(units.indexOf(owner), 1);
			
			// load a level once all the units have been killed
			// This is used to load the next stage of the tutorial
			if (!units.length) {
				Main.resetEverythingAndLoadLevel(level, true);
			}
		}
	}
}