/*
* Brutal Doodle
* Copyright (C) 2011  Joel Robichaud, Maxime Basque, Maxime St-Louis-Fortier, Raphaelle Cantin & Simon Garnier
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.

* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

package com.brutaldoodle.components.collisions
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.IEntityComponent;
	import com.pblabs.rendering2D.SpriteRenderer;
	import com.pblabs.sound.SoundManager;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	public class ChangeVolumeOnDrag extends TickedComponent
	{
		public var dragBoundary:Rectangle;
		public var volumeType:String;
		public var soundBarName:String;
		
		private var _soundBarRenderer:SpriteRenderer;
		private var _soundBarDisplayObject:Sprite;
		private var _renderer:SpriteRenderer;
		private var _displayObject:Sprite;
		private var _displayLoaded:Boolean;
		private var _originalHeight:Number;
		private var _currentY:Number;
		
		public function ChangeVolumeOnDrag()
		{
			super();
			_displayLoaded = false;
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			_renderer = owner.lookupComponentByName("Render") as SpriteRenderer;
			_soundBarRenderer = PBE.lookupComponentByName(soundBarName, "Render") as SpriteRenderer;
		}
		
		override protected function onRemove():void
		{
			super.onRemove();
			if (_displayObject != null && _soundBarDisplayObject != null) {
				with (_soundBarDisplayObject) {
					removeEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
					removeEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
					removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
				}
				
				PBE.mainStage.removeEventListener(MouseEvent.MOUSE_UP, mouseHandler);
				PBE.mainStage.removeEventListener(MouseEvent.MOUSE_MOVE, adjustVolume);
			}
		}
		
		override public function onTick(deltaTime:Number):void
		{
			super.onTick(deltaTime);
			if (!_displayLoaded && _renderer.loaded && _soundBarRenderer.loaded) {
				_displayObject = _renderer.displayObject as Sprite;
				_soundBarDisplayObject = _soundBarRenderer.displayObject as Sprite;
				_originalHeight = _displayObject.height;
				
				with (_soundBarDisplayObject) {
					addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
					addEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
					addEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
					mouseEnabled = true;
				}
				
				_displayLoaded = true;
			}
			
			if (_displayLoaded) {
				_displayObject.x = dragBoundary.x + dragBoundary.width * PBE.soundManager.getCategoryVolume(volumeType);
			}
		}
		
		
		private function mouseHandler (event:MouseEvent):void {
			switch (event.type) {
				case MouseEvent.MOUSE_DOWN:
					this.registerForTicks = false;
					_displayObject.startDrag(true, dragBoundary);
					Mouse.cursor = MouseCursor.HAND;
					
					_displayObject.x = event.stageX - PBE.mainStage.width/2;
					adjustVolume(null);
					
					PBE.mainStage.addEventListener(MouseEvent.MOUSE_MOVE, adjustVolume);
					PBE.mainStage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
					with (_soundBarDisplayObject) {
						removeEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
						removeEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
					}
					break;
				case MouseEvent.MOUSE_OVER:
					Mouse.cursor = MouseCursor.BUTTON;
					break;
				case MouseEvent.MOUSE_UP:
					if(volumeType == "sfx")
						PBE.soundManager.play("../assets/Sounds/PowerUp.mp3");
					this.registerForTicks = true;
					_displayObject.stopDrag();
					PBE.mainStage.removeEventListener(MouseEvent.MOUSE_MOVE, adjustVolume);
					with (_soundBarDisplayObject) {
						addEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
						addEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
					}
				case MouseEvent.MOUSE_OUT:
					Mouse.cursor = MouseCursor.AUTO;
					break;
				default:
					throw new Error();
			}
		}
		
		private function adjustVolume(event:MouseEvent):void{
			var ratio:Number = (_displayObject.x - dragBoundary.x)/dragBoundary.width;
			_displayObject.scaleY = Math.min(1, ratio+0.25);
			PBE.soundManager.setCategoryVolume(volumeType,ratio);
		}
	}
}