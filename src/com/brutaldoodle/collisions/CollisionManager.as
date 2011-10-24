package com.brutaldoodle.collisions
{
	import com.brutaldoodle.events.CollisionEvent;
	import com.pblabs.engine.debug.Logger;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.utils.ObjectUtil;
	
	import org.flintparticles.twoD.zones.Zone2D;

	public class CollisionManager extends EventDispatcher
	{
		private static var _instance:CollisionManager = new CollisionManager();
		
		private var _players:Vector.<Zone2D>;
		private var _enemies:Vector.<Zone2D>;
		private var _allies:Vector.<Zone2D>;
		private var _neutrals:Vector.<Zone2D>;
		
		private var _zones:Dictionary;
		
		public static function get instance ():CollisionManager { return _instance; }
		
		public function CollisionManager() {
			if (instance) throw new Error("CollisionManager can only be accessed through CollisionManager.instance");
		}
		
		public function initialize ():void {
			_players = new Vector.<Zone2D>();
			_enemies = new Vector.<Zone2D>();
			_allies = new Vector.<Zone2D>();
			_neutrals = new Vector.<Zone2D>();
			
			_zones = new Dictionary();
			_zones[CollisionType.NEUTRAL]	= _neutrals;
			_zones[CollisionType.PLAYER]	= _players;
			_zones[CollisionType.ENEMY]		= _enemies;
			_zones[CollisionType.ALLY]		= _allies;
		}
		
		public function registerForCollisions (zone:Zone2D, type:String):void {
			_zones[type].push(zone);
		}
		
		public function stopCollisionsWith (zone:Zone2D, type:String):void {
			var zones:Vector.<Zone2D> = _zones[type];
			var index:int = zones.indexOf(zone);
			
			if (index != -1) {
				dispatchEvent(new CollisionEvent(CollisionEvent.ZONE_UNREGISTERED, zones[index]));
				zones.splice(index, 1);
			}
			
			// TO DO:  Fix the multiple-not-yet-collided-bullets bug (the hitbox is still there for other on-screen bullets after its been collided)
			// HOW TO: Dispatch a custom event here (CollisionEvent.ZONE_UNREGISTERED or something like that)
			//		   Listen to that event in the Emitter (CollisionManager.instance.addEventListener( blah, blah, ... )
			//		   remove the collision from the actions vector inside the emitter, the collision zone would be accessible via event.zone
		}
		
		public function getCollidableObjectsByType (type:String):Vector.<Zone2D> {
			return _zones[type];
		}
	}
}