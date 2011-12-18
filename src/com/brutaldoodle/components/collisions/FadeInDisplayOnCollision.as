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
	import com.brutaldoodle.components.animations.FadeComponent;
	import com.brutaldoodle.components.animations.WiggleObjectComponent;
	import com.brutaldoodle.events.CollisionEvent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.PropertyReference;
	
	public class FadeInDisplayOnCollision extends EntityComponent
	{
		public var entityNames:Array;
		public var alphaRate:Number;
		
		private var _opened:Boolean;
		
		public function FadeInDisplayOnCollision()
		{
			super();
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			_opened = false;
			CollisionManager.instance.addEventListener(CollisionEvent.COLLISION_OCCURED, fadeInOption);
		}
		
		private function fadeInOption(event:CollisionEvent):void{
			if (owner != null) {
				if (event.zone == owner.lookupComponentByName("Collisions")) {
					var i:int, length:int = entityNames.length, fadeIn:FadeComponent, displayObject:IEntity, wiggler:WiggleObjectComponent;
					
					for (i = 0; i < length; ++i) {
						displayObject = PBE.lookupEntity(entityNames[i]) as IEntity;
						wiggler = owner.lookupComponentByName("Wiggle") as WiggleObjectComponent;
						
						if (!_opened) {
							fadeIn = new FadeComponent();
							fadeIn.alphaProperty = new PropertyReference("#" + entityNames[i] + ".Render.alpha");
							fadeIn.rate = alphaRate;
							fadeIn.type = FadeComponent.FADE_IN;
							displayObject.addComponent(fadeIn, "FadeIn");
						} else {
							displayObject.setProperty(new PropertyReference("#" + entityNames[i] + ".Render.alpha"), 0);
							fadeIn = displayObject.lookupComponentByName("FadeIn") as FadeComponent;
							displayObject.removeComponent(fadeIn);
						}
					}
					
					_opened = !_opened;
				}
			}
		}
	}
}