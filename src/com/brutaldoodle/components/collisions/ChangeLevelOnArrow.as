package com.brutaldoodle.components.collisions
{
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.core.LevelManager;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	
	import flash.geom.Point;
	
	public class ChangeLevelOnArrow extends TickedComponent
	{
		public static var activated:Array = new Array();
		
		public var positionProperty:PropertyReference;
		public var sizeProperty:PropertyReference;
		public var alphaProperty:PropertyReference;
		public var orientation:String;
		
		public function ChangeLevelOnArrow()
		{
			super();
		}
		
		override public function onTick(deltaTime:Number):void
		{
			super.onTick(deltaTime);
			
			var spatial:SimpleSpatialComponent = PBE.lookupComponentByName("Player", "Spatial") as SimpleSpatialComponent;
			var tankPosition:Point = spatial.position;
			var tankSize:Point = spatial.size;
			
			var position:Point = owner.getProperty(positionProperty);
			var size:Point = owner.getProperty(sizeProperty);
			var alpha:Number = owner.getProperty(alphaProperty);
			
			if (orientation == "right")
			{
				if (tankPosition.x + tankSize.x >= position.x)
				{
					alpha = 1;
					ChangeLevelOnArrow.activated[orientation] = true;
				}
			}
			else if (orientation == "left") 
			{
				if (tankPosition.x - tankSize.x <= position.x)
				{
					alpha = 1;
					ChangeLevelOnArrow.activated[orientation] = true;
				}
			}
			else if (orientation == "top") 
			{
				if (tankPosition.y - tankSize.y <= position.y)
				{
					if (tankPosition.x <= position.x + 10 && tankPosition.x >= position.x - 10)
					{	
						alpha = 1;
						ChangeLevelOnArrow.activated[orientation] = true;
					}
				}
			}
			
			owner.setProperty(alphaProperty, alpha);
			
			if (ChangeLevelOnArrow.activated["right"] == true
			 && ChangeLevelOnArrow.activated["left"]  == true
			 && ChangeLevelOnArrow.activated["top"]   == true)
			{
				LevelManager.instance.loadLevel(LevelManager.instance.currentLevel + 1, true);
			}
		}
	}
}