package com.brutaldoodle.events
{
	import flash.events.Event;
	
	import org.flintparticles.twoD.zones.Zone2D;
	
	public class CollisionEvent extends Event
	{
		public static const COLLISION_OCCURED:String = "collisionOccured";
		public static const COLLISION_ZONE_UNREGISTERED:String = "collisionZoneUnregistered";
		public static const COLLISION_ZONE_REGISTERED:String = "collisionZoneRegistered";
		
		private var _zone:Zone2D;
		
		public function CollisionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			//_zone = zone;
		}
		
		public function get zone ():Zone2D { return _zone; }
	}
}