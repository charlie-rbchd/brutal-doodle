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
	import com.brutaldoodle.components.basic.HeartComponent;
	import com.brutaldoodle.components.basic.MoneyComponent;
	import com.brutaldoodle.components.controllers.CanonController;
	import com.brutaldoodle.components.controllers.PlayerController;
	import com.brutaldoodle.effects.Bullet;
	import com.brutaldoodle.entities.Dialog;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.SpriteSheetRenderer;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.Dictionary;
	
	public class UpdateStatsOnClick extends TickedComponent
	{
		/*
		 * Holds all the current values of all the upgradable stats
		 */
		private static var _statsStatus:Dictionary = new Dictionary();
		
		/*
		 * The money visual display
		 */
		private static var _money:MoneyComponent;
		
		/*
		 * The costs of all the upgrades at each stage
		 */
		private static const UPGRADE_COSTS:Array = new Array(100, 150, 200, 250, 300, 400, 500, 750, 999);
		
		/*
		 * The maximum num of upgrade one can buy
		 */
		private static const MAX_UPGRADE_COUNT:int = 9;
		
		/*
		 * The name of the stat that will be upgraded
		 */
		public var upgradedStat:String;
		
		/*
		 * Reference to the owner's property (current index on the spritesheet)
		 */
		public var numberIndexProperty:PropertyReference;
		
		/*
		 * The display object used by the owner's renderer
		 */
		private var _displayObject:Sprite;
		
		/*
		 * The owner's renderer
		 */
		private var _renderer:SpriteSheetRenderer;
		
		public function UpdateStatsOnClick() {
			super();
		}
		
		/*
		 * Reset all the purshased upgrades to zero
		 */
		public static function resetShop():void {
			_statsStatus = new Dictionary();
		}
		
		override protected function onAdd():void {
			super.onAdd();
			if (!_statsStatus[upgradedStat]) _statsStatus[upgradedStat] = 0;
			_renderer = owner.lookupComponentByName("Render") as SpriteSheetRenderer;
			_money = PBE.lookupComponentByName("AmountOfCoins", "Money") as MoneyComponent;
			
			// Keep the purshased upgrades between visits
			_renderer.spriteIndex = _statsStatus[upgradedStat];
			owner.setProperty(numberIndexProperty, _statsStatus[upgradedStat]);
		}
		
		override protected function onRemove():void {
			super.onRemove();
			with (_displayObject) {
				removeEventListener(MouseEvent.CLICK, updateStats);
				removeEventListener(MouseEvent.MOUSE_OVER, onHover);
				removeEventListener(MouseEvent.MOUSE_OUT, onHover);
			}
		}
		
		override public function onTick(deltaTime:Number):void {
			super.onTick(deltaTime);
			// Register the owner's renderer for click events once the bitmap data is completely loaded
			if (_renderer.bitmapData != null) {
				_displayObject = _renderer.displayObject as Sprite;
				with (_displayObject) {
					mouseEnabled = _statsStatus[upgradedStat] == MAX_UPGRADE_COUNT ? false : true;
					addEventListener(MouseEvent.CLICK, updateStats);
					addEventListener(MouseEvent.MOUSE_OVER, onHover);
					addEventListener(MouseEvent.MOUSE_OUT, onHover);
				}
				this.registerForTicks = false;
			}
		}
		
		/*
		 * Increment the owner's associated stat by one if the player has enough money to buy it
		 */
		private function updateStats (event:MouseEvent):void {
			var cost:int = UPGRADE_COSTS[_statsStatus[upgradedStat]];
			
			// Check if the player has enough money
			if (MoneyComponent.coins - cost < 0) {
				var dialog:Dialog = new Dialog("../assets/Images/NotEnoughMoney.png", new Point(118, 155), new Point(360, 110));
				return;
			}
			
			// Increment the upgrade associated with the owner
			switch (upgradedStat) {
				case "speed":
					PlayerController.moveSpeed += 1; // 19 move speed at max level
					break;
				case "damage":
					Bullet.damage += 6.25; // 81 damage at max level
					break;
				case "life":
					HeartComponent.addHeart(); // 9-12 life at max level
					break;
				case "firerate":
					CanonController.reloadSpeed -= 0.01; // 0.1 reload speed at max level
					break;
				default:
					throw new Error();
			}
			
			// Make the owner unclickable once he purshased the last upgrade
			if (_statsStatus[upgradedStat] == MAX_UPGRADE_COUNT - 1) {
				_displayObject.mouseEnabled = false;
			}
			
			// Apply changes and remove the proper amount of money
			_statsStatus[upgradedStat] += 1;
			_renderer.spriteIndex = _statsStatus[upgradedStat];
			owner.setProperty(numberIndexProperty, _statsStatus[upgradedStat]);
			_money.removeCoins(cost);
			PBE.soundManager.play("../assets/Sounds/PowerUp.mp3");
		}
		
		/*
		 * Change the mouse's appearance when the owner's is hovered
		 */
		private function onHover (event:MouseEvent):void {
			switch (event.type) {
				case MouseEvent.MOUSE_OVER:
					Mouse.cursor = MouseCursor.BUTTON;
					break;
				case MouseEvent.MOUSE_OUT:
					Mouse.cursor = MouseCursor.AUTO;
					break;
				default:
					throw new Error();
			}
		}
	}
}