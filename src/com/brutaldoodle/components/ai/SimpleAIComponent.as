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
	import com.brutaldoodle.utils.Interval;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.EntityComponent;
	
	public class SimpleAIComponent extends EntityComponent
	{
		public var timeBetweenThinks:Interval;
		public var isThinking:Boolean;
		
		public function SimpleAIComponent() {
			super();
			isThinking = true;
		}
		
		override protected function onAdd():void {
			super.onAdd();
			
			// first schedule for AI check
			if (isThinking) {
				PBE.processManager.schedule(timeBetweenThinks.getTime(), owner, think);
			}
		}
		
		// this function is to be overriden in any child class
		// (specific AI actions are executed here)
		protected function think():void {
			if (isThinking) {
				PBE.processManager.schedule(timeBetweenThinks.getTime(), owner, think);
			}
		}
	}
}