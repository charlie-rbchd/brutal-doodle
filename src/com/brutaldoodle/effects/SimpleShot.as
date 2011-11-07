package com.brutaldoodle.effects
{
	import com.brutaldoodle.emitters.PlayerCollidableEmitter;
	
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.displayObjects.Dot;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Accelerate;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.zones.RectangleZone;
	
	public class SimpleShot extends PlayerCollidableEmitter
	{
		public function SimpleShot()
		{
			super();
			
			_damageAmount = 10;
			
			counter = new Blast(1);
			
			addInitializer( new SharedImage( new Dot( 3 ) ) );
			addInitializer( new ColorInit( 0xFFFF00FF, 0xFF00FFFF ) );
			addAction( new Accelerate( 0, 100 ) );
			addAction( new Move() );
		}
	}
}