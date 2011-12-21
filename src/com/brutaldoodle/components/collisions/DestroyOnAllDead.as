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
	import com.pblabs.components.basic.HealthEvent;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.rendering2D.SpriteSheetRenderer;
	
	public class DestroyOnAllDead extends EntityComponent
	{
		/*
		 * Contains all the units that need to die before they are all destroyed
		 */
		private static var _units:Vector.<IEntity> = new Vector.<IEntity>();
		
		/*
		 * The amount of dead units
		 */
		private static var _deadCount:int = 0;
		
		public function DestroyOnAllDead()
		{
			super();
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			_units.push(owner);
			owner.eventDispatcher.addEventListener(HealthEvent.DIED, onDeath);
		}
		
		override protected function onRemove():void
		{
			super.onRemove();
			owner.eventDispatcher.removeEventListener(HealthEvent.DIED, onDeath);
		}
		
		/*
		 * Remove all the units from the display list once they're all dead
		 */
		private function onDeath (event:HealthEvent):void {
			if (++_deadCount == _units.length) {
				while (_units.length) {
					_units.shift().destroy();
				}
				DestroyOnAllDead.reset();
			} else {
				// The owner is faded until it dies
				var renderer:SpriteSheetRenderer = owner.lookupComponentByName("Render") as SpriteSheetRenderer;
				renderer.alpha = 0.5;
			}
		}
		
		/*
		 * Reset the dead count to zero and remove units references 
		 */
		public static function reset():void {
			_units = new Vector.<IEntity>();
			_deadCount = 0;
		}
		
	}
}