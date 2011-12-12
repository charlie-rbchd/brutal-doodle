package com.brutaldoodle.effects
{ 
	
	import com.brutaldoodle.emitters.PlayerCollidableEmitter;
	
	import flash.geom.Point;
	
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.displayObjects.Dot;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.actions.MutualGravity;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.zones.PointZone;
	import org.flintparticles.twoD.zones.RectangleZone;
	
	public class HazardousShot extends PlayerCollidableEmitter
	{
		public function HazardousShot() {
			super();
			
			_damageAmount = 8;
			
			//Generate 10 particles instantly
			counter = new Blast(5);
			
			addInitializer( new SharedImage( new Dot(2) ) );
			
			//Give the particle a color between those 2
			addInitializer( new ColorInit(0xFFFF0000, 0xFFFFFF00) );
			
			//Generate the particles in at a random point in this rectangle
			addInitializer( new Position( new RectangleZone(-25, -25, 25, 25) ) );
			addInitializer( new Velocity( new PointZone( new Point(0, 100) ) ) );
			
			addAction( new MutualGravity(1, 30) );
			addAction( new Move() );
		}
	}
}