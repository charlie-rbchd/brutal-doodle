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

package com.brutaldoodle.components.ai
{
	import com.brutaldoodle.components.animations.TurnToColorComponent;
	import com.brutaldoodle.components.basic.WarpableComponent;
	import com.brutaldoodle.components.collisions.BoundingBoxComponent;
	import com.brutaldoodle.entities.Projectile;
	import com.brutaldoodle.rendering.WarpRenderer;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class WarperAIComponent extends SimpleAIComponent
	{
		public var positionProperty:PropertyReference;
		public var boundingBoxProperty:PropertyReference;
		
		public function WarperAIComponent()
		{
			super();
		}
				
		override protected function think():void
		{
			if (WarpableComponent.priorityWeights.length) {
				super.think();
				
				//make the invader turn white over a 1 second period.
				var filter:TurnToColorComponent = new TurnToColorComponent();
				filter.rate = 0.033;
				filter.color = TurnToColorComponent.COLOR_WHITE;
				if (owner != null) {
					owner.addComponent(filter,"TurnColor");
				}
				
				//start the particle effect.
				var p:Projectile = new Projectile(WarpRenderer, owner);
				//create a timer of one second, the time it take for the to animation to be complete
				
				PBE.processManager.schedule(1000, this, warpIt);
			}
		}
		
		private function warpIt():void {
			if (WarpableComponent.priorityWeights.length) {
				//use the getRandomValue() method(who consider priority set in the WarpableComponent) to decide wich ennemy to target
				var warpableUnit:IEntity = WarpableComponent.priorityWeights.getRandomValue();
				
				if (warpableUnit && owner) {
					//get the position and bounding Box where the warper is going to warp to
					var spatial:SimpleSpatialComponent = warpableUnit.lookupComponentByName("Spatial")as SimpleSpatialComponent;
					var boundingBox:BoundingBoxComponent = warpableUnit.lookupComponentByName("Collisions")as BoundingBoxComponent;
					var positionTo:Point = spatial.position;
					var boundingBoxTo:Rectangle = boundingBox.zone;
					
					//get the current position and bounding Box where the targeted ennemy will be sent
					var positionFrom:Point = owner.getProperty(positionProperty);
					var boundingBoxFrom:Rectangle = owner.getProperty(boundingBoxProperty);
					
					//actually exchange the position and bounding Box of the two unit 
					owner.setProperty(positionProperty,positionTo);
					warpableUnit.setProperty(new PropertyReference("@Spatial.position"),positionFrom);
					owner.setProperty(boundingBoxProperty,boundingBoxTo);
					warpableUnit.setProperty(new PropertyReference("@Collisions.zone"),boundingBoxFrom);
					
					EnemyMobilityComponent.findEdgeEnemies();
				}
			}
		}
	}
}