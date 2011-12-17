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
		private static var _gameOver:Boolean = false;
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
			
			if (_gameOver) {
				owner.destroy();
				(PBE.lookupComponentByName("GameOverScreen", "Render") as SpriteRenderer).alpha = 1;
				return;
			}
			
			if (Math.floor(PBE.processManager.virtualTime/1000*moveSpeed) % 4 == 2) {
				if (!_currentIterationComplete) {
					var position:Point = owner.getProperty(positionProperty);
					var boundingBox:Rectangle = owner.getProperty(boundingBoxProperty);
					
					if (owner === _enemies[0]) {
						var leftBB:Rectangle = _leftEnemy.getProperty(boundingBoxProperty);
						var rightBB:Rectangle = _rightEnemy.getProperty(boundingBoxProperty);
						var bottomBB:Rectangle = _bottomEnemy.getProperty(boundingBoxProperty);
						
						if ( (_direction ==  1 && rightBB.right + LATERAL_DISPLACEMENT >=  PBE.mainStage.stageWidth/2) ||
							 (_direction == -1 && leftBB.left   - LATERAL_DISPLACEMENT <= -PBE.mainStage.stageWidth/2) )
						{
							_moveDown = true;
							_direction = -_direction;
						}
						
						if (_moveDown && bottomBB.bottom + VERTICAL_DISPLACEMENT * 2 >= PBE.mainStage.stageHeight/2) {
							_gameOver = true;
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
			if (!_gameOver) findEdgeEnemies();
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
		
		private function findEdgeEnemies ():void {
			_leftEnemy = null;
			_rightEnemy = null;
			_bottomEnemy = null;
			
			if (_enemies.length != 0)
			{
				var leftX:int = -1;
				var rightX:int = -1;
				var bottomY:int = -1;
				
				for each (var currentOwner:IEntity in _enemies) {
					var position:Point = currentOwner.getProperty(positionProperty);
					
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