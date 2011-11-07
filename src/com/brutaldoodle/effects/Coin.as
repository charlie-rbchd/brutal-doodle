package com.brutaldoodle.effects
{
	import com.brutaldoodle.emitters.PlayerCollidableEmitter;
	
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.displayObjects.Dot;
	import org.flintparticles.common.initializers.CollisionRadiusInit;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.zones.PointZone;
	
	public class Coin extends PlayerCollidableEmitter
	{
		[Embed(source="assets/Images/Coin.png")]
		private var CoinAsset:Class;
		
		public function Coin()
		{
			super();
			
			_damageAmount = 0;
			
			counter = new Blast(1);
			
			var coin:Bitmap = new CoinAsset();
			
			addInitializer( new CollisionRadiusInit(coin.height) );
			addInitializer( new SharedImage( coin ) );
			addInitializer( new Velocity( new PointZone( new Point(0, 75) ) ) );
			addInitializer( new Position( new PointZone( new Point(coin.width/2, 0) ) ) );
			addAction( new Move() );
		}
	}
}