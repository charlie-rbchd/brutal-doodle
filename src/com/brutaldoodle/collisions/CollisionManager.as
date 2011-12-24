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

package com.brutaldoodle.collisions
{
	import com.brutaldoodle.components.collisions.BoundingBoxComponent;
	import com.brutaldoodle.events.CollisionEvent;
	import com.pblabs.engine.debug.Logger;
	
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.flintparticles.twoD.zones.Zone2D;

	public class CollisionManager extends EventDispatcher
	{
		/*
		 * Singleton instance
		 */
		private static var _instance:CollisionManager = new CollisionManager();
		
		/*
		 * Containers that are to hold references of the bounding box for all collidable types
		 */
		private var _players:Vector.<Zone2D>;
		private var _enemies:Vector.<Zone2D>;
		
		/*
		 * Dictionary used for quick reference access to all the above vectors
		 */
		private var _zones:Dictionary;
		
		/*
		 * Private constructor
		 */
		public function CollisionManager() {
			if (instance) throw new Error("CollisionManager can only be accessed through CollisionManager.instance");
		}
		
		/*
		 * Instanciation of the vectors and the dictionary needed by the class
		 */
		public function initialize ():void {
			_players = new Vector.<Zone2D>();
			_enemies = new Vector.<Zone2D>();
			
			// Quick access to the vectors via reference
			_zones = new Dictionary(true);
			_zones[CollisionType.PLAYER] = _players;
			_zones[CollisionType.ENEMY]	= _enemies;
		}
		
		/*
		 * Clear the containers from any collidable objects
		 */
		public function reset ():void {
			initialize(); // hard reset, everything is deleted
		}
		
		/*
		 * Register a bounding box for collision checks
		 *
		 * @param zone  The bounding box
		 * @param type  The type of collision (defined by CollisionType)
		 */
		public function registerForCollisions (zone:Zone2D, type:String):void {
			_zones[type].push(zone);
			dispatchEvent(new CollisionEvent(CollisionEvent.COLLISION_ZONE_REGISTERED, zone));
		}
		
		/*
		 * Unregister a bounding box for collision checks
		 *
		 * @param zone  The bounding box
		 * @param type  The type of collision (defined by CollisionType)
		 */
		public function stopCollisionsWith (zone:Zone2D, type:String):void {
			var zones:Vector.<Zone2D> = _zones[type];
			var index:int = zones.indexOf(zone);
			var boundingBox:BoundingBoxComponent = zone as BoundingBoxComponent;
			
			if (index != -1) {
				// the collision zone is moved away from the canvas until it's garbage collected
				(zone as BoundingBoxComponent).zone = new Rectangle(-Infinity, -Infinity, -Infinity, -Infinity);
				zones.splice(index, 1);
			}
			
			dispatchEvent(new CollisionEvent(CollisionEvent.COLLISION_ZONE_UNREGISTERED, null));
		}
		
		/*
		 * @param type  The type of collision (defined by CollisionType)
		 * @return A vector containing all the bounding box that have a type matching the one passed in paramater
		 */
		public function getCollidableObjectsByType (type:String):Vector.<Zone2D> {
			return _zones[type];
		}
		
		public static function get instance ():CollisionManager { return _instance; }
	}
}