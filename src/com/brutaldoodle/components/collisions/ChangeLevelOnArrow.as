package com.brutaldoodle.components.collisions
{
	import com.brutaldoodle.collisions.CollisionManager;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.core.LevelManager;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import flash.geom.Point;
	
	public class ChangeLevelOnArrow extends TickedComponent {
		private static var _arrows:Vector.<String> = new Vector.<String>();
		
		public var positionProperty:PropertyReference;
		public var sizeProperty:PropertyReference;
		public var alphaProperty:PropertyReference;
		public var orientation:String;
		
		public function ChangeLevelOnArrow() {
			super();
		}
		
		override protected function onAdd():void {
			super.onAdd();
			_arrows.push(orientation);
		}
		
		override public function onTick(deltaTime:Number):void {
			super.onTick(deltaTime);
			
			var spatial:SimpleSpatialComponent = PBE.lookupComponentByName("Player", "Spatial") as SimpleSpatialComponent;
			var tankPosition:Point = spatial.position;
			var tankSize:Point = spatial.size;
			
			var position:Point = owner.getProperty(positionProperty);
			var size:Point = owner.getProperty(sizeProperty);
			
			if (orientation == "right")
			{
				if (tankPosition.x + tankSize.x >= position.x) {
					removeArrow();
				}
			}
			else if (orientation == "left")
			{
				if (tankPosition.x - tankSize.x <= position.x) {
					removeArrow();
				}
			}
			else if (orientation == "top")
			{
				if (tankPosition.y - tankSize.y <= position.y && tankPosition.x <= position.x + 10 && tankPosition.x >= position.x - 10) {
						removeArrow();
				}
			}

			if (!_arrows.length) {
				Main.resetEverythingAndLoadLevel(LevelManager.instance.currentLevel + 1);
			}
		}
		
		private function removeArrow():void {
			var index:int = _arrows.indexOf(orientation);
			
			if (index != -1) {
				var alpha:Number = owner.getProperty(alphaProperty);
				alpha = 1;
				_arrows.splice(index, 1);
				owner.setProperty(alphaProperty, alpha);
			}
		}
	}
}