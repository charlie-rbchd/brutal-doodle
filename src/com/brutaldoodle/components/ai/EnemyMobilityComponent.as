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
		public static var moveSpeed:uint;
		
		public var sizeProperty:PropertyReference;
		public var positionProperty:PropertyReference;
		public var boundingBoxProperty:PropertyReference;
		
		private const LATERAL_DISPLACEMENT:uint = 30;
		private const VERTICAL_DISPLACEMENT:uint = 60;
		
		private static var _enemies:Vector.<IEntity> = new Vector.<IEntity>();
		private static var _leftEnemy:IEntity = null;
		private static var _rightEnemy:IEntity = null;
		private static var _bottomEnemy:IEntity = null;
		private static var _moveDown:Boolean = false;
		private static var _direction:int = 1;
		
		private var _currentIterationComplete:Boolean;
		
		public function EnemyMobilityComponent() {
			super();
			_currentIterationComplete = false;
			updatePriority = 100;
		}
		
		override public function onTick(deltaTime:Number):void {
			super.onTick(deltaTime);
			
			if (Main.gameOver) {
				owner.destroy();
				(PBE.lookupComponentByName("GameOverScreen", "Render") as SpriteRenderer).alpha = 1;
				return;
			}
			
			if (Math.floor(PBE.processManager.virtualTime/1000*moveSpeed) % 4 == 2) {
				if (!_currentIterationComplete) {
					var position:Point = owner.getProperty(positionProperty);
					var boundingBox:Rectangle = owner.getProperty(boundingBoxProperty);
					
					if (owner === _enemies[0]) {
						var leftPos:Point = _leftEnemy.getProperty(positionProperty);
						var rightPos:Point = _rightEnemy.getProperty(positionProperty);
						var bottomPos:Point = _bottomEnemy.getProperty(positionProperty);
						
						var leftSize:Point = _leftEnemy.getProperty(sizeProperty);
						var rightSize:Point = _rightEnemy.getProperty(sizeProperty);
						var bottomSize:Point = _bottomEnemy.getProperty(sizeProperty);
						
						if ( (_direction ==  1 && rightPos.x + rightSize.x/2 + LATERAL_DISPLACEMENT >=  PBE.mainStage.stageWidth/2) ||
							 (_direction == -1 && leftPos.x - leftSize.x/2   - LATERAL_DISPLACEMENT <= -PBE.mainStage.stageWidth/2) )
						{
							_moveDown = true;
							_direction = -_direction;
						}
						
						if (_moveDown && bottomPos.y + bottomSize.y/2 + VERTICAL_DISPLACEMENT * 3 >= PBE.mainStage.stageHeight/2) {
							Main.gameOver = true;
						}
					}
					
					if (_moveDown) {
						position.y += VERTICAL_DISPLACEMENT;
						boundingBox.top += VERTICAL_DISPLACEMENT;
						boundingBox.bottom += VERTICAL_DISPLACEMENT;
						if (owner === _enemies[_enemies.length-1]) _moveDown = false;
					} else {
						position.x += LATERAL_DISPLACEMENT * _direction;
						boundingBox.left += LATERAL_DISPLACEMENT * _direction;
						boundingBox.right += LATERAL_DISPLACEMENT * _direction;
					}
					
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
			findEdgeEnemies();
			getCollisionsZone();
		}
		
		override protected function onRemove():void {
			super.onRemove();
			_enemies.splice(_enemies.indexOf(owner), 1);
			if (_enemies.length % 7 == 0) moveSpeed++;
			if (!Main.gameOver) findEdgeEnemies();
		}
		
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
		
		public static function findEdgeEnemies ():void {
			_leftEnemy = null;
			_rightEnemy = null;
			_bottomEnemy = null;
			
			if (_enemies.length != 0)
			{
				var leftX:int = -1;
				var rightX:int = -1;
				var bottomY:int = -1;
				
				for each (var currentOwner:IEntity in _enemies) {
					var position:Point = (currentOwner.lookupComponentByName("Spatial") as SimpleSpatialComponent).position;
					
					if (leftX == -1 || position.x < leftX)
					{
						leftX = position.x;
						_leftEnemy = currentOwner;
					}
					
					if (rightX == -1 || position.x > rightX)
					{
						rightX = position.x;
						_rightEnemy = currentOwner;
					}
					
					if (bottomY == -1 || position.y > bottomY)
					{
						bottomY = position.y;
						_bottomEnemy = currentOwner;
					}
				}
			}
			else
			{
				var victoryScreen:SpriteRenderer = PBE.lookupComponentByName("VictoryScreen", "Render") as SpriteRenderer;
				if (victoryScreen != null) victoryScreen.alpha = 1;
			}
		}
	}
}