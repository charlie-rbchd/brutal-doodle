package com.brutaldoodle.effects
{
	import com.brutaldoodle.emitters.PlayerCollidableEmitter;
	
	import flash.geom.Point;
	
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.displayObjects.Dot;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.ColorsInit;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.common.utils.Maths;
	import org.flintparticles.twoD.actions.Accelerate;
	import org.flintparticles.twoD.actions.Friction;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.activities.FollowMouse;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.ScaleAllInit;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.zones.DiscSectorZone;
	import org.flintparticles.twoD.zones.RectangleZone;
	
	public class Blood extends PlayerCollidableEmitter
	{
		public function Blood()
		{
			super();
			
			_damageAmount = 2;
			
			counter = new Blast(5);
			
			addInitializer( new SharedImage( new Dot( 3 ) ) );
			addInitializer( new ColorInit(0xff00ff00, 0xff038203) );
			addInitializer( new Position( new RectangleZone(-20, 10, 20, 30 ) ) );
			addInitializer( new ScaleAllInit( 0.5, 1.5 ) );
			addInitializer( new Velocity(new DiscSectorZone( new Point(0,0), 200, 150, Maths.asRadians(80), Maths.asRadians(100) ) ) );
			addAction( new Move() );
		}
	}
}