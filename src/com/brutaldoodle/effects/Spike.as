package com.brutaldoodle.effects
{
	import com.brutaldoodle.emitters.EnemyCollidableEmitter;
	
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.initializers.CollisionRadiusInit;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.zones.PointZone;
	
	public class Spike extends EnemyCollidableEmitter
	{
		[Embed(source="assets/Images/Spike.png")]
		private var SpikeAsset:Class;
				
		public function Spike()
		{
			super();
			
			_damageAmount = 1;
			
			//give the image to the particle
			var spike:Bitmap = new SpikeAsset();
			addInitializer( new SharedImage( spike ) );
			
			//Generate one particle
			counter = new Blast(1);
			
			addInitializer( new CollisionRadiusInit(0.01) );
			
			//This var is set to a random value of -1 or 1;
			var direction:int = Math.floor(Math.random() * 2) ? 1 : -1;
			//position and velocity of the particle. 
			addInitializer( new Velocity( new PointZone( new Point(direction * 10, 0) ) ) );
			//We want to spawn the particle on the good side to avoid collision with the owner.
			addInitializer( new Position( new PointZone( new Point(direction * 30, 0) ) ) );
			
			addAction( new Move() );
		}
	}
}