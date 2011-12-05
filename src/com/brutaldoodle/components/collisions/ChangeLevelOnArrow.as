package com.brutaldoodle.components.collisions
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.core.LevelManager;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	import com.pblabs.rendering2D.SpriteRenderer;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	public class ChangeLevelOnArrow extends TickedComponent {
		public static const ORIENTATION_RIGHT:String = "right";
		public static const ORIENTATION_LEFT:String = "left";
		public static const ORIENTATION_TOP:String = "top";
		
		private static var _arrows:Vector.<String> = new Vector.<String>();
		
		public var positionProperty:PropertyReference;
		public var sizeProperty:PropertyReference;
		public var alphaProperty:PropertyReference;
		public var displayObjectProperty:PropertyReference;
		public var orientation:String;
		
		private var _playerSpatial:SimpleSpatialComponent;
		private var _renderer:SpriteRenderer;
		private var _displayObject:Sprite;
		
		public function ChangeLevelOnArrow() {
			super();
		}
		
		override protected function onAdd():void {
			super.onAdd();
			_arrows.push(orientation);
			_playerSpatial = PBE.lookupComponentByName("Player", "Spatial") as SimpleSpatialComponent;
			
			if (_playerSpatial == null) {
				_renderer = owner.lookupComponentByName("Render") as SpriteRenderer;
			}
		}
		
		override protected function onRemove():void {
			super.onRemove();
			if (_displayObject != null) {
				with (_displayObject) {
					removeEventListener(MouseEvent.CLICK, removeArrow);
					removeEventListener(MouseEvent.MOUSE_OVER, onHover);
					removeEventListener(MouseEvent.MOUSE_OUT, onHover);
				}
			}
		}
		
		override public function onTick(deltaTime:Number):void {
			super.onTick(deltaTime);
			
			if (_playerSpatial != null) {
				var tankPosition:Point = _playerSpatial.position;
				var tankSize:Point = _playerSpatial.size;
				
				var position:Point = owner.getProperty(positionProperty);
				var size:Point = owner.getProperty(sizeProperty);
				
				switch (orientation) {
					case ORIENTATION_RIGHT:
						if (tankPosition.x + tankSize.x >= position.x) {
							removeArrow();
						}
						break;
					case ORIENTATION_LEFT:
						if (tankPosition.x - tankSize.x <= position.x) {
							removeArrow();
						}
						break;
					case ORIENTATION_TOP:
						if (tankPosition.y - tankSize.y <= position.y && tankPosition.x <= position.x + 10 && tankPosition.x >= position.x - 10) {
							removeArrow();
						}
						break;
					default:
						throw new Error("Orientation property value must correspond on of ChangeLevelOnArrow's constant value.");
				}
			} else {
				if (_renderer.loaded) {
					_displayObject = _renderer.displayObject as Sprite;
					with (_displayObject) {
						addEventListener(MouseEvent.CLICK, removeArrow);
						addEventListener(MouseEvent.MOUSE_OVER, onHover);
						addEventListener(MouseEvent.MOUSE_OUT, onHover);
					}
					this.registerForTicks = false;
				}
			}
		}
		
		private function onHover(event:MouseEvent):void {
			switch (event.type) {
				case MouseEvent.MOUSE_OVER:
					owner.setProperty(alphaProperty, 1);
					Mouse.cursor = MouseCursor.BUTTON;
					break;
				case MouseEvent.MOUSE_OUT:
					owner.setProperty(alphaProperty, 0.5);
					Mouse.cursor = MouseCursor.AUTO;
					break;
				default:
			}
		}
		
		private function removeArrow(event:MouseEvent=null):void {
			Mouse.cursor = MouseCursor.AUTO;
			var index:int = _arrows.indexOf(orientation);
			
			if (index != -1) {
				owner.setProperty(alphaProperty, 1);
				
				_arrows.splice(index, 1);
				if (!_arrows.length) {
					Main.resetEverythingAndLoadLevel(LevelManager.instance.currentLevel + 1);
				}
			}
		}
	}
}