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
	import com.pblabs.components.basic.HealthEvent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.PropertyReference;
	
	import flash.geom.Point;
	
	public class UpdateHealthDisplayOnDamaged extends EntityComponent
	{
		public var sizeProperty:PropertyReference;
		public var positionProperty:PropertyReference;
		
		private var _baseSizeX:Number;
		private var _player:IEntity;
		
		public function UpdateHealthDisplayOnDamaged() {
			super();
		}
		
		// listen to the player's damage states
		override protected function onAdd():void {
			super.onAdd();
			_player = PBE.lookup("Player") as IEntity;
			if (_player != null) {
				_player.eventDispatcher.addEventListener(HealthEvent.DAMAGED, onDamaged);
				_player.eventDispatcher.addEventListener(HealthEvent.RESURRECTED, onResurrected);
				_baseSizeX = (owner.getProperty(sizeProperty) as Point).x;
			}
		}
		
		override protected function onRemove():void {
			super.onRemove();
			if (_player != null) {
				_player.eventDispatcher.removeEventListener(HealthEvent.DAMAGED, onDamaged);
				_player.eventDispatcher.removeEventListener(HealthEvent.RESURRECTED, onResurrected);
			}
		}
		
		// remove the proper amount of health inflicted to the player from the health bar
		private function onDamaged (event:HealthEvent):void {
			var position:Point = owner.getProperty(positionProperty);
			var size:Point = owner.getProperty(sizeProperty);
			
			var previousSizeX:Number = size.x;
			size.x = _baseSizeX * event.amount/1000;
			// the bar need to be repositionned because PBE's register point is at the center of objects
			position.x -= (previousSizeX - size.x)/2;
			
			owner.setProperty(sizeProperty, size);
			owner.setProperty(positionProperty, position);
		}
		
		// fill up the health bar when the player is resurrected
		private function onResurrected (event:HealthEvent):void {
			var position:Point = owner.getProperty(positionProperty);
			var size:Point = owner.getProperty(sizeProperty);
			
			// revert back to default values...
			size.x = _baseSizeX;
			position.x += _baseSizeX/2;
			
			owner.setProperty(sizeProperty, size);
			owner.setProperty(positionProperty, position);
		}
	}
}