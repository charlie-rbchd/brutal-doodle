package com.brutaldoodle.components.animations
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import flash.geom.Point;
	
	public class WiggleObjectComponent extends TickedComponent
	{
		public var positionProperty:PropertyReference;
		public var moveSpeed:Number;
		public var tickRate:Number;
		
		private var startPosition:Point;
		private var _numTicks:int;
		
		public function WiggleObjectComponent()
		{
			super();
			_numTicks = 0;
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			startPosition = owner.getProperty(positionProperty);
		}
		
		
		
		override public function onTick(deltaTime:Number):void {
			super.onTick(deltaTime);
			
			if(_numTicks%tickRate == 0)
				moveSpeed = -moveSpeed;
			_numTicks++;
			
			var pos:Point = owner.getProperty(positionProperty);
			pos.y += moveSpeed;
			
			owner.setProperty(positionProperty,pos);
			
		}
	
	}
}