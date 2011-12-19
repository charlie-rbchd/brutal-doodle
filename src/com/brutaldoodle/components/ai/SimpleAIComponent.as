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
		/*
		 * The interval of time between each iteration made by the AI
		 */
		public var timeBetweenThinks:Interval;
		
		/*
		 * The current state of the the AI
		 */
		public var isThinking:Boolean;
		
		public function SimpleAIComponent() {
			super();
			isThinking = true;
		}
		
		override protected function onAdd():void {
			super.onAdd();
			
			// Schedule the first iteration
			if (isThinking) {
				PBE.processManager.schedule(timeBetweenThinks.getTime(), owner, think);
			}
		}
		
		/*
		 * To be overriden...
		 * This is where AI-specific actions will be specified and executed at each iteration
		 */
		protected function think():void {
			// Schedule the next iteration
			if (isThinking) {
				PBE.processManager.schedule(timeBetweenThinks.getTime(), owner, think);
			}
		}
	}
}