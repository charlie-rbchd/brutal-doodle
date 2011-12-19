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

package com.brutaldoodle.components.controllers
{
	import com.brutaldoodle.collisions.CollisionManager;
	import com.brutaldoodle.ui.Generique;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.core.LevelManager;
	import com.pblabs.engine.entity.PropertyReference;
	
	public class LoadLevelOnKeypress extends TickedComponent
	{
		/*
		 * The level that will be loaded
		 */
		public var level:int;
		
		/*
		 * References to the object's properties
		 */
		public var alphaProperty:PropertyReference;
		
		/*
		 * Whether or not the delay has been started
		 */
		private var _actionDone:Boolean;
		
		/*
		 * Whether or not delay is completed
		 */
		private var _delayCompleted:Boolean;
		
		/*
		 * Whether or not the credits are currently playing
		 */
		private var _creditsPlaying:Boolean;
		
		public function LoadLevelOnKeypress() {
			super();
			_actionDone = _delayCompleted = _creditsPlaying = false;
		}
		
		override public function onTick(deltaTime:Number):void {
			super.onTick(deltaTime);
			
			// Start a 2 seconds delay once the owner becomes visible
			var alpha:Number = owner.getProperty(alphaProperty);
			if (alpha == 1 && !_actionDone) {
				PBE.processManager.schedule(2000, this, function ():void { _delayCompleted = true; });
				_actionDone = true;
			}
			
			// Wait for the delay to be completed AND for user input
			if (_delayCompleted && PBE.isAnyKeyDown())
			{
				// Show the credits if its the last level, return to the main menu if credits were already playing
				if (PBE.levelManager.currentLevel == PBE.levelManager.levelCount - 1)
				{
					if (!_creditsPlaying) {
						PBE.mainStage.addChild(new Generique());
						_creditsPlaying = true;
						_delayCompleted = false;
						PBE.processManager.schedule(1000, this, function():void {
							_delayCompleted = true;
						});
					}
					else
						Main.resetEverythingAndReloadGame();
				}
				else
				{
					// If its not the last level, simply load the appropriate one
					if (level == -1)
						Main.resetEverythingAndLoadLevel(PBE.levelManager.currentLevel + 1);
					else if (level == 0)
						Main.resetEverythingAndReloadGame();
					else
						Main.resetEverythingAndLoadLevel(level);
				}
			}
		}
	}
}