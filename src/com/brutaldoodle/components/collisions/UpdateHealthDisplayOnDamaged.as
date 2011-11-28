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
		
		public function UpdateHealthDisplayOnDamaged() {
			super();
		}
		
		// listen to the player's damage states
		override protected function onAdd():void {
			super.onAdd();
			_player = PBE.lookup("Player") as IEntity;
			if (_player != null) {
				_player.eventDispatcher.addEventListener(HealthEvent.DAMAGED, onDamaged);
				_player.eventDispatcher.addEventListener(HealthEvent.RESURRECTED, onResurrected);
				_baseSizeX = (owner.getProperty(sizeProperty) as Point).x;
			}
		}
		
		override protected function onRemove():void {
			super.onRemove();
			if (_player != null) {
				_player.eventDispatcher.removeEventListener(HealthEvent.DAMAGED, onDamaged);
				_player.eventDispatcher.removeEventListener(HealthEvent.RESURRECTED, onResurrected);
			}
		}
		
		// remove the proper amount of health inflicted to the player from the health bar
		private function onDamaged (event:HealthEvent):void {
			var position:Point = owner.getProperty(positionProperty);
			var size:Point = owner.getProperty(sizeProperty);
			
			var previousSizeX:Number = size.x;
			size.x = _baseSizeX * event.amount/100;
			// the bar need to be repositionned because PBE's register point is at the center of objects
			position.x -= (previousSizeX - size.x)/2;
			
			owner.setProperty(sizeProperty, size);
			owner.setProperty(positionProperty, position);
		}
		
		// fill up the health bar when the player is resurrected
		private function onResurrected (event:HealthEvent):void {
			var position:Point = owner.getProperty(positionProperty);
			var size:Point = owner.getProperty(sizeProperty);
			
			// revert back to default values...
			size.x = _baseSizeX;
			position.x += _baseSizeX/2;
			
			owner.setProperty(sizeProperty, size);
			owner.setProperty(positionProperty, position);
		}
	}
}