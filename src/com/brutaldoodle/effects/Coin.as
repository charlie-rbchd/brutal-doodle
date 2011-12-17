package com.brutaldoodle.effects
{
	import com.brutaldoodle.emitters.CollidableEmitter;
	import com.brutaldoodle.emitters.PlayerCollidableEmitter;
	
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.initializers.CollisionRadiusInit;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.zones.PointZone;
	
	public class Coin extends PlayerCollidableEmitter
	{
		//embed the image of the particle
		[Embed(source="assets/Images/Coin.png")]
		private var CoinAsset:Class;
		
		public function Coin() {
			super();
			
			_damageAmount = 12;
			//Tell to the collision manager that this particle is money
			_actionOnCollision = CollidableEmitter.UPDATE_MONEY_COUNT;
			
			//Generate one particle
			counter = new Blast(1);
			
			//give the image to the particle
			var coin:Bitmap = new CoinAsset();
			
			//give a radius for the collision with the boundingBox
			addInitializer( new CollisionRadiusInit(21) );
			addInitializer( new SharedImage( coin ) );
			addInitializer( new Velocity( new PointZone( new Point(0, 85) ) ) );
			addInitializer( new Position( new PointZone( new Point(coin.width/2, 0) ) ) );
			addAction( new Move() );
		}
	}
}