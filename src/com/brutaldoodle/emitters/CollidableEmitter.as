package com.brutaldoodle.emitters
{
	import com.brutaldoodle.collisions.CollisionManager;
	import com.brutaldoodle.events.CollisionEvent;
	
	import flash.utils.getQualifiedSuperclassName;
	
	import org.flintparticles.common.events.ParticleEvent;
	import org.flintparticles.twoD.actions.CollisionZone;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.particles.ParticleCreator2D;
	import org.flintparticles.twoD.zones.Zone2D;
	
	public class CollidableEmitter extends Emitter2D
	{
		public static const DEAL_DAMAGE:String = "dealDamage";
		public static const UPDATE_MONEY_COUNT:String = "updateMoneyCount";
		protected var _damageAmount:Number;
		protected var _actionOnCollision:String;
		
		public function CollidableEmitter() {
			super();
			
			_damageAmount = 100;
			_actionOnCollision = CollidableEmitter.DEAL_DAMAGE;
			
			// The name of the unit type is retrieved from the child classes name
			var unitName:String = getQualifiedSuperclassName(this).replace(/.*::(.*)CollidableEmitter/, "$1").toLowerCase();
			var units:Vector.<Zone2D> = CollisionManager.instance.getCollidableObjectsByType(unitName);
			
			for (var i:int = 0; i < units.length; ++i) {
				if (units[i] != null) {
					addAction( new CollisionZone(units[i], 0) );
				}	
			}
			
			addEventListener(ParticleEvent.ZONE_COLLISION, onCollide);
		}
		
		protected function onCollide (event:ParticleEvent):void {
			CollisionManager.instance.dispatchEvent(new CollisionEvent(CollisionEvent.COLLISION_OCCURED, event.otherObject));
			event.particle.isDead = true;
		}
		
		public function get damageAmount ():Number { return _damageAmount; }
		public function set damageAmount (value:Number):void { _damageAmount = value; }
	}
}