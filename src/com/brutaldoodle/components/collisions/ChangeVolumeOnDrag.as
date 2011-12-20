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
	import com.pblabs.rendering2D.SpriteRenderer;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	public class ChangeVolumeOnDrag extends TickedComponent
	{
		/*
		 * The boundary that defines the limits within which you can drag the controls
		 */
		public var dragBoundary:Rectangle;
		
		/*
		 * The type of volume (either sfx or music)
		 */
		public var volumeType:String;
		
		/*
		 * The name of the associated sound bar entity
		 */
		public var soundBarName:String;
		
		/*
		 * The sound bar's renderer
		 */
		private var _soundBarRenderer:SpriteRenderer;
		
		/*
		 * The display object used by the sound bar's renderer
		 */
		private var _soundBarDisplayObject:Sprite;
		
		/*
		 * The owner's renderer
		 */
		private var _renderer:SpriteRenderer;
		
		/*
		 * The display object used by the owner's renderer
		 */
		private var _displayObject:Sprite;
		
		/*
		 * Whether or not all the necessary bitmap datas are loaded
		 */
		private var _displayLoaded:Boolean;
		
		/*
		 * The original height of the owner (used to restore the height)
		 */
		private var _originalHeight:Number;
		
		/*
		 * The current y axis position of the owner
		 */
		private var _currentY:Number;
		
		public function ChangeVolumeOnDrag()
		{
			super();
			_displayLoaded = false;
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			// Retrieve the necessary renderers
			_renderer = owner.lookupComponentByName("Render") as SpriteRenderer;
			_soundBarRenderer = PBE.lookupComponentByName(soundBarName, "Render") as SpriteRenderer;
		}
		
		override protected function onRemove():void
		{
			super.onRemove();
			
			// Remove all the event listeners that we added to display objects by this class
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
			// Wait for all the renderers to load their bitmap data
			if (!_displayLoaded && _renderer.loaded && _soundBarRenderer.loaded) {
				_displayObject = _renderer.displayObject as Sprite;
				_soundBarDisplayObject = _soundBarRenderer.displayObject as Sprite;
				_originalHeight = _displayObject.height;
				
				// Add event listeners for mouse events to the renderers
				with (_soundBarDisplayObject) {
					addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
					addEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
					addEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
					mouseEnabled = true;
				}
				
				_displayLoaded = true;
			}
			
			// Make sure that the owner stay aligned with the current volume at all time
			if (_displayLoaded) {
				_displayObject.x = dragBoundary.x + dragBoundary.width * PBE.soundManager.getCategoryVolume(volumeType);
			}
		}
		
		/*
		 * 
		 * 
		 */
		private function mouseHandler (event:MouseEvent):void {
			switch (event.type) {
				case MouseEvent.MOUSE_DOWN: // Start dragging on mouse down
					this.registerForTicks = false;
					_displayObject.startDrag(true, dragBoundary);
					Mouse.cursor = MouseCursor.HAND;
					
					_displayObject.x = event.stageX - PBE.mainStage.width/2;
					adjustVolume(); // Set the new volume
					
					// Listen to mouse up and move events while dragging, other events are not needed
					with (_soundBarDisplayObject) {
						removeEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
						removeEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
					}
					PBE.mainStage.addEventListener(MouseEvent.MOUSE_MOVE, adjustVolume);
					PBE.mainStage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
					break;
				case MouseEvent.MOUSE_OVER: // Change cursor on hover
					Mouse.cursor = MouseCursor.BUTTON;
					break;
				case MouseEvent.MOUSE_UP: // Stop dragging on mouse up
					// Play a sound effect so the user can preview how loud is the new volume
					if (volumeType == "sfx") {
						PBE.soundManager.play("../assets/Sounds/PowerUp.mp3");
					}
					this.registerForTicks = true;
					_displayObject.stopDrag();
					
					with (_soundBarDisplayObject) {
						addEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
						addEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
					}
					PBE.mainStage.removeEventListener(MouseEvent.MOUSE_MOVE, adjustVolume);
				case MouseEvent.MOUSE_OUT: // Revert the cursor to default on mouse out
					Mouse.cursor = MouseCursor.AUTO;
					break;
				default:
					throw new Error();
			}
		}
		
		/*
		 * Adjust the volume and scale the owner depending on the new volume
		 */
		private function adjustVolume(event:MouseEvent=null):void{
			var ratio:Number = (_displayObject.x - dragBoundary.x)/dragBoundary.width;
			_displayObject.scaleY = Math.min(1, ratio + 0.25);
			PBE.soundManager.setCategoryVolume(volumeType, ratio);
		}
	}
}