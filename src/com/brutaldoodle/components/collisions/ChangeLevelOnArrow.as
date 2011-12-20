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
		/*
		 * Constants used in order to easily identify possible arrow orientations
		 */
		public static const ORIENTATION_RIGHT:String = "right";
		public static const ORIENTATION_LEFT:String = "left";
		public static const ORIENTATION_TOP:String = "top";
		
		/*
		 * Holds all the arrows currently on the display list
		 */
		private static var _arrows:Vector.<String> = new Vector.<String>();
		
		/*
		 * References to the owner's properties
		 */
		public var positionProperty:PropertyReference;
		public var sizeProperty:PropertyReference;
		public var alphaProperty:PropertyReference;
		public var displayObjectProperty:PropertyReference;
		
		/*
		 * The orientation of the owner
		 */
		public var orientation:String;
		
		/*
		 * The owner's spatial component
		 */
		private var _playerSpatial:SimpleSpatialComponent;
		
		/*
		 * The owner's renderer
		 */
		private var _renderer:SpriteRenderer;
		
		/*
		 * The display object used by the owner's renderer
		 */
		private var _displayObject:Sprite;
		
		public function ChangeLevelOnArrow() {
			super();
		}
		
		override protected function onAdd():void {
			super.onAdd();
			_arrows.push(orientation);
			_playerSpatial = PBE.lookupComponentByName("Player", "Spatial") as SimpleSpatialComponent;
			
			// If there is no player, we need to retrieve the owner's renderer for later use
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
				// If there's a player, make the arrow interact with the player's position
				var tankPosition:Point = _playerSpatial.position;
				var tankSize:Point = _playerSpatial.size;
				
				var position:Point = owner.getProperty(positionProperty);
				var size:Point = owner.getProperty(sizeProperty);
				
				// Check for the player's position and match it with the orientation and position of the arrow
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
				// If there is no player, we wait for the bitmap data to be loaded and then register the renderer for mouse events
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
		
		/*
		 * Change the mouse's display on hover
		 */
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
		
		/*
		 * Remove the arrow from the list of arrows that you can interact with
		 * The arrows are faded until all the arrows had user interaction, a level is then loaded
		 */
		private function removeArrow(event:MouseEvent=null):void {
			Mouse.cursor = MouseCursor.AUTO;
			var index:int = _arrows.indexOf(orientation);
			
			// If the arrow exists
			if (index != -1) {
				owner.setProperty(alphaProperty, 1);
				_arrows.splice(index, 1);
				
				// Load the next level
				if (!_arrows.length) {
					Main.resetEverythingAndLoadLevel(LevelManager.instance.currentLevel + 1);
				}
			}
		}
	}
}