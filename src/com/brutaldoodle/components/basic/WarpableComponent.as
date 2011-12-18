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

package com.brutaldoodle.components.basic
{
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;
	
	import org.flintparticles.common.utils.WeightedArray;
	
	public class WarpableComponent extends EntityComponent
	{
		public var priority:int; 
		private static var _weights:WeightedArray = new WeightedArray();
		
		public function WarpableComponent()
		{
			super();
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			_weights.add(owner, priority);
		}
		
		override protected function onRemove():void
		{
			super.onRemove();
			_weights.remove(owner);
		}
		
		public static function get priorityWeights():WeightedArray {
			return _weights;
		}
	}
}