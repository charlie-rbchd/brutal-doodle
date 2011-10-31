package com.brutaldoodle.effects
{
	import com.brutaldoodle.emitters.EnemyCollidableEmitter;
	
	import flash.display.Sprite;
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
			
			_damageAmount = 25;
			
			counter = new Blast(1);
			
			var bullet:Sprite = new Sprite();
			bullet.addChild( new Dot(3, 0x222222) );
			bullet.addChild( new Dot(2, 0xDDDDDD) );
			
			addInitializer( new SharedImage( bullet ) );
			addInitializer( new Velocity( new PointZone( new Point(0, -250) ) ) );
			
			addAction( new Move() );
		}
	}
}