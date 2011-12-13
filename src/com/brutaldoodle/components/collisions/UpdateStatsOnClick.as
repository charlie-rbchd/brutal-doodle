package com.brutaldoodle.components.collisions
{
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.rendering2D.SpriteRenderer;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	public class UpdateStatsOnClick extends TickedComponent
	{	
		public var upgradedStat:String;
		private var _displayObject:Sprite;
		private var _renderer:SpriteRenderer;
		
		public function UpdateStatsOnClick() {
			super();
		}
		
		override protected function onAdd():void {
			super.onAdd();
			_renderer = owner.lookupComponentByName("Render") as SpriteRenderer;
		}
		
		override protected function onRemove():void{
			super.onRemove();
			with (_displayObject) {
				removeEventListener(MouseEvent.CLICK, updateStats);
				removeEventListener(MouseEvent.MOUSE_OVER, onHover);
				removeEventListener(MouseEvent.MOUSE_OUT, onHover);
			}
		}
		
		override public function onTick(deltaTime:Number):void {
			super.onTick(deltaTime);
			if (_renderer.loaded) {
				_displayObject = _renderer.displayObject as Sprite;
				with (_displayObject) {
					addEventListener(MouseEvent.CLICK, updateStats);
					addEventListener(MouseEvent.MOUSE_OVER, onHover);
					addEventListener(MouseEvent.MOUSE_OUT, onHover);
				}
				this.registerForTicks = false;
			}
		}
		
		private function updateStats (event:MouseEvent):void {
			Logger.print(this, "CLICK EVENT");
			switch (upgradedStat) {
				case "speed":
					Logger.print(this, "SPEED UPGRADED");
					break;
				case "damage":
					Logger.print(this, "DAMAGE UPGRADED");
					break;
				case "life":
					Logger.print(this, "LIFE UPGRADED");
					break;
				case "firerate":
					Logger.print(this, "FIRERATE UPGRADED");
					break;
				default:
					throw new Error();
			}
		}
		
		private function onHover (event:MouseEvent):void {
			Logger.print(this, "SOME EVENT FIRED!");
			switch (event.type) {
				case MouseEvent.MOUSE_OVER:
					Mouse.cursor = MouseCursor.BUTTON;
					Logger.print(this, "MOUSE OVER");
					break;
				case MouseEvent.MOUSE_OUT:
					Mouse.cursor = MouseCursor.AUTO;
					Logger.print(this, "MOUSE OUT");
					break;
				default:
					throw new Error();
			}
		}
	}
}