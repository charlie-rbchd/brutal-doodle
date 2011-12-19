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

package com.brutaldoodle.components.basic
{
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.PropertyReference;
	
	import flash.text.TextField;
	
	public class MoneyComponent extends EntityComponent
	{
		/*
		 * The amount of coins that the player possess
		 */
		public static var coins:int;
		
		/*
		 * References to the object's properties
		 */
		public var textProperty:PropertyReference;
		
		public function MoneyComponent()
		{
			super();
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			updateText();
		}
		
		/*
		 * Add coins to the current amount and update the display
		 *
		 * @param amount  The amount of coins
		 */
		public function addCoins (amount:int):void {
			MoneyComponent.coins += amount;
			updateText();
		}
		
		/*
		 * Remove coins to the current amount and update the display
		 *
		 * @param amount  The amount of coins
		 */
		public function removeCoins (amount:int):void {
			MoneyComponent.coins -= amount;
			updateText();
		}
		
		/*
		 * Update the amount of coins displayed on screen
		 */
		private function updateText ():void {
			var coins:TextField = owner.getProperty(textProperty);
			coins.text = String(MoneyComponent.coins);
			owner.setProperty(textProperty, coins);
		}
	}
}