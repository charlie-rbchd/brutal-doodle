package com.brutaldoodle.utils
{
	import flash.geom.Point;

	public class Maths
	{
		public function Maths() {}
		
		public static function radiansToDegrees (radians:Number):Number {
			return radians * 180/Math.PI;
		}
		
		public static function degreesToRadians (degrees:Number):Number {
			return degrees * Math.PI/180;
		}
	}
}