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
		
		/*
		 * AI-specific actions are defined here
		 */
		override protected function think():void
		{
			// Check if there are warpable units that are still alive
			if (WarpableComponent.priorityWeights.length) {
				super.think();
				
				// Make the invader turn white over 1 second
				var filter:TurnToColorComponent = new TurnToColorComponent();
				filter.color = TurnToColorComponent.COLOR_WHITE;
				filter.rate = 0.033;
				if (owner != null) owner.addComponent(filter,"TurnColor");
				
				// Shoot a particule rendered by the WarpRenderer (white particles surrounding the invader)
				var p:Projectile = new Projectile(WarpRenderer, owner);
				
				// Wait for the invader to completely turn white (about one second)
				PBE.processManager.schedule(1000, this, warp);
			}
		}
		
		/*
		 * Exchange the position of two units : the warper and another randomly selected unit
		 */
		private function warp():void {
			// Re-Check if there are warpable units that are still alive (some might have died while the invader was turning white)
			if (WarpableComponent.priorityWeights.length) {
				// Retrieve a warpable unit that is most likely to be warped
				// This is done by considering the weight of each unit and a bit of random
				var warpableUnit:IEntity = WarpableComponent.priorityWeights.getRandomValue();
				
				if (warpableUnit && owner) {
					// Retrieve the position and bounding box where the warper is going to warp to
					var spatial:SimpleSpatialComponent = warpableUnit.lookupComponentByName("Spatial") as SimpleSpatialComponent;
					var boundingBox:BoundingBoxComponent = warpableUnit.lookupComponentByName("Collisions") as BoundingBoxComponent;
					var positionTo:Point = spatial.position;
					var boundingBoxTo:Rectangle = boundingBox.zone;
					
					// Retrieve the current position and bounding box where the targeted ennemy will be sent
					var positionFrom:Point = owner.getProperty(positionProperty);
					var boundingBoxFrom:Rectangle = owner.getProperty(boundingBoxProperty);
					
					// Exchange the position and bounding Box of the two units
					owner.setProperty(positionProperty, positionTo);
					warpableUnit.setProperty(new PropertyReference("@Spatial.position"), positionFrom);
					
					owner.setProperty(boundingBoxProperty, boundingBoxTo);
					warpableUnit.setProperty(new PropertyReference("@Collisions.zone"), boundingBoxFrom);
					
					// Check for new possible edge ennemies (it might've been the warper or the warped unit)
					EnemyMobilityComponent.findEdgeEnemies();
				}
			}
		}
	}
}