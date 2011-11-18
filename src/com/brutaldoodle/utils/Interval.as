package com.brutaldoodle.utils
{
	public class Interval
	{
		public var minTime:Number;
		public var maxTime:Number;
		
		public function Interval(min:Number=0, max:Number=1000) {
			minTime = min;
			maxTime = max;
		}
		
		public function getTime ():Number {
			return minTime + (Math.random() * (maxTime - minTime));
		}
	}
}