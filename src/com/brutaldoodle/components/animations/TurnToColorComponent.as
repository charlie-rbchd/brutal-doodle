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
	import com.pblabs.rendering2D.SpriteSheetRenderer;
	import com.pblabs.rendering2D.modifier.ColorizeModifier;
	
	public class TurnToColorComponent extends TickedComponent
	{
		public static const COLOR_RED:String = "red";
		public static const COLOR_WHITE:String = "white";
		
		public var rate:Number;
		public var color:String;
		
		private var _Renderer:SpriteSheetRenderer;
		private var _decrement:Number = 1;
		private var _increment:Number = 0;
		
		public function TurnToColorComponent()
		{
			super();
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			_Renderer = owner.lookupComponentByName("Render") as SpriteSheetRenderer;
		}
	
		override public function onTick(deltaTime:Number):void
		{
			super.onTick(deltaTime); 
			
			switch (color) {
				case TurnToColorComponent.COLOR_RED:
					if (_decrement >= 0) {
						_decrement -= rate;
						_Renderer.modifiers = [ new ColorizeModifier([1,0,0,0,0],[0,_decrement,0,0,0],[0,0,_decrement,0,0],[0,0,0,1,0])]; 
					} else {
						_Renderer.modifiers = [ new ColorizeModifier([1,0,0,0,0],[0,1,0,0,0],[0,0,1,0,0],[0,0,0,1,0])];
						owner.removeComponent(this);
					}
					break;
				case TurnToColorComponent.COLOR_WHITE:
					if (_increment <= 1) {
						_increment += rate;
						_Renderer.modifiers = [ new ColorizeModifier([1,0,_increment,_increment,0],[0,1,_increment,_increment,0],[0,0,1,_increment,0],[0,0,_increment,1,0])];
					} else {
						_Renderer.modifiers = [ new ColorizeModifier([1,0,0,0,0],[0,1,0,0,0],[0,0,1,0,0],[0,0,0,1,0])];
						owner.removeComponent(this);
					}
					break;
				default:
					throw new Error();
			}
		}
	}
}