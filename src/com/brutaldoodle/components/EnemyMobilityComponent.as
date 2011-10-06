package com.brutaldoodle.components
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.PropertyReference;
	
	import flash.geom.Point;
	
	public class EnemyMobilityComponent extends TickedComponent
	{
		public var maxXmov:uint;
		public var maxYmov:uint;
		
		private var _currentXmov:uint;
		private var _currentYmov:uint;
		
		public var positionProperty:PropertyReference;
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
			
			if (Math.floor(PBE.processManager.virtualTime/1000) % 4 == 2) {
				if (!_currentIterationCompleted) {
					var _position:Point = owner.getProperty(positionProperty);
					
					if (_currentXmov == maxXmov) {
						_currentYmov++;
						
						if (_currentYmov != maxYmov) {
							_currentXmov = 0;
							_position.y += 60;
						} else {
							owner.destroy();
							return;
						}
					} else {
						_currentXmov++;
						_position.x += _currentYmov%2 == 0 ? 60 : -60;
					}
					
					owner.setProperty(positionProperty, _position);
					_currentIterationCompleted = true;
				}
			} else {
				_currentIterationCompleted = false;
			}
		}
	}
}