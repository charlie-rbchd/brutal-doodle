package com.brutaldoodle.effects
{
	import flash.geom.Point;
	
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.displayObjects.RadialDot;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.zones.DiscZone;
	
	public class Warp extends Emitter2D
	{		
		public function Warp()
		{
			super();
			//set the counter to a blast emitter
			counter = new Blast(50);
			
			//set the visual
			addInitializer( new SharedImage( new RadialDot(3, 0xFFFFFFF) ) );
			
			//set position in a disc zone
			addInitializer( new Position( new DiscZone( new Point(0, 0), 40 ) ));
			
			//set the lifetime for the particle
			addInitializer( new Lifetime(1) );
			
			addAction( new Age() );
			addAction( new Move() );	
		}
	}
}