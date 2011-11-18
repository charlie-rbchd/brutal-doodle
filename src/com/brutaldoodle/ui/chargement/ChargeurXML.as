package com.brutaldoodle.ui.chargement {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	
	public class ChargeurXML extends EventDispatcher {
		
		public static const NO_CACHE:Boolean = true;
		public static const CACHE:Boolean = false;
		
		private var chargeur:URLLoader;
		private var fluxXML:XML;
		private var antiCache:Boolean;
		
		public function ChargeurXML(pAntiCache:Boolean=false) {	
			antiCache = pAntiCache;
			
			chargeur = new URLLoader();
			
			chargeur.dataFormat = URLLoaderDataFormat.TEXT;
			
			chargeur.addEventListener(Event.OPEN, redirigeEvenement);
			chargeur.addEventListener(ProgressEvent.PROGRESS, redirigeEvenement);
			chargeur.addEventListener(Event.COMPLETE, chargementTermine);
			chargeur.addEventListener(HTTPStatusEvent.HTTP_STATUS, redirigeEvenement);
			chargeur.addEventListener(IOErrorEvent.IO_ERROR, redirigeEvenement);
			chargeur.addEventListener(SecurityErrorEvent.SECURITY_ERROR, redirigeEvenement);
		}
		
		public function charge(pRequete:URLRequest):void {
			if (antiCache)
				pRequete.requestHeaders.push(new URLRequestHeader("pragma", "no-cache"));
			
			chargeur.load(pRequete);	
		}
		
		private function redirigeEvenement(pEvt:Event):void {
			dispatchEvent(pEvt);	
		}
		
		private function chargementTermine (pEvt:Event):void {
			try	{
				fluxXML = new XML (pEvt.currentTarget.data);
			} catch(pErreur:Error) {
				trace(pErreur);	
			}
			dispatchEvent (pEvt);
		}
		
		public function get donnees():XML	{
			return fluxXML;	
		}
	}
}
