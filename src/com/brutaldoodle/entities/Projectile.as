package com.brutaldoodle.entities
{
	import com.brutaldoodle.rendering.FlintBitmapRenderer;
	import com.pblabs.engine.entity.IEntity;
	
	public class Projectile
	{
		public function Projectile(RendererClass:Class, owner:IEntity)
		{
			var renderer:FlintBitmapRenderer = new RendererClass();
			renderer.trueOwner = owner;
			renderer.addEmitters();
		}
	}
}