package com.brutaldoodle.components.animations
{
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.rendering2D.SpriteRenderer;
	import com.pblabs.rendering2D.SpriteSheetRenderer;
	import com.pblabs.rendering2D.modifier.ColorizeModifier;
	
	public class ChangeEnvironmentComponent extends EntityComponent
	{
		public function ChangeEnvironmentComponent()
		{
			super();
		}
		override protected function onAdd():void
		{
			super.onAdd();
			var renderer:SpriteRenderer = owner.lookupComponentByName("Render") as SpriteRenderer;
			var date:Date = new Date();
			
			// Change the colors to make them more obscure at night and clearer during the day
			if (date.hours <= 12)
				renderer.modifiers = [ new ColorizeModifier([1,0,0,0,0], [0,1,0,0,0], [0,0,2.5 - 1.7 *(date.hours/12),0,0], [0,0,0,1,0]) ];
			else
				renderer.modifiers = [ new ColorizeModifier([1,0,0,0,0], [0,1,0,0,0], [0,0,2.5 - 1.7 * (date.hours - 12)/12,0,0], [0,0,0,1,0]) ];
		}
	}
}