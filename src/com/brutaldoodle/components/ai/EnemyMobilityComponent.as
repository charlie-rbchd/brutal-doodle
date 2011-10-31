package com.brutaldoodle.components.ai
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.entity.PropertyReference;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class EnemyMobilityComponent extends TickedComponent
	{
		private const LATERAL_DISPLACEMENT:uint = 30;
		private const VERTICAL_DISPLACEMENT:uint = 60;
		private const MAX_X_MOV:uint = 12;
		private const MAX_Y_MOV:uint = 6;
		
		public static var moveSpeed:uint = 1;
		public var positionProperty:PropertyReference;
		public var boundingBoxProperty:PropertyReference;
		
		private var _currentXmov:uint;
		private var _currentYmov:uint;
		private var _currentIterationCompleted:Boolean;
		
		public function EnemyMobilityComponent()
		{
			super();
			_currentIterationCompleted = false;
			_currentXmov = _currentYmov = 0;
		}
		
		override public function onTick(deltaTime:Number):void
		{
			super.onTick(deltaTime);
			
			if (Math.floor(PBE.processManager.virtualTime/1000*moveSpeed) % 4 == 2) {
				if (!_currentIterationCompleted) {
					var _position:Point = owner.getProperty(positionProperty);
					var _boundingBox:Rectangle = owner.getProperty(boundingBoxProperty) as Rectangle;
					
					if (_currentXmov == MAX_X_MOV) {
						_currentYmov++;
						
						if (_currentYmov != MAX_Y_MOV) {
							_currentXmov = 0;
							_position.y += VERTICAL_DISPLACEMENT;
							_boundingBox.top += VERTICAL_DISPLACEMENT;
							_boundingBox.bottom += VERTICAL_DISPLACEMENT;
						} else {
							owner.destroy();
							return;
						}
					} else {
						_currentXmov++;
						_position.x += !(_currentYmov & 1) ? LATERAL_DISPLACEMENT : -LATERAL_DISPLACEMENT;
						_boundingBox.left += !(_currentYmov & 1) ? LATERAL_DISPLACEMENT : -LATERAL_DISPLACEMENT;
						_boundingBox.right += !(_currentYmov & 1) ? LATERAL_DISPLACEMENT : -LATERAL_DISPLACEMENT;
					}
					
					owner.setProperty(positionProperty, _position);
					owner.setProperty(boundingBoxProperty, _boundingBox);
					_currentIterationCompleted = true;
				}
			} else {
				_currentIterationCompleted = false;
			}
		}
	}
}