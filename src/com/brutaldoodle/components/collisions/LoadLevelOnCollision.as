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
	import com.brutaldoodle.collisions.CollisionManager;
	import com.brutaldoodle.collisions.CollisionType;
	import com.brutaldoodle.events.CollisionEvent;
	import com.pblabs.engine.entity.EntityComponent;
	
	public class LoadLevelOnCollision extends EntityComponent
	{
		/*
		 * The level that will be loaded on collision
		 */
		public var level:int = 0;
		
		/*
		 * The owner's bounding box
		 */
		private var _collisions:BoundingBoxComponent;
		
		public function LoadLevelOnCollision() {
			super();
		}
		
		override protected function onAdd():void {
			super.onAdd();
			CollisionManager.instance.addEventListener(CollisionEvent.COLLISION_OCCURED, loadLevel);
			_collisions = owner.lookupComponentByName("Collisions") as BoundingBoxComponent;
		}
		
		override protected function onRemove():void {
			super.onRemove();
			CollisionManager.instance.stopCollisionsWith(_collisions, CollisionType.ENEMY);
			CollisionManager.instance.removeEventListener(CollisionEvent.COLLISION_OCCURED, loadLevel);
		}
		
		/*
		 * Load a level once a collision has occured with the owner
		 * This is used to load a level when an object collide with a menu element
		 */
		private function loadLevel(event:CollisionEvent):void {
			if (owner != null) {
				if (event.zone == _collisions) {
					Main.resetEverythingAndLoadLevel(level);
				}
			}
		}
	}
}