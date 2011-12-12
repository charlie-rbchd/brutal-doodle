package com.brutaldoodle.components.collisions
{
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.rendering2D.SpriteRenderer;
	import com.pblabs.rendering2D.SpriteSheetRenderer;
	import com.pblabs.rendering2D.spritesheet.SpriteContainerComponent;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	public class UpdateStatsOnClick extends TickedComponent{
		public var statToUpdate:String;
		private var _displayObject:Sprite;
		private var _renderer:SpriteRenderer;
		
		public function UpdateStatsOnClick(){
			super();
		}
		
		override protected function onAdd():void {
			super.onAdd();
			_renderer = owner.lookupComponentByName("Render") as SpriteRenderer;
			
		}
		
		override public function onTick(deltaTime:Number):void {
			super.onTick(deltaTime);
			if (_renderer.loaded) {
				
				_displayObject = _renderer.displayObject as Sprite;
				with (_displayObject) {
					Logger.print(this, "woot");
					addEventListener(MouseEvent.CLICK, updateStats);
					addEventListener(MouseEvent.MOUSE_OVER, onHover);
					addEventListener(MouseEvent.MOUSE_OUT, onHover);
				}
				this.registerForTicks = false;
			}
		}
		
		override protected function onRemove():void{
			super.onRemove();
			with (_displayObject) {
				removeEventListener(MouseEvent.CLICK, updateStats);
				removeEventListener(MouseEvent.MOUSE_OVER, onHover);
				removeEventListener(MouseEvent.MOUSE_OUT, onHover);
			}
		}
		
		private function updateStats(event:MouseEvent):void{
		
		}
		
		private function onHover(event:MouseEvent):void{
			//that color matrix magic
			
			
			switch (event.type) {
				case MouseEvent.MOUSE_OVER:
					Mouse.cursor = MouseCursor.BUTTON;
					break;
				case MouseEvent.MOUSE_OUT:
					Mouse.cursor = MouseCursor.AUTO;
					break;
				default:
			}
		}
	}
}