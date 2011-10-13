package com.brutaldoodle.components
{
	import com.pblabs.engine.entity.EntityComponent;
	
	import flash.geom.Rectangle;
	
	import org.flintparticles.twoD.zones.RectangleZone;
	
	public class BoundingBoxComponent extends EntityComponent
	{
		private static var _boundingBoxes:Array = new Array();
		
		private var _zone:Rectangle;
		private var _boundingBox:RectangleZone;
		
		public function BoundingBoxComponent()
		{
			super();
			_zone = new Rectangle();
			_boundingBox = new RectangleZone();
			_boundingBoxes.push(_boundingBox);
		}
		
		public function set zone (value:Rectangle):void {
			_boundingBox.top = _zone.top = value.top;
			_boundingBox.left = _zone.left = value.left;
			_boundingBox.bottom = _zone.bottom = value.bottom;
			_boundingBox.right = _zone.right = value.right;
		}
		
		public function get zone ():Rectangle { return _zone; }
		public function get boundingBox ():RectangleZone { return _boundingBox; }
		
		public static function get boundingBoxes ():Array { return _boundingBoxes; }
	}
}