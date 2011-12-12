package com.brutaldoodle.components.animations
{
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.SpriteSheetRenderer;
	import com.pblabs.rendering2D.modifier.ColorizeModifier;
	
	public class TurnToRedComponent extends TickedComponent
	{
		public var rate:Number;
		
		private var _Renderer:SpriteSheetRenderer;
		private var _activateShot:PropertyReference;
		private var _decrement:Number = 1;
		
		public function TurnToRedComponent()
		{
			super();
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			_Renderer = owner.lookupComponentByName("Render") as SpriteSheetRenderer;
		}
	
		override public function onTick(deltaTime:Number):void
		{
			super.onTick(deltaTime); 
			if(_decrement >= 0){
				_decrement -= rate;
				_Renderer.modifiers = [ new ColorizeModifier([1,0,0,0,0],[0,_decrement,0,0,0],[0,0,_decrement,0,0],[0,0,0,1,0])]; 
			}else{
				_Renderer.modifiers = [ new ColorizeModifier([1,0,0,0,0],[0,1,0,0,0],[0,0,1,0,0],[0,0,0,1,0])];
				owner.removeComponent(this);
			}
		}
	}
}