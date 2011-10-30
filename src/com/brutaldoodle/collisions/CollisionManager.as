package com.brutaldoodle.collisions
{
	import com.brutaldoodle.components.BoundingBoxComponent;
	import com.brutaldoodle.events.CollisionEvent;
	
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
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
		
		/* not working...
		public function reset ():void {
			for each (var zonesVector:Vector.<Zone2D> in _zones) {
				zonesVector = new Vector.<Zone2D>();
			}
		}
		*/
		
		public function registerForCollisions (zone:Zone2D, type:String):void {
			_zones[type].push(zone);
			dispatchEvent(new CollisionEvent(CollisionEvent.COLLISION_ZONE_REGISTERED));
		}
		
		public function stopCollisionsWith (zone:Zone2D, type:String):void {
			var zones:Vector.<Zone2D> = _zones[type];
			var index:int = zones.indexOf(zone);
			
			if (index != -1) {
				(zone as BoundingBoxComponent).zone = new Rectangle(-Infinity, -Infinity, -Infinity, -Infinity); // Because we all like minus infinity...
				zones.splice(index, 1);
			}
			
			dispatchEvent(new CollisionEvent(CollisionEvent.COLLISION_ZONE_UNREGISTERED));
		}
		
		public function getCollidableObjectsByType (type:String):Vector.<Zone2D> {
			return _zones[type];
		}
	}
}