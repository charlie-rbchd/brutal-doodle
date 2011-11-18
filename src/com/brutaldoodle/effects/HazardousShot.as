package com.brutaldoodle.effects
{ 
	
	import com.brutaldoodle.emitters.PlayerCollidableEmitter;
	
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.displayObjects.Dot;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.GravityWell;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.zones.RectangleZone;
	
	public class HazardousShot extends PlayerCollidableEmitter
	{
		//private var _posX:Number = 0;
		//private var _posY:Number = -300;
		
		public function HazardousShot() {
			super();
			
			//Generate 10 particles instantly
			counter = new Blast(10);
			
			addInitializer( new SharedImage( new Dot(1) ) );
			
			//Give the particle a color between those 2
			addInitializer( new ColorInit(0xFFFF00FF, 0xFF00FFFF) );
			
			//Generate the particles in at a random point in this rectangle
			addInitializer( new Position( new RectangleZone(-25, -25, 25, 25) ) );
			addAction( new GravityWell(100, 0, 300, 50) );
		
			addAction( new Move() );
		}
		
		//For the movement of the gravity wells (not implemented yet)
		/*
		public function set posX(pX:Number):void {
			_posX = pX;
			//_posX = (this.actions[0] as GravityWell).x = (this.actions[1] as GravityWell).x = (this.actions[2] as GravityWell).x  = pX;
		}
		
		public function set posY(pY:Number):void {
			_posY = pY;
			//_posY = (this.actions[0] as GravityWell).y = (this.actions[1] as GravityWell).y = (this.actions[2] as GravityWell).y = pY;
		}
		
		public function get posX():Number { return _posX; }
		public function get posY():Number { return _posY; }
		*/
	}
}