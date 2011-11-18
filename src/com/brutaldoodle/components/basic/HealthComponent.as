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