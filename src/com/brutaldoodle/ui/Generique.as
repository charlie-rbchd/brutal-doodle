package com.brutaldoodle.ui{
	//Importer les classes nécessaires
	import com.brutaldoodle.ui.chargement.ChargeurMedia;
	import com.pblabs.engine.PBE;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class Generique extends MovieClip{
		[Embed(source="../assets/Images/BackgroundLevel1.jpg")]
		private var AP:Class;
		
		
		public var _ap:DisplayObject = new AP();
		public var _txt:Sprite;
		public var _img:Sprite;
		
		public var chargementXML:URLLoader = new URLLoader();// objet de chargement
		public var fichier:URLRequest;
		public var texte:XML;
		public var personnes:XMLList;
		
		public var visionneuse:ChargeurMedia;

		public var formatTxtPrinc:TextFormat;
		public var formatTxtSec:TextFormat;

		public function Generique(){
			
			 _txt = new Sprite();
			 _img = new Sprite();
			 
			// Importer/charger le XML
			fichier = new URLRequest("../assets/xml/texte.xml");

			formatTxtPrinc = new TextFormat();
			formatTxtSec = new TextFormat()
			
			//Déterminer les différents formats du texte du générique
			formatTxtPrinc.font = formatTxtSec.font = "Arial";
			formatTxtPrinc.size = 35;
			formatTxtSec.size=25;
			formatTxtPrinc.align = formatTxtSec.align = TextFormatAlign.CENTER;
			formatTxtPrinc.color = formatTxtSec.color = 0xFFFFFF;

			addChild(_ap);
			addChild(_txt);
					
			// Ici on load le XML et lorsque c'est terminé on se rends dans une nouvelle fonction
			// qui déterminera le placement des images etc.
			chargementXML.load(fichier);
			chargementXML.addEventListener(Event.COMPLETE, chargementComplet);
		}

		public function chargementComplet(pEvt:Event):void{
			// on divise les différentes sections du personnages (nom, rôle et lien de l'image y correspondant)
			texte = new XML(pEvt.target.data);
			personnes = texte.elements();
						
			// Cette boucle crée une instance différente pour chacun des membres de l'équipe et les
			// place dans le stage. On y charge aussi l'image nécessaire.
			for(var i:int=0;i<personnes.length();i++){
				var leNom:TextField = new TextField();
				var leRole:TextField = new TextField();
				visionneuse = new ChargeurMedia(200,200);
				
				leNom.width = leRole.width = 600;
				
				leRole.text = personnes[i].role;
				leNom.text = personnes[i].nom;
				visionneuse.load(new URLRequest(personnes[i].img));
				visionneuse.name = String(i);
										
				leRole.setTextFormat(formatTxtSec);
				leNom.setTextFormat(formatTxtPrinc);
				
				visionneuse.y = i*125;
				leRole.y = i * 120;
				leNom.y = (i*120)+30;;
				
				visionneuse.x = 100;
				_txt.x = 200;
				_txt.y = PBE.mainStage.stageHeight;
				
				_txt.addChild(leRole);
				_txt.addChild(leNom);
				
				_img.addChild(visionneuse);
			}
			
			// Une fois la boucle terminé, on lance la fonction qui animera le texte.
			this.addEventListener(Event.ENTER_FRAME, defilement);
		}
		
		public function defilement(pEvt:Event):void{
			// Ici on fait simplement défiler le texte et on l'arrête une fois rendu à 70px.
			// Ensuite on lance la fonction qui arrêtera le tout.
			if(_txt.y <= PBE.mainStage.stageHeight){
				_txt.y = _txt.y-5;
			}			
			if(_txt.y < 75){
				arret();
			}
		}
		
		public function arret():void {
			// On arrête l'enter-frame devenu inutile du défilmenet et on fait afficher les images graduellement
			// en augmentant leur alpha
			this.removeEventListener(Event.ENTER_FRAME, defilement);
			this.addEventListener(Event.ENTER_FRAME, afficherImg);
			addChild(_img);
			_img.alpha=0;
		}
		
		public function afficherImg(pEvt:Event):void{
			if(_img.alpha <= 1){
				_img.alpha += .01;
			}
		}
	}
}