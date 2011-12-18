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
		public var maxHealth:Number;
		public var destroyOnDeath:Boolean;
		public var damageModifier:Array;
		
		private var _health:Number;
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
			// used to process actions of the damaging object
			_lastDamageOriginator = null;
		}
		
		public function get health ():Number {
			return _health;
		}
		
		public function set health (value:Number):void {
			if (value < 0) value = 0; // negative health would make no sense...
			if (value > maxHealth) value = maxHealth; // can't go over maxHealth
			
			var previousHealth:Number = _health;
			_health = value;
			
			var ev:HealthEvent;
			if (value < previousHealth) { // Owner was damaged.
				ev = new HealthEvent(HealthEvent.DAMAGED, value - previousHealth, value, _lastDamageOriginator);
				owner.eventDispatcher.dispatchEvent(ev);
			}
			if (value == 0) { // Owner just died...
				ev = new HealthEvent(HealthEvent.DIED, value - previousHealth, value, _lastDamageOriginator);
				owner.eventDispatcher.dispatchEvent(ev);
			}
			if (value > previousHealth) { // Owner was healed!
				ev = new HealthEvent(HealthEvent.HEALED, value - previousHealth, value, _lastDamageOriginator);
				owner.eventDispatcher.dispatchEvent(ev);
			}
			if (previousHealth == 0 && value > 0) { // Owner just resurrected and started its own religion.
				ev = new HealthEvent(HealthEvent.RESURRECTED, value - previousHealth, value, _lastDamageOriginator);
				owner.eventDispatcher.dispatchEvent(ev);
			}
			
			// Destruction handling
			if (destroyOnDeath && _health == 0) owner.destroy();
		}
		
		public function damage (amount:Number, damageType:String=null, originator:IEntity=null):void {
			// Store a reference of the damage source
			_lastDamageOriginator = originator;
			
			// Apply damage modifiers depending on the damageType param
			if(damageType && damageModifier.hasOwnProperty(damageType))
				amount *= damageModifier[damageType];
			
			// Apply the damage.
			health -= amount;
			
			// Clear reference for future garbage collect
			_lastDamageOriginator = null;
		}
		
		public function heal (amount:Number, originator:IEntity=null):void {
			// Store a reference of the damage source
			_lastDamageOriginator = originator;
			
			// Heal!
			health += amount;
			
			// Clear reference for future garbage collect
			_lastDamageOriginator = null;
		}
		
		public function get isDead ():Boolean {
			return _health == 0;
		}
	}
}