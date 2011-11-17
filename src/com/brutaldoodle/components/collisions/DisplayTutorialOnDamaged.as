package com.brutaldoodle.components.collisions
{
	import com.pblabs.components.basic.HealthEvent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	import com.pblabs.rendering2D.SpriteRenderer;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	//create a visual warning for the user to that acid is going to drop from the ennemy
	public class DisplayTutorialOnDamaged extends EntityComponent
	{
		public var filePath:String;
		public var filePathArrow:String;
		public var position:Point;
		public var size:Point;
		public var sizeArrow:Point;
	
		public static var firstInstance:Boolean = true;
		public static var timerDestroy:Timer = new Timer(3000,1);
		
		private static var textImage:IEntity = PBE.allocateEntity();
		private static var arrowImage:IEntity = PBE.allocateEntity();
		private static var arrowImage2:IEntity = PBE.allocateEntity();
		
		public function DisplayTutorialOnDamaged()
		{
			super();
		}
		
		override protected function onAdd():void
		{	
			owner.eventDispatcher.addEventListener(HealthEvent.DAMAGED, onDamaged);
		}
		
		override protected function onRemove():void
		{
			owner.eventDispatcher.removeEventListener(HealthEvent.DAMAGED, onDamaged);
		}
		
		private function onDamaged (event:HealthEvent):void
		{
			if(DisplayTutorialOnDamaged.firstInstance == true)
			{	
				//text(warning)
				var spatial:SimpleSpatialComponent = new SimpleSpatialComponent();
				spatial.spatialManager = PBE.spatialManager;
				spatial.position = position;
				spatial.size = size;
				
				DisplayTutorialOnDamaged.textImage.addComponent(spatial, "Spatial");
				
				var Renderer:SpriteRenderer = new SpriteRenderer();
				Renderer.scene = PBE.scene;
				Renderer.positionProperty = new PropertyReference("@Spatial.position");
				Renderer.sizeProperty = new PropertyReference("@Spatial.size");
				Renderer.fileName = filePath;
				Renderer.layerIndex = 2;
				
				DisplayTutorialOnDamaged.textImage.addComponent(Renderer,"Renderer");
				
				DisplayTutorialOnDamaged.textImage.initialize();
				
				
				
				//image(arrow1)
				var spatialArrow:SimpleSpatialComponent = new SimpleSpatialComponent();
				spatialArrow.spatialManager = PBE.spatialManager;
				spatialArrow.position = new Point(position.x - 150,position.y + 70);
				spatialArrow.size = sizeArrow;
				
				DisplayTutorialOnDamaged.arrowImage2.addComponent(spatialArrow, "Spatial");
				
				var RendererArrow:SpriteRenderer = new SpriteRenderer();
				RendererArrow.scene = PBE.scene;
				RendererArrow.positionProperty = new PropertyReference("@Spatial.position");
				RendererArrow.sizeProperty = new PropertyReference("@Spatial.size");
				RendererArrow.fileName = filePathArrow;
				RendererArrow.layerIndex = 2;
				RendererArrow.rotation = 45;
				
				DisplayTutorialOnDamaged.arrowImage2.addComponent(RendererArrow,"Renderer");
				
				DisplayTutorialOnDamaged.arrowImage2.initialize();
				
				//image(arrow2)
				var spatialArrow2:SimpleSpatialComponent = new SimpleSpatialComponent();
				spatialArrow2.spatialManager = PBE.spatialManager;
				spatialArrow2.position = new Point(position.x + 150,position.y + 70);
				spatialArrow2.size = sizeArrow;
				
				DisplayTutorialOnDamaged.arrowImage.addComponent(spatialArrow2, "Spatial");
				
				var RendererArrow2:SpriteRenderer = new SpriteRenderer();
				RendererArrow2.scene = PBE.scene;
				RendererArrow2.positionProperty = new PropertyReference("@Spatial.position");
				RendererArrow2.sizeProperty = new PropertyReference("@Spatial.size");
				RendererArrow2.fileName = filePathArrow;
				RendererArrow2.layerIndex = 2;
				RendererArrow2.rotation = 315;
				RendererArrow2.scale = new Point(-1,1);
				
				DisplayTutorialOnDamaged.arrowImage.addComponent(RendererArrow2,"Renderer");
				
				DisplayTutorialOnDamaged.arrowImage.initialize();
				//set the firstInstance variable to false so the warning won't show more than one time
				DisplayTutorialOnDamaged.firstInstance = false;
				DisplayTutorialOnDamaged.timerDestroy.addEventListener(TimerEvent.TIMER_COMPLETE,destroyDisplay);
				DisplayTutorialOnDamaged.timerDestroy.start();
				
			}
		}
		
		private function destroyDisplay(pEvt:TimerEvent):void
		{
			DisplayTutorialOnDamaged.textImage.destroy();
			DisplayTutorialOnDamaged.arrowImage.destroy();
			DisplayTutorialOnDamaged.arrowImage2.destroy();
		}
	}
}