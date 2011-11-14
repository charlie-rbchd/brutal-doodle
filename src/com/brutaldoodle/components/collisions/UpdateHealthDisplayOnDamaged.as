package com.brutaldoodle.components.collisions
{
	import com.pblabs.components.basic.HealthEvent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.PropertyReference;
	
	import flash.geom.Point;
	
	public class UpdateHealthDisplayOnDamaged extends EntityComponent
	{
		public var sizeProperty:PropertyReference;
		public var positionProperty:PropertyReference;
		
		private var _baseSizeX:Number;
		private var _player:IEntity;
		
		public function UpdateHealthDisplayOnDamaged()
		{
			super();
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			_player = PBE.lookup("Player") as IEntity;
			_player.eventDispatcher.addEventListener(HealthEvent.DAMAGED, onDamaged);
			_player.eventDispatcher.addEventListener(HealthEvent.RESURRECTED, onResurrected);
			_baseSizeX = (owner.getProperty(sizeProperty) as Point).x;
		}
		
		override protected function onRemove():void
		{
			super.onRemove();
			_player.eventDispatcher.removeEventListener(HealthEvent.DAMAGED, onDamaged);
			_player.eventDispatcher.removeEventListener(HealthEvent.RESURRECTED, onResurrected);
		}
		
		private function onDamaged (event:HealthEvent):void
		{
			var position:Point = owner.getProperty(positionProperty);
			var size:Point = owner.getProperty(sizeProperty);
			
			var previousSizeX:Number = size.x;
			size.x = _baseSizeX * event.amount/100;
			position.x -= (previousSizeX - size.x)/2;
			
			owner.setProperty(sizeProperty, size);
			owner.setProperty(positionProperty, position);
		}
		
		private function onResurrected (event:HealthEvent):void {
			var position:Point = owner.getProperty(positionProperty);
			var size:Point = owner.getProperty(sizeProperty);
			
			size.x = _baseSizeX;
			position.x += _baseSizeX/2;
			
			owner.setProperty(sizeProperty, size);
			owner.setProperty(positionProperty, position);
		}
	}
}