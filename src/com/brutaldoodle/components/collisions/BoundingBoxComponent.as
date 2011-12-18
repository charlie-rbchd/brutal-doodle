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

package com.brutaldoodle.components.collisions
{
	import com.brutaldoodle.collisions.CollisionManager;
	import com.pblabs.engine.entity.EntityComponent;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flintparticles.twoD.particles.Particle2D;
	import org.flintparticles.twoD.zones.Zone2D;
	
	public class BoundingBoxComponent extends EntityComponent implements Zone2D {
		private var _left:Number;
		private var _top:Number;
		private var _right:Number;
		private var _bottom:Number;
		private var _collisionType:String;
		
		public function BoundingBoxComponent() {
			super();
		}
		
		// set the position of the bounding box directly from a rectangle
		public function set zone (value:Rectangle):void {
			_top = value.top;
			_left = value.left;
			_bottom = value.bottom;
			_right = value.right;
		}
		
		public function get zone ():Rectangle {
			return new Rectangle(_left, _top, _right - _left, _bottom - _top);
		}
		
		public function set collisionType (type:String):void {
			_collisionType = type;
			CollisionManager.instance.registerForCollisions(this, _collisionType);
		}
		
		public function get collisionType ():String {
			return _collisionType;
		}
		
		// ************************************************************************************************
		// Zone2D Implementation, this code is for most parts the same as Flint's RectangleZone source code
		// An implementation of Zone2D is provided in order to directly use this component for collisions
		// ************************************************************************************************
		public function contains(x:Number, y:Number):Boolean {
			return x >= _left && x <= _right && y >= _top && y <= _bottom;
		}
		
		public function getArea ():Number {
			return (_right - _left) * (_bottom - _top);
		}
		
		public function getLocation ():Point {
			return new Point(
				_left + Math.random() * (_right - _left),
				_top + Math.random() * (_bottom - _top)
			);
		}
		
		public function collideParticle (particle:Particle2D, bounce:Number=1):Boolean {
			var position:Number;
			var previousPosition:Number;
			var intersect:Number;
			var collision:Boolean = false;
			
			if (particle == null) return collision;
			if (particle.velX > 0)
			{
				position = particle.x + particle.collisionRadius;
				previousPosition = particle.previousX + particle.collisionRadius;
				
				if (previousPosition < _left && position >= _left)
				{
					intersect = particle.previousY + (particle.y - particle.previousY) * (_left - previousPosition) / (position - previousPosition);
					
					if (intersect >= _top - particle.collisionRadius && intersect <= _bottom + particle.collisionRadius) {
						particle.velX = -particle.velX * bounce;
						particle.x += 2 * (_left - position);
						collision = true;
					}
				}
				else if (previousPosition <= _right && position > _right)
				{
					intersect = particle.previousY + (particle.y - particle.previousY) * (_right - previousPosition) / (position - previousPosition);
					if (intersect >= _top - particle.collisionRadius && intersect <= _bottom + particle.collisionRadius) {
						particle.velX = -particle.velX * bounce;
						particle.x += 2 * (_right - position);
						collision = true;
					}
				}
			}
			else if ( particle.velX < 0 )
			{
				position = particle.x - particle.collisionRadius;
				previousPosition = particle.previousX - particle.collisionRadius;
				
				if (previousPosition > _right && position <= _right)
				{
					intersect = particle.previousY + (particle.y - particle.previousY) * (_right - previousPosition) / (position - previousPosition);
					if (intersect >= _top - particle.collisionRadius && intersect <= _bottom + particle.collisionRadius) {
						particle.velX = -particle.velX * bounce;
						particle.x += 2 * (_right - position);
						collision = true;
					}
				}
				else if (previousPosition >= _left && position < _left)
				{
					intersect = particle.previousY + (particle.y - particle.previousY) * (_left - previousPosition) / (position - previousPosition);
					if (intersect >= _top - particle.collisionRadius && intersect <= _bottom + particle.collisionRadius) {
						particle.velX = -particle.velX * bounce;
						particle.x += 2 * (_left - position);
						collision = true;
					}
				}
			}
			
			if (particle.velY > 0)
			{
				position = particle.y + particle.collisionRadius;
				previousPosition = particle.previousY + particle.collisionRadius;
				if (previousPosition < _top && position >= _top)
				{
					intersect = particle.previousX + (particle.x - particle.previousX) * (_top - previousPosition) / (position - previousPosition);
					if (intersect >= _left - particle.collisionRadius && intersect <= _right + particle.collisionRadius) {
						particle.velY = -particle.velY * bounce;
						particle.y += 2 * (_top - position);
						collision = true;
					}
				}
				else if (previousPosition <= _bottom && position > _bottom)
				{
					intersect = particle.previousX + (particle.x - particle.previousX) * (_bottom - previousPosition) / (position - previousPosition);
					if (intersect >= _left - particle.collisionRadius && intersect <= _right + particle.collisionRadius) {
						particle.velY = -particle.velY * bounce;
						particle.y += 2 * (_bottom - position);
						collision = true;
					}
				}
			}
			else if (particle.velY < 0)
			{
				position = particle.y - particle.collisionRadius;
				previousPosition = particle.previousY - particle.collisionRadius;
				
				if (previousPosition > _bottom && position <= _bottom)
				{
					intersect = particle.previousX + (particle.x - particle.previousX) * (_bottom - previousPosition) / (position - previousPosition);
					if (intersect >= _left - particle.collisionRadius && intersect <= _right + particle.collisionRadius) {
						particle.velY = -particle.velY * bounce;
						particle.y += 2 * (_bottom - position);
						collision = true;
					}
				}
				else if (previousPosition >= _top && position < _top)
				{
					intersect = particle.previousX + (particle.x - particle.previousX) * (_top - previousPosition) / (position - previousPosition);
					if (intersect >= _left - particle.collisionRadius && intersect <= _right + particle.collisionRadius) {
						particle.velY = -particle.velY * bounce;
						particle.y += 2 * (_top - position);
						collision = true;
					}
				}
			}
			
			return collision;
		}
		// ************************************************************************************************
		// ...
		// End of copy pasta
		// ************************************************************************************************
	}
}