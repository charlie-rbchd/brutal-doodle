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
	import com.brutaldoodle.components.animations.FadeComponent;
	import com.brutaldoodle.components.animations.MoveComponent;
	import com.pblabs.components.basic.HealthEvent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.DisplayObjectRenderer;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class DisplayTextOnDamaged extends EntityComponent {
		/*
		 * References to the owner's properties
		 */
		public var positionProperty:PropertyReference;
		public var sizeProperty:PropertyReference;
		
		public function DisplayTextOnDamaged() {
			super();
		}
		
		override protected function onAdd():void {
			super.onAdd();
			owner.eventDispatcher.addEventListener(HealthEvent.DAMAGED, onDamaged);
			owner.eventDispatcher.addEventListener(HealthEvent.DIED, onDamaged);
		}
		
		override protected function onRemove():void {
			super.onRemove();
			owner.eventDispatcher.removeEventListener(HealthEvent.DAMAGED, onDamaged);
			owner.eventDispatcher.removeEventListener(HealthEvent.DIED, onDamaged);
		}
		
		/*
		 * Display the amount of damage taken above the owner's head
		 */
		private function onDamaged (event:HealthEvent):void {
			var damageDone:Number = event.delta;
			// Only display text if the damage inflicted is not null
			if (damageDone == 0) return;
			
			if (owner != null) {
				var position:Point = owner.getProperty(positionProperty);
				var size:Point = owner.getProperty(sizeProperty);
				
				// Create a label (TextField) and render it above the owner
				var label:IEntity =  PBE.allocateEntity();
				
				var textformat:TextFormat;
				var text:TextField = new TextField();
				if (event.type == HealthEvent.DAMAGED) {
					// White text if its normal damage
					textformat = new TextFormat("Arial", 12, 0xffffff);
					text.defaultTextFormat = textformat;
					text.text = String(damageDone);
					text.width = 25;
					text.height = 25;
				} else {
					// Red bigger text if the player lost a life
					textformat = new TextFormat("Arial", 18, 0xff0000, true);
					text.defaultTextFormat = textformat;
					text.text = "-1 Vie";
					text.width = 100;
					text.height = 25;
				}
				
				// Spatial properties of the text
				var spatial:SimpleSpatialComponent = new SimpleSpatialComponent();
				spatial.spatialManager = PBE.spatialManager;
				spatial.position = new Point(position.x + (event.type == HealthEvent.DAMAGED ? size.x/4 : -25),  position.y - size.y);
				spatial.size = new Point(text.width, text.height);
				
				label.addComponent(spatial, "Spatial");
				
				// Render properties of the text
				var render:DisplayObjectRenderer = new DisplayObjectRenderer();
				render.displayObject = text;
				render.sizeProperty = new PropertyReference("@Spatial.size");
				render.positionProperty = new PropertyReference("@Spatial.position");
				render.scene = PBE.scene;
				
				label.addComponent(render, "Render");
				
				// Make the text move up a bit angled to the right
				var tween:MoveComponent = new MoveComponent();
				tween.positionProperty = new PropertyReference("@Spatial.position");
				tween.deltaX = 0.5;
				tween.deltaY = -2;
				label.addComponent(tween, "Tween");
				
				// Make the text slowly disappear
				var fadeOut:FadeComponent = new FadeComponent();
				fadeOut.alphaProperty = new PropertyReference("@Render.alpha");
				fadeOut.type = FadeComponent.FADE_OUT;
				fadeOut.callback = function():void {
					label.destroy();
				};
				fadeOut.rate = event.type == HealthEvent.DIED ? 0.025 : 0.05;
				label.addComponent(fadeOut, "FadeOut");
				
				label.initialize();
			}
		}
	}
}