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
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.PropertyReference;
	
	public class FadeComponent extends TickedComponent
	{
		public static const FADE_IN:String = "fadeIn";
		public static const FADE_OUT:String = "fadeOut";
		
		public var alphaProperty:PropertyReference;
		public var type:String;
		public var callback:Function;
		public var rate:Number;
		
		public function FadeComponent()
		{
			super();
		}
		
		override public function onTick (deltaTime:Number):void {
			super.onTick(deltaTime);
			var alpha:Number = owner.getProperty(alphaProperty);
			
			switch (type) {
				case FADE_IN:
					if (alpha <= 1) {
						owner.setProperty(alphaProperty, alpha += rate);	
					} else {
						this.registerForTicks = false;
						if (callback != null) callback();
					}
					break;
				case FADE_OUT:
					if (alpha > 0) {
						owner.setProperty(alphaProperty, alpha -= rate);
					} else {
						this.registerForTicks = false;
						if (callback != null) callback();
					}
					break;
				default:
					throw new Error();
			}
		
		}
	}
}