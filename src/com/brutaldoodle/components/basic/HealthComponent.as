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
	import com.pblabs.components.basic.HealthEvent;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;
	
	public class HealthComponent extends EntityComponent
	{
		/*
		 * The maxmimum amount of health
		 */
		public var maxHealth:Number;
		
		/*
		 * Whether or not the owner should be destroyed when he dies
		 */
		public var destroyOnDeath:Boolean;
		
		/*
		 * The modifiers applied to the damage done
		 */
		public var damageModifier:Array;
		
		/*
		 * The current amount of health
		 */
		private var _health:Number;
		
		/*
		 * The last source of damage
		 */
		private var _lastDamageOriginator:IEntity;
		
		public function HealthComponent() {
			super();
			maxHealth = 100;
			destroyOnDeath = true;
			damageModifier = new Array();
		}
		
		override protected function onAdd():void {
			super.onAdd();
			_health = maxHealth;
			_lastDamageOriginator = null;
		}
		
		/*
		 * Dispatch events that represent the status of the owner's health
		 * 
		 * @param value  The amount of health
		 */
		public function set health (value:Number):void {
			if (value < 0) value = 0; // No negative health
			if (value > maxHealth) value = maxHealth; // Can't go over the specified maximum health
			
			var previousHealth:Number = _health;
			_health = value;
			
			var ev:HealthEvent;
			if (value < previousHealth) { // Owner was damaged
				ev = new HealthEvent(HealthEvent.DAMAGED, value - previousHealth, value, _lastDamageOriginator);
				owner.eventDispatcher.dispatchEvent(ev);
			}
			if (value == 0) { // Owner just died
				ev = new HealthEvent(HealthEvent.DIED, value - previousHealth, value, _lastDamageOriginator);
				owner.eventDispatcher.dispatchEvent(ev);
			}
			if (value > previousHealth) { // Owner was healed
				ev = new HealthEvent(HealthEvent.HEALED, value - previousHealth, value, _lastDamageOriginator);
				owner.eventDispatcher.dispatchEvent(ev);
			}
			if (previousHealth == 0 && value > 0) { // Owner was resurrected
				ev = new HealthEvent(HealthEvent.RESURRECTED, value - previousHealth, value, _lastDamageOriginator);
				owner.eventDispatcher.dispatchEvent(ev);
			}
			
			// Destroy the owner if he's dead
			if (destroyOnDeath && _health == 0) owner.destroy();
		}
		
		/*
		 * Apply a certain amount of damage to the owner
		 * 
		 * @param amount  The amount of damage dealt
		 * @param damageType  The type of damage
		 * @param originator  The source of damage
		 */
		public function damage (amount:Number, damageType:String=null, originator:IEntity=null):void {
			_lastDamageOriginator = originator;
			
			if (damageType && damageModifier.hasOwnProperty(damageType)) {
				amount *= damageModifier[damageType];
			}
			
			health -= amount;
			_lastDamageOriginator = null;
		}
		
		/*
		 * Heal the owner of a certain amount of damage
		 *
		 * @param amount  The amount of damage healed
		 * @param originator  The source of heal
		 */
		public function heal (amount:Number, originator:IEntity=null):void {
			_lastDamageOriginator = originator;
			health += amount;
			_lastDamageOriginator = null;
		}
		
		public function get isDead ():Boolean {
			return _health == 0;
		}
		
		public function get health ():Number {
			return _health;
		}
	}
}