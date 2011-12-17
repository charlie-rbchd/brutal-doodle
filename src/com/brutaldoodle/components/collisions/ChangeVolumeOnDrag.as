package com.brutaldoodle.components.collisions
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.rendering2D.SpriteRenderer;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class ChangeVolumeOnDrag extends TickedComponent
	{
		public var dragBoundary:Rectangle;
		public var volumeType:String;
		
		private var _renderer:SpriteRenderer;
		private var _displayObject:Sprite;
		
		public function ChangeVolumeOnDrag()
		{
			super();
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			_renderer = owner.lookupComponentByName("Render") as SpriteRenderer;
			Logger.print(this, String(dragBoundary));
		}
		
		override protected function onRemove():void
		{
			super.onRemove();
			if (_displayObject != null) {
				with (_displayObject) {
					removeEventListener(MouseEvent.MOUSE_DOWN, startDrag);
					removeEventListener(MouseEvent.MOUSE_UP, stopDrag);
				}
			}
		}
		
		override public function onTick(deltaTime:Number):void
		{
			super.onTick(deltaTime);
			if (_renderer.loaded) {
				_displayObject = _renderer.displayObject as Sprite;
				
				with (_displayObject) {
					mouseEnabled = true;
					addEventListener(MouseEvent.MOUSE_DOWN, startDrag);
					addEventListener(MouseEvent.MOUSE_UP, stopDrag);
				}
				
				this.registerForTicks = false;
			}
		}
		
		private function startDrag (event:MouseEvent):void {
			_displayObject.startDrag(false, dragBoundary);
		}
		
		private function stopDrag (event:MouseEvent):void {
			_displayObject.stopDrag();
		}
	}
}