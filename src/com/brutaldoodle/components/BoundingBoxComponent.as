package com.brutaldoodle.components
{
	import com.pblabs.engine.entity.EntityComponent;
	
	import flash.geom.Rectangle;
	
	import org.flintparticles.twoD.zones.RectangleZone;
	
	public class BoundingBoxComponent extends EntityComponent
	{
		public static const TYPE_PLAYER:String = "player";
		public static const TYPE_ENEMY:String = "enemy";
		public static const TYPE_ALLY:String = "ally";
		public static const TYPE_NEUTRAL:String = "neutral";
		
		private static var _boundingBoxes:Object = {
			player: null,
			enemy: new Vector.<RectangleZone>(),
			ally: new Vector.<RectangleZone>(),
			neutral: new Vector.<RectangleZone>()
		};
		
		private var _boundingBox:RectangleZone;
		
		public function BoundingBoxComponent()
		{
			super();
			_boundingBox = new RectangleZone();
		}
		
		public function registerForCollisions (type:String):void {
			switch (type) {
				case "player":
					_boundingBoxes.player = _boundingBox;
					break;
				case "enemy":
				case "ally":
				case "neutral":
					_boundingBoxes[type].push(_boundingBox);
					break;
				default:
					throw new Error("Le type de bounding box doit être définit par une des constantes de classe.");
			}
		}
		
		public function set zone (value:Rectangle):void {
			_boundingBox.top = value.top;
			_boundingBox.left = value.left;
			_boundingBox.bottom = value.bottom;
			_boundingBox.right = value.right;
		}
		
		public function get zone ():Rectangle {
			return new Rectangle(
				_boundingBox.left,
				_boundingBox.top,
				_boundingBox.right - _boundingBox.left,
				_boundingBox.bottom - _boundingBox.top
			);
		}
		
		public static function get boundingBoxes ():Object { return _boundingBoxes; }
	}
}