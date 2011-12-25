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
	
	public class FadeComponent extends TickedComponent
	{
		/*
		 * Constants used in order to easily identify fade types
		 */
		public static const FADE_IN:String = "fadeIn";
		public static const FADE_OUT:String = "fadeOut";
		public static const FLASHING:String = "flashing";
		
		/*
		 * References to the owner's properties
		 */
		public var alphaProperty:PropertyReference;
		
		/*
		 * The type of fade (either in or out)
		 */
		public var type:String;
		
		/*
		 * A callback function that is executed once the fade is completed
		 */
		public var callback:Function;
		
		/*
		 * The rate at which the alpha is incremented/decremented each tick
		 */
		public var rate:Number;
		
		/*
		 * The amount of time before it starts animating
		 */
		public var delay:Number;
		
		/*
		 * Used for back and forth animations between fade ins and fade outs
		 */
		private var _currentType:String;
		
		public function FadeComponent()
		{
			super();
			delay = 0;
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			// Wait until the delay is completed before animating
			if (type == FLASHING) _currentType = FADE_OUT;
			if (delay) {
				this.registerForTicks = false;
				PBE.processManager.schedule(delay, this, function():void {
					this.registerForTicks = true;
				});
			}
		}
		
		override public function onTick (deltaTime:Number):void {
			super.onTick(deltaTime);
			// Retrieve the current value of the alpha
			var alpha:Number = owner.getProperty(alphaProperty);
			
			switch (type) {
				case FADE_OUT:
					if (alpha > 0) {
						// Decrement the alpha until it's at 0
						owner.setProperty(alphaProperty, alpha -= rate);
					} else {
						// The fade is completed, call the callback if necessary
						this.registerForTicks = false;
						if (callback != null) callback();
					}
					break;
				case FADE_IN:
					if (alpha <= 1) {
						// Increment the alpha until it's at 1
						owner.setProperty(alphaProperty, alpha += rate);	
					} else {
						// The fade is completed, call the callback if necessary
						this.registerForTicks = false;
						if (callback != null) callback();
					}
					break;
				case FLASHING:
					if (_currentType == FADE_OUT)
					{
						if (alpha > 0) {
							// Decrement the alpha until it's at 0
							owner.setProperty(alphaProperty, alpha -= rate);
						} else {
							// The fade is completed, revert it
							_currentType = FADE_IN;
						}
					}
					else
					{
						if (alpha <= 1) {
							// Increment the alpha until it's at 1
							owner.setProperty(alphaProperty, alpha += rate);	
						} else {
							// The fade is completed, revert it
							_currentType = FADE_OUT;
						}
					}
					break;
				default:
					throw new Error();
			}
		}
	}
}