package com.brutaldoodle.events
{
	import flash.events.Event;
	
	public class TankEvent extends Event
	{
		public static const UPDATE_ANIMATION:String = "updateAnimation";
		
		public function TankEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}