package com.brutaldoodle.effects
{
	import com.brutaldoodle.emitters.PlayerCollidableEmitter;
	
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.displayObjects.Dot;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Accelerate;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.ScaleAllInit;
	import org.flintparticles.twoD.zones.RectangleZone;
	
	public class Blood extends PlayerCollidableEmitter
	{
		public function Blood()
		{
			super();
			
			_damageAmount = 5;
			
			counter = new Blast(3);
			
			addInitializer( new SharedImage( new Dot( 3 ) ) );
			addInitializer( new Position( new RectangleZone(-20, 10, 20, 30 ) ) );
			addInitializer( new ScaleAllInit( 0.5, 1.5 ) );
			addAction( new Accelerate( 0, 100 ) );
			addAction( new Move() );
		}
	}
}