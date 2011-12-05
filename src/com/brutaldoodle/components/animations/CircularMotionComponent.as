package com.brutaldoodle.components.animations
{
	import com.brutaldoodle.utils.Ellipse;
	import com.brutaldoodle.utils.Maths;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.PropertyReference;
	
	import flash.geom.Point;

	public class CircularMotionComponent extends EntityComponent
	{
		public var positionProperty:PropertyReference;
		public var timeOffset:Number;
		public var ellipse:Ellipse;
		
		public function CircularMotionComponent()
		{
			super();
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			owner.setProperty(positionProperty, ellipse.getPointAtAngle( (new Date().hours + timeOffset) * 15) );
		}
	}
}