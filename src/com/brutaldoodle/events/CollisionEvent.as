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

package com.brutaldoodle.events
{
	import flash.events.Event;
	
	import org.flintparticles.twoD.zones.Zone2D;
	
	public class CollisionEvent extends Event
	{
		/*
		 * Constants used in order to easily identify event types
		 */
		public static const COLLISION_OCCURED:String = "collisionOccured";
		public static const COLLISION_ZONE_UNREGISTERED:String = "collisionZoneUnregistered";
		public static const COLLISION_ZONE_REGISTERED:String = "collisionZoneRegistered";
		
		/*
		 * The zone (bounding box) involved in the event
		 */
		private var _zone:Zone2D;
		
		/*
		 * Typical event constructor
		 */
		public function CollisionEvent(type:String, zone:Zone2D, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			_zone = zone;
		}
		
		public function get zone ():Zone2D { return _zone; }
	}
}