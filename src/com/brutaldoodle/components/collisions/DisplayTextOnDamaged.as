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
			owner.eventDispatcher.addEventListener(HealthEvent.DIED, onDamaged);
		}
		
		override protected function onRemove():void {
			super.onRemove();
			owner.eventDispatcher.removeEventListener(HealthEvent.DAMAGED, onDamaged);
			owner.eventDispatcher.removeEventListener(HealthEvent.DIED, onDamaged);
		}
		
		// once the owner is damaged, text is displayed above it;
		// it shows the amount of damage taken
		private function onDamaged (event:HealthEvent):void {
			var damageDone:Number = event.delta;
			// no need to display anything if there's no damage inflicted
			if (damageDone == 0) return;
			
			if (owner != null) {
				var position:Point = owner.getProperty(positionProperty);
				var size:Point = owner.getProperty(sizeProperty);
				
				// otherwise, create a label (a simple TextField) and render it above the owner
				var label:IEntity =  PBE.allocateEntity();
				
				// Arial is a pretty nice font!
				var textformat:TextFormat;
				var text:TextField = new TextField();
				if (event.type == HealthEvent.DAMAGED) {
					textformat = new TextFormat("Arial", 12, 0xffffff);
					text.defaultTextFormat = textformat;
					text.text = String(damageDone);
					text.width = 25;
					text.height = 25;
				} else {
					textformat = new TextFormat("Arial", 18, 0xff0000, true);
					text.defaultTextFormat = textformat;
					text.text = "-1 Vie";
					text.width = 100;
					text.height = 25;
				}
				
				var spatial:SimpleSpatialComponent = new SimpleSpatialComponent();
				spatial.spatialManager = PBE.spatialManager;
				spatial.position = new Point(position.x + (event.type == HealthEvent.DAMAGED ? size.x/4 : -25),  position.y - size.y);
				spatial.size = new Point(text.width, text.height);
				
				label.addComponent(spatial, "Spatial");
				
				
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
				if (event.type == HealthEvent.DIED) tween.delta = 0.025;
				label.addComponent(tween, "Tween");
				
				label.initialize();
			}
		}
	}
}