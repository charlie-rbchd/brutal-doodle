package com.brutaldoodle.rendering
{
	import com.brutaldoodle.effects.HazardousShot;
	
	public class HazardousShotRenderer extends FlintBitmapRenderer
	{
		private var _hazardousShot:HazardousShot; 
		
		public function HazardousShotRenderer() {
			super();
		}
		
		override public function addEmitters():void {
			//Start an emitter for any shot made by a butterfly (not yet implemented)
			_hazardousShot = new HazardousShot();
			initializeEmitter(_hazardousShot);
			super.addEmitters();
		}
	}
}