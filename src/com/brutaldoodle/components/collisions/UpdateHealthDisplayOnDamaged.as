package com.brutaldoodle.components.collisions
{
	import com.pblabs.components.basic.HealthEvent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.PropertyReference;
	
	import flash.geom.Point;
	
	public class UpdateHealthDisplayOnDamaged extends EntityComponent
	{
		public var sizeProperty:PropertyReference;
		public var positionProperty:PropertyReference;
		
		private var _baseSizeX:Number;
		
		public function UpdateHealthDisplayOnDamaged()
		{
			super();
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			(PBE.lookup("Player") as IEntity).eventDispatcher.addEventListener(HealthEvent.DAMAGED, onDamaged);
			(PBE.lookup("Player") as IEntity).eventDispatcher.addEventListener(HealthEvent.HEALED, onHealed);
			_baseSizeX = (owner.getProperty(sizeProperty) as Point).x;
		}
		
		private function onHealed(event:HealthEvent):void
		{
			
			//TO-DO
			Logger.print(this, "HEALED");
		}
		
		override protected function onRemove():void
		{
			super.onRemove();
			(PBE.lookup("Player") as IEntity).eventDispatcher.removeEventListener(HealthEvent.DAMAGED, onDamaged);
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
	}
}