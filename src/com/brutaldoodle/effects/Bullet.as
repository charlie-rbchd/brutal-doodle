package com.brutaldoodle.effects
{
	import com.brutaldoodle.emitters.EnemyCollidableEmitter;
	
	import flash.geom.Point;
	
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.displayObjects.Dot;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.zones.PointZone;
	
	public class Bullet extends EnemyCollidableEmitter
	{
		public function Bullet()
		{
			super();
			
			counter = new Blast(1);
			
			addInitializer( new SharedImage( new Dot(3, 0x444444) ) );
			addInitializer( new Velocity( new PointZone( new Point(0, -150) ) ) );
			
			addAction( new Move() );
		}
	}
}