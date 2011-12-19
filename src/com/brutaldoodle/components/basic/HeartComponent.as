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

package com.brutaldoodle.components.basic
{
	import com.brutaldoodle.collisions.CollisionManager;
	import com.brutaldoodle.collisions.CollisionType;
	import com.brutaldoodle.components.collisions.BoundingBoxComponent;
	import com.pblabs.components.basic.HealthEvent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.core.LevelEvent;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.rendering2D.SpriteRenderer;
	
	public class HeartComponent extends EntityComponent
	{
		/*
		 * The amount of life remaining
		 */
		public static var life:int;
		
		/*
		 * Holds a list of all the hearts that are visible to the user
		 */
		private static var _hearts:Vector.<IEntity>;
		
		/*
		 * Holds a list of all the hearts that are invisible
		 */
		private static var _invisibleHearts:Vector.<IEntity>;
		
		public function HeartComponent() {
			super();
		}
		
		override protected function onAdd():void {
			super.onAdd();
			_hearts = new Vector.<IEntity>();
			_invisibleHearts = new Vector.<IEntity>();
			PBE.levelManager.addEventListener(LevelEvent.LEVEL_LOADED_EVENT, registerHearts);
			owner.eventDispatcher.addEventListener(HealthEvent.DIED, removeHeart);
		}
		
		override protected function onRemove():void {
			super.onRemove();
			owner.eventDispatcher.removeEventListener(HealthEvent.DIED, removeHeart);
		}
		
		/*
		 * Wait until the whole level is loaded before managing the hearts
		 * Sets hearts that exceeds the amount of life to invisible and keep the others visible
		 */
		private function registerHearts(event:LevelEvent):void {
			PBE.levelManager.removeEventListener(LevelEvent.LEVEL_LOADED_EVENT, registerHearts);
			var heart:IEntity, renderer:SpriteRenderer, i:int = 1;
			
			while ( heart = PBE.lookup("Heart"+i) as IEntity ) {
				if (i <= HeartComponent.life)
					// Visible
					_hearts.push(heart);
				else {
					// Invisible
					_invisibleHearts.push(heart);
					renderer = heart.lookupComponentByName("Render") as SpriteRenderer;
					renderer.alpha = 0;
				}
				i++;
			}
		}
		
		/*
		 * Remove a heart when the player dies, also manages resurrection and game over cases
		 */
		private function removeHeart (event:HealthEvent):void {
			var length:int = _hearts.length;
			if (length) {
				// Remove a heart if there's one or more remaining
				HeartComponent.life--;
				_hearts[length-1].destroy();
				_hearts.pop();
				
				// Resurrect the player once a heart has been removed
				var healthComponent:HealthComponent = owner.lookupComponentByName("Health") as HealthComponent;
				healthComponent.heal(healthComponent.maxHealth);
			} else {
				// It's game over if the player spent his last life
				
				// Unregister the player from the collision manager
				CollisionManager.instance.stopCollisionsWith(owner.lookupComponentByName("Collisions") as BoundingBoxComponent, CollisionType.PLAYER);
				
				// Kill the player (and its canon)
				owner.destroy();
				PBE.lookup("Canon").destroy();
				
				// Display the game over screen
				(PBE.lookupComponentByName("GameOverScreen", "Render") as SpriteRenderer).alpha = 1;
			}
		}
		
		/*
		 * Add a life to the player by making an invisible heart visible
		 */
		public static function addHeart():void {
			// Retrieve the first invisible heart
			var heart:IEntity = _invisibleHearts.shift();
			
			// Make it visible
			var renderer:SpriteRenderer = heart.lookupComponentByName("Render") as SpriteRenderer;
			renderer.alpha = 1;
			_hearts.push(heart);
			
			HeartComponent.life += 1;
		}
	}
}