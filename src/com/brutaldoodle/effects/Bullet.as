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
		public static var damage:Number;
		
		public function Bullet() {
			super();
			
			_damageAmount = Bullet.damage;
			
			//Generate one particle
			counter = new Blast(1);
			
			//Make the withe dot in the black dot image for the particle
			//so it's visible on any background
			var bullet:Sprite = new Sprite();
			bullet.addChild( new Dot(3, 0x222222) );
			bullet.addChild( new Dot(2, 0xDDDDDD) );
			
			addInitializer( new SharedImage( bullet ) );
			addInitializer( new Velocity( new PointZone( new Point(0, -250) ) ) );
			
			addAction( new Move() );
		}
	}
}