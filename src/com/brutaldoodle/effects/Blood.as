package com.brutaldoodle.effects
{
	import com.brutaldoodle.emitters.PlayerCollidableEmitter;
	
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.common.utils.Maths;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.ScaleAllInit;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.zones.DiscSectorZone;
	import org.flintparticles.twoD.zones.RectangleZone;
	
	public class Blood extends PlayerCollidableEmitter
	{
		//embed the image of the particle
		[Embed(source="assets/Images/Blood.png")]
		private var BloodAsset:Class;
		
		public function Blood() {
			super();
			
			_damageAmount = 5;
			
			//Generate 5 particle instantly
			counter = new Blast(5);
			
			//give the image to the particle
			var blood:Bitmap = new BloodAsset();
			
			addInitializer( new SharedImage( blood ) );
			
			//Give the particle a color between those 2
			addInitializer( new ColorInit(0xff00ff00, 0xff038203) );
			
			//Generate the particles in at a random point in this rectangle
			addInitializer( new Position( new RectangleZone(-20, 10, 20, 30 ) ) );
			
			//give the particles a ramon scale
			addInitializer( new ScaleAllInit( 0.5, 1.5 ) );
			
			//give them a ramdon direction
			addInitializer( new Velocity(new DiscSectorZone( new Point(0,0), 200, 150, Maths.asRadians(80), Maths.asRadians(100) ) ) );
			addAction( new Move() );
		}
	}
}