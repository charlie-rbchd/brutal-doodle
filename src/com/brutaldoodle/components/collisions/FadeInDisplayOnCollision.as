package com.brutaldoodle.components.collisions
{
	import com.brutaldoodle.collisions.CollisionManager;
	import com.brutaldoodle.components.animations.FadeComponent;
	import com.brutaldoodle.components.animations.WiggleObjectComponent;
	import com.brutaldoodle.events.CollisionEvent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.PropertyReference;
	
	public class FadeInDisplayOnCollision extends EntityComponent
	{
		public var entityNames:Array;
		public var alphaRate:Number;
		
		private var _opened:Boolean;
		
		public function FadeInDisplayOnCollision()
		{
			super();
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			_opened = false;
			CollisionManager.instance.addEventListener(CollisionEvent.COLLISION_OCCURED, fadeInOption);
		}
		
		private function fadeInOption(event:CollisionEvent):void{
			if (owner != null) {
				if (event.zone == owner.lookupComponentByName("Collisions")) {
					var i:int, length:int = entityNames.length, fadeIn:FadeComponent, displayObject:IEntity, wiggler:WiggleObjectComponent;
					
					for (i = 0; i < length; ++i) {
						displayObject = PBE.lookupEntity(entityNames[i]) as IEntity;
						wiggler = owner.lookupComponentByName("Wiggle") as WiggleObjectComponent;
						
						if (!_opened) {
							fadeIn = new FadeComponent();
							fadeIn.alphaProperty = new PropertyReference("#" + entityNames[i] + ".Render.alpha");
							fadeIn.rate = alphaRate;
							fadeIn.type = FadeComponent.FADE_IN;
							displayObject.addComponent(fadeIn, "FadeIn");
						} else {
							displayObject.setProperty(new PropertyReference("#" + entityNames[i] + ".Render.alpha"), 0);
							fadeIn = displayObject.lookupComponentByName("FadeIn") as FadeComponent;
							displayObject.removeComponent(fadeIn);
						}
					}
					
					_opened = !_opened;
				}
			}
		}
	}
}