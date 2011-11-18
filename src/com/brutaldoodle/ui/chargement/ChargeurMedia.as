package com.brutaldoodle.ui.chargement {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	public class ChargeurMedia extends Sprite {	
		private var chargeur:Loader;
		private var cli:LoaderInfo;
		private var largeur:Number;
		private var hauteur:Number;
		private var lissage:Boolean;
		
		public function ChargeurMedia (pLargeur:Number,
									   pHauteur:Number,
									   pLissage:Boolean=true) {	
			largeur = pLargeur;
			hauteur = pHauteur;
			lissage = pLissage;
			chargeur = new Loader();
			
			addChild (chargeur);

			cli = chargeur.contentLoaderInfo;
			
			addEventListener(Event.ADDED_TO_STAGE, activation);
			addEventListener(Event.REMOVED_FROM_STAGE, desactivation);	
		}
		
		private function activation (pEvt:Event):void {
			cli.addEventListener(Event.INIT, redirigeEvenement);
			cli.addEventListener(Event.OPEN, redirigeEvenement);
			cli.addEventListener(ProgressEvent.PROGRESS, redirigeEvenement);
			cli.addEventListener(Event.COMPLETE, chargementTermine);
			cli.addEventListener(IOErrorEvent.IO_ERROR, redirigeEvenement);
		}
		
		private function desactivation(pEvt:Event):void {
			cli.removeEventListener(Event.INIT, redirigeEvenement);
			cli.removeEventListener(Event.OPEN, redirigeEvenement);
			cli.removeEventListener(ProgressEvent.PROGRESS, redirigeEvenement);
			cli.removeEventListener(Event.COMPLETE, chargementTermine);
			cli.removeEventListener(IOErrorEvent.IO_ERROR, redirigeEvenement);
		}
		
		public function load ( pURL:URLRequest, pContext:LoaderContext=null ):void {
			chargeur.load (pURL, pContext);	
		}
		
		private function redirigeEvenement (pEvt:Event):void {
			dispatchEvent (pEvt);	
		}
		
		public function close ():void {
			chargeur.close();	
		}
		
		private function chargementTermine (pEvt:Event):void {
			var contenuCharge:DisplayObject = pEvt.target.content;
			
			if (contenuCharge is Bitmap)
				Bitmap (contenuCharge).smoothing = lissage;
			
			var ratio:Number = Math.min (largeur / contenuCharge.width,
										 hauteur / contenuCharge.height);
			//Si les dimensions du contenu chargé sont supérieures à ceux de la visionneuse,
			//les ajuster
			scaleX = scaleY = (ratio < 1) ? ratio : 1;
			
			dispatchEvent (pEvt);
		}
	}
}