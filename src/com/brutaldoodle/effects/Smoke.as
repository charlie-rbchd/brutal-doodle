package com.brutaldoodle.effects
{
	import flash.geom.Point;
	
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.actions.Fade;
	import org.flintparticles.common.counters.TimePeriod;
	import org.flintparticles.common.displayObjects.RadialDot;
	import org.flintparticles.common.easing.Quadratic;
	import org.flintparticles.common.initializers.ColorsInit;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.actions.RandomDrift;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.zones.DiscSectorZone;
	
	public class Smoke extends Emitter2D
	{
		public function Smoke() {
			counter = new TimePeriod(15, 0.5);
			
			addInitializer( new Lifetime( 2, 3 ) );
			addInitializer( new Velocity( new DiscSectorZone(new Point(0, 0), 40, 30, -4 * Math.PI / 7, -3 * Math.PI / 7) ) );
			addInitializer( new SharedImage( new RadialDot(6) ) );
			addInitializer( new ColorsInit( new Array(0x444444, 0x666666, 0x888888, 0xAAAAAA, 0xCCCCCC) ) );
			
			addAction( new Age(Quadratic.easeOut) );
			addAction( new Move() );
			addAction( new Fade(0.25, 0) );
			addAction( new RandomDrift(15, 15) );
		}
	}
}