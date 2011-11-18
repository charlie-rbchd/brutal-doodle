package com.brutaldoodle.components.collisions
{
	import com.brutaldoodle.components.animations.MoveUpAndFadeComponent;
	import com.pblabs.components.basic.HealthEvent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.DisplayObjectRenderer;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class DisplayTextOnDamaged extends EntityComponent {
		public var positionProperty:PropertyReference;
		public var sizeProperty:PropertyReference;
		
		public function DisplayTextOnDamaged() {
			super();
		}
		
		override protected function onAdd():void {
			super.onAdd();
			owner.eventDispatcher.addEventListener(HealthEvent.DAMAGED, onDamaged);
		}
		
		override protected function onRemove():void {
			super.onRemove();
			owner.eventDispatcher.removeEventListener(HealthEvent.DAMAGED, onDamaged);
		}
		
		// once the owner is damaged, text is displayed above it;
		// it shows the amount of damage taken
		private function onDamaged (event:HealthEvent):void {
			var damageDone:Number = event.delta;
			// no need to display anything if there's no damage inflicted
			if (damageDone == 0) return;
			
			var position:Point = owner.getProperty(positionProperty);
			var size:Point = owner.getProperty(sizeProperty);
			
			// otherwise, create a label (a simple TextField) and render it above the owner
			var label:IEntity =  PBE.allocateEntity();
			
			var spatial:SimpleSpatialComponent = new SimpleSpatialComponent();
			spatial.spatialManager = PBE.spatialManager;
			spatial.position = new Point(position.x + size.x/4,  position.y - size.y);
			spatial.size = new Point(25, 25);
			
			label.addComponent(spatial, "Spatial");
			
			// Arial is a pretty nice font!
			var textformat:TextFormat = new TextFormat("Arial", 10, 0xffffff);
			var text:TextField = new TextField();
			text.defaultTextFormat = textformat;
			text.text = String(damageDone);
			text.width = 25;
			text.height = 25;
			
			var render:DisplayObjectRenderer = new DisplayObjectRenderer();
			render.displayObject = text;
			render.sizeProperty = new PropertyReference("@Spatial.size");
			render.positionProperty = new PropertyReference("@Spatial.position");
			render.scene = PBE.scene;
			
			label.addComponent(render, "Render");
			
			// Add a component that make the text literally "Move Up And Fade" over time
			var tween:MoveUpAndFadeComponent = new MoveUpAndFadeComponent();
			tween.positionProperty = new PropertyReference("@Spatial.position");
			tween.alphaProperty = new PropertyReference("@Render.alpha");
			label.addComponent(tween, "Tween");
			
			label.initialize();
		}
	}
}