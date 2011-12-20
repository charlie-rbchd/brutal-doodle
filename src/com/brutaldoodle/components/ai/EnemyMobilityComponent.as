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
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	import com.pblabs.rendering2D.SpriteRenderer;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class EnemyMobilityComponent extends TickedComponent {
		/*
		 * The speed at which the invaders are displaced
		 */
		public static var moveSpeed:uint = 1;
		
		/*
		 * References to the owner's properties
		 */
		public var sizeProperty:PropertyReference;
		public var positionProperty:PropertyReference;
		public var boundingBoxProperty:PropertyReference;
		
		/*
		 * Constants used in order to easily access vertical and lateral displacement values
		 */
		private const LATERAL_DISPLACEMENT:uint = 30;
		private const VERTICAL_DISPLACEMENT:uint = 60;
		
		/*
		 * Holds references to all the enemies that need to move
		 */
		private static var _enemies:Vector.<IEntity> = new Vector.<IEntity>();
		
		/*
		 * The left-most enemy (used for collisions checks with scene boundaries)
		 */
		private static var _leftEnemy:IEntity = null;
		
		/*
		 * The right-most enemy (used for collisions checks with scene boundaries)
		 */
		private static var _rightEnemy:IEntity = null;
		
		/*
		 * The bottom-most enemy (used for collisions checks with scene boundaries)
		 */
		private static var _bottomEnemy:IEntity = null;
		
		/*
		 * Whether or not the invaders should move down on their next tick
		 */
		private static var _moveDown:Boolean = false;
		
		/*
		 * The direction in which the invaders should move each tick (1 for right, -1 for left)
		 */
		private static var _direction:int = 1;
		
		private var _currentIterationComplete:Boolean;
		
		public function EnemyMobilityComponent() {
			super();
			_currentIterationComplete = false;
			updatePriority = 100;
		}
		
		override public function onTick(deltaTime:Number):void {
			super.onTick(deltaTime);
			
			// Destroy all the enemies and the game over screen when the game is over
			if (Main.gameOver) {
				owner.destroy();
				(PBE.lookupComponentByName("GameOverScreen", "Render") as SpriteRenderer).alpha = 1;
				return;
			}
			
			// Move the enemies every time the amount of ticks corresponds to the result of an equation based on the move speed
			if (Math.floor(PBE.processManager.virtualTime/1000 * moveSpeed) % 4 == 2) {
				if (!_currentIterationComplete) {
					// Retrieve the properties that need to be changed
					var position:Point = owner.getProperty(positionProperty);
					var boundingBox:Rectangle = owner.getProperty(boundingBoxProperty);
					
					// Check if the enemies need to change direction or move down, this only need to be done once
					if (owner === _enemies[0]) {
						// Retrieve the positions needed to check for collisions with scene boundaries
						var leftPos:Point = _leftEnemy.getProperty(positionProperty);
						var rightPos:Point = _rightEnemy.getProperty(positionProperty);
						var bottomPos:Point = _bottomEnemy.getProperty(positionProperty);
						// Retrieve the sizes needed to check for collisions with scene boundaries
						var leftSize:Point = _leftEnemy.getProperty(sizeProperty);
						var rightSize:Point = _rightEnemy.getProperty(sizeProperty);
						var bottomSize:Point = _bottomEnemy.getProperty(sizeProperty);
						
						// Check if the enemies need to move down and change direction
						if ( (_direction ==  1 && rightPos.x + rightSize.x/2 + LATERAL_DISPLACEMENT >=  PBE.mainStage.stageWidth/2) ||
							 (_direction == -1 && leftPos.x - leftSize.x/2   - LATERAL_DISPLACEMENT <= -PBE.mainStage.stageWidth/2) )
						{
							_moveDown = true;
							_direction = -_direction;
						}
						
						// Check if the enemies are low enough that the next movement will make the game end
						if (_moveDown && bottomPos.y + bottomSize.y/2 + VERTICAL_DISPLACEMENT * 3 >= PBE.mainStage.stageHeight/2) {
							Main.gameOver = true;
						}
					}
					
					if (_moveDown) {
						// Move the enemy down if they need to do so
						position.y += VERTICAL_DISPLACEMENT;
						boundingBox.top += VERTICAL_DISPLACEMENT;
						boundingBox.bottom += VERTICAL_DISPLACEMENT;
						// Stop moving down after the last enemy moved down
						if (owner === _enemies[_enemies.length-1]) _moveDown = false;
					} else {
						// Otherwise, make them move horizontaly
						position.x += LATERAL_DISPLACEMENT * _direction;
						boundingBox.left += LATERAL_DISPLACEMENT * _direction;
						boundingBox.right += LATERAL_DISPLACEMENT * _direction;
					}
					
					// Apply the changes
					owner.setProperty(positionProperty, position);
					owner.setProperty(boundingBoxProperty, boundingBox);
					_currentIterationComplete = true;
				}
			} else {
				_currentIterationComplete = false;
			}
		}
		
		override protected function onAdd():void {
			super.onAdd();
			_enemies.push(owner);
			// Check if it changed the edge enemies
			findEdgeEnemies();
			// Assign a bounding box to the owner
			getCollisionsZone();
		}
		
		override protected function onRemove():void {
			super.onRemove(); 
			_enemies.splice(_enemies.indexOf(owner), 1);
			
			// Speed up the enemies every 7 deaths
			if (_enemies.length % 7 == 0) moveSpeed++;
			
			// Only check for edge enemies if the game is not over
			if (!Main.gameOver) findEdgeEnemies();
		}
		
		/*
		 * Assign a bounding box component to the owner that have the same size and position as him
		 * This is used to dynamically place the bounding box of each enemy instead of writing extensive XML
		 */
		private function getCollisionsZone ():void {
			var size:Point = owner.getProperty(sizeProperty);
			var position:Point = owner.getProperty(positionProperty);
			var boundingBox:Rectangle = new Rectangle();
			
			boundingBox.left = position.x - size.x/2;
			boundingBox.right = position.x + size.x/2;
			boundingBox.top = position.y - size.y/2;
			boundingBox.bottom = position.y + size.y/2;
			
			owner.setProperty(boundingBoxProperty, boundingBox);
		}
		
		/*
		 * Find the left-most, right-most and bottom-most enemies
		 * This should be called every time an enemy dies or change places with another unit
		 */
		public static function findEdgeEnemies ():void {
			_leftEnemy = null;
			_rightEnemy = null;
			_bottomEnemy = null;
			
			if (_enemies.length != 0)
			{
				var leftX:int = -1;
				var rightX:int = -1;
				var bottomY:int = -1;
				
				// Loop through all the enemies and assign it if he has a better spot than any preceeding enemy
				for each (var currentOwner:IEntity in _enemies) {
					var position:Point = (currentOwner.lookupComponentByName("Spatial") as SimpleSpatialComponent).position;
					
					// Left-most enemy checks
					if (leftX == -1 || position.x < leftX)
					{
						leftX = position.x;
						_leftEnemy = currentOwner;
					}
					
					// Right-most enemy checks
					if (rightX == -1 || position.x > rightX)
					{
						rightX = position.x;
						_rightEnemy = currentOwner;
					}
					
					// Bottom-most enemy checks
					if (bottomY == -1 || position.y > bottomY)
					{
						bottomY = position.y;
						_bottomEnemy = currentOwner;
					}
				}
			}
			else
			{
				// If there are no more enemies, the player completed the level
				var victoryScreen:SpriteRenderer = PBE.lookupComponentByName("VictoryScreen", "Render") as SpriteRenderer;
				if (victoryScreen != null) victoryScreen.alpha = 1;
			}
		}
		
		/*
		 * Reset all the static variables to their default values
		 * This fonction should be called between every level
		 */
		public static function reset ():void {
			_leftEnemy = null;
			_rightEnemy = null;
			_bottomEnemy = null;
			_moveDown = false;
			_direction = 1;
			moveSpeed = 1;
		}
	}
}