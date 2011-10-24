package com.brutaldoodle.effects
{
	import com.brutaldoodle.emitters.PlayerCollidableEmitter;
	
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.displayObjects.Dot;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Accelerate;
	import org.flintparticles.twoD.actions.BoundingBox;
	import org.flintparticles.twoD.actions.GravityWell;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.zones.RectangleZone;
	
	public class SimpleShot extends PlayerCollidableEmitter
	{
		private var _posX:Number = 0;
		private var _posY:Number = 0;
		
		public function SimpleShot()
		{
			super();
			
			//Set the amount of healt losen each a particle collide with the tank
			//_damageAmount = 50;
			
			counter = new Blast( 2 );
			
			addInitializer( new SharedImage( new Dot( 3 ) ) );
			addInitializer( new ColorInit( 0xFFFF00FF, 0xFF00FFFF ) );
			addInitializer( new Position( new RectangleZone( 0, 0, 0, 0 ) ) );
			addAction( new Accelerate( 0 ,100 ) );
			addAction( new Move( ) );
		}
	}
}