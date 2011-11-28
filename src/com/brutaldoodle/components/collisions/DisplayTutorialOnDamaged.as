package com.brutaldoodle.components.collisions
{
	import com.pblabs.components.basic.HealthEvent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	import com.pblabs.rendering2D.SpriteRenderer;
	
	import flash.geom.Point;
	
	public class DisplayTutorialOnDamaged extends EntityComponent {
		public var textFilePath:String;
		public var arrowFilePath:String;
		public var position:Point;
		public var textSize:Point;
		public var arrowSize:Point;
		
		private static var _text:IEntity;
		private static var _leftArrow:IEntity;
		private static var _rightArrow:IEntity;
			
		private static var _elementsDisplayed:Boolean = false;
		
		public function DisplayTutorialOnDamaged() {
			super();
		}
		
		override protected function onAdd():void {	
			owner.eventDispatcher.addEventListener(HealthEvent.DAMAGED, onDamaged);
		}
		
		override protected function onRemove():void {
			owner.eventDispatcher.removeEventListener(HealthEvent.DAMAGED, onDamaged);
		}
		
		private function onDamaged (event:HealthEvent):void {
			if (!_elementsDisplayed) {
				// Warning Text
				_text = PBE.allocateEntity();
				
				var text_spatial:SimpleSpatialComponent = new SimpleSpatialComponent();
				text_spatial.spatialManager = PBE.spatialManager;
				text_spatial.position = position;
				text_spatial.size = textSize;
				
				_text.addComponent(text_spatial, "Spatial");
				
				var text_renderer:SpriteRenderer = new SpriteRenderer();
				with (text_renderer) {
					scene = PBE.scene;
					positionProperty = new PropertyReference("@Spatial.position");
					sizeProperty = new PropertyReference("@Spatial.size");
					fileName = textFilePath;
					layerIndex = 2;
				}
				_text.addComponent(text_renderer, "Render");
				
				_text.initialize();
				
				
				// Left Arrow
				_leftArrow = PBE.allocateEntity();
				
				var leftArrow_spatial:SimpleSpatialComponent = new SimpleSpatialComponent();
				leftArrow_spatial.spatialManager = PBE.spatialManager;
				leftArrow_spatial.position = new Point(position.x - 150, position.y + 70);
				leftArrow_spatial.size = arrowSize;
				
				_leftArrow.addComponent(leftArrow_spatial, "Spatial");
				
				var leftArrow_renderer:SpriteRenderer = new SpriteRenderer();
				with (leftArrow_renderer) {
					scene = PBE.scene;
					positionProperty = new PropertyReference("@Spatial.position");
					sizeProperty = new PropertyReference("@Spatial.size");
					fileName = arrowFilePath;
					layerIndex = 2;
					rotation = 45;
				}
				_leftArrow.addComponent(leftArrow_renderer, "Render");
				
				_leftArrow.initialize();
				
				// Right Arrow
				_rightArrow = PBE.allocateEntity();
				
				var rightArrow_spatial:SimpleSpatialComponent = new SimpleSpatialComponent();
				rightArrow_spatial.spatialManager = PBE.spatialManager;
				rightArrow_spatial.position = new Point(position.x + 150, position.y + 70);
				rightArrow_spatial.size = arrowSize;
				
				_rightArrow.addComponent(rightArrow_spatial, "Spatial");
				
				var rightArrow_renderer:SpriteRenderer = new SpriteRenderer();
				with (rightArrow_renderer) {
					scene = PBE.scene;
					positionProperty = new PropertyReference("@Spatial.position");
					sizeProperty = new PropertyReference("@Spatial.size");
					fileName = arrowFilePath;
					layerIndex = 2;
					rotation = 315;
					scale = new Point(-1, 1);
				}
				_rightArrow.addComponent(rightArrow_renderer, "Render");
				
				_rightArrow.initialize();
				
				
				_elementsDisplayed = true;
				PBE.processManager.schedule(3000, owner, cleanDisplay);
			}
		}
		
		private function cleanDisplay():void {
			_text.destroy();
			_leftArrow.destroy();
			_rightArrow.destroy();
		}
	}
}