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

package com.brutaldoodle.components.animations
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.entity.PropertyReference;
	
	import flash.geom.Point;
	
	public class MoveComponent extends TickedComponent
	{
		/*
		 * References to the owner's properties
		 */
		public var positionProperty:PropertyReference;
		
		/*
		 * The amount by which the x coordinate will be moved each tick
		 */
		public var deltaX:Number;
		
		/*
		* The amount by which the y coordinate will be moved each tick
		*/
		public var deltaY:Number;
		
		/*
		 * The amount of time before it starts animating
		 */
		public var startDelay:Number;
		
		/*
		 * The amount of time after which it stop animating
		 */
		public var endDelay:Number;
		
		/*
		 * A callback function that is executed once the fade is completed
		 */
		public var callback:Function;
		
		public function MoveComponent() {
			super();
			startDelay = endDelay = 0;
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			// Wait until the delay is completed before animating
			if (startDelay) {
				this.registerForTicks = false;
				PBE.processManager.schedule(startDelay, this, function start():void {
					this.registerForTicks = true;
				});
			}
			
			// Stop animating after the endDelay has been waited
			if (endDelay) {
				PBE.processManager.schedule(endDelay, this, function end():void {
					this.registerForTicks = false;
					if (callback != null) callback();
				});
			}
		}
		
		override public function onTick(deltaTime:Number):void {
			super.onTick(deltaTime);
			// Modifiy the owner's position each tick, making it tween
			var position:Point = owner.getProperty(positionProperty);
			position.x += deltaX;
			position.y += deltaY;
			owner.setProperty(positionProperty, position);	
		}
	}
}