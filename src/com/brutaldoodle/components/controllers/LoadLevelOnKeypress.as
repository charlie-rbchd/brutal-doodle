package com.brutaldoodle.components.controllers
{
	import com.brutaldoodle.ui.Generique;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.entity.PropertyReference;
	
	public class LoadLevelOnKeypress extends TickedComponent
	{
		public var level:int;
		public var alphaProperty:PropertyReference;
		
		private var _actionDone:Boolean;
		private var _delayCompleted:Boolean;
		
		public function LoadLevelOnKeypress() {
			super();
			_actionDone = _delayCompleted = false;
		}
		
		override public function onTick(deltaTime:Number):void {
			super.onTick(deltaTime);
			
			var alpha:Number = owner.getProperty(alphaProperty);
			if (alpha == 1 && !_actionDone) {
				PBE.processManager.schedule(2000, this, function ():void { _delayCompleted = true; });
				_actionDone = true;
			}
			
			if (_delayCompleted && PBE.isAnyKeyDown()) {
				// if the last level is completed
				if (PBE.levelManager.currentLevel == PBE.levelManager.levelCount - 1) {
					PBE.mainStage.addChild(new Generique());
				} else {
					if (level == -1)
						PBE.levelManager.loadLevel(PBE.levelManager.currentLevel + 1, true);
					else
						PBE.levelManager.loadLevel(level, true);
				}
			}
		}
	}
}