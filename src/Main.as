package
{
	import com.brutaldoodle.collisions.CollisionManager;
	import com.brutaldoodle.components.ai.BasicAIComponent;
	import com.brutaldoodle.components.ai.BeamerAIComponent;
	import com.brutaldoodle.components.ai.ButterflyAIComponent;
	import com.brutaldoodle.components.ai.CannibalAIComponent;
	import com.brutaldoodle.components.ai.EnemyMobilityComponent;
	import com.brutaldoodle.components.ai.WarperAIComponent;
	import com.brutaldoodle.components.animations.ChangeEnvironmentComponent;
	import com.brutaldoodle.components.animations.ChangeStateOnRaycastWithPlayer;
	import com.brutaldoodle.components.animations.CircularMotionComponent;
	import com.brutaldoodle.components.animations.WiggleComponent;
	import com.brutaldoodle.components.basic.HealthComponent;
	import com.brutaldoodle.components.basic.HeartComponent;
	import com.brutaldoodle.components.basic.MoneyComponent;
	import com.brutaldoodle.components.collisions.BoundingBoxComponent;
	import com.brutaldoodle.components.collisions.ChangeLevelOnArrow;
	import com.brutaldoodle.components.collisions.ChangeStateOnDamaged;
	import com.brutaldoodle.components.collisions.DestroyOnAllDead;
	import com.brutaldoodle.components.collisions.DisplayTutorialOnDamaged;
	import com.brutaldoodle.components.collisions.DropBloodOnDamaged;
	import com.brutaldoodle.components.collisions.DropCoinOnDeath;
	import com.brutaldoodle.components.collisions.FadeInDisplayOnCollision;
	import com.brutaldoodle.components.collisions.UpdateHealthDisplayOnDamaged;
	import com.brutaldoodle.components.controllers.CanonController;
	import com.brutaldoodle.components.controllers.ChangeVolumeOnDrag;
	import com.brutaldoodle.components.controllers.LoadLevelOnKeypress;
	import com.brutaldoodle.components.controllers.PlayerController;
	import com.brutaldoodle.components.controllers.UpdateStatsOnClick;
	import com.brutaldoodle.effects.Bullet;
	import com.brutaldoodle.entities.Countdown;
	import com.brutaldoodle.rendering.ParticleManager;
	import com.pblabs.animation.AnimatorComponent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.GroupManagerComponent;
	import com.pblabs.engine.core.LevelManager;
	import com.pblabs.rendering2D.AnimationController;
	import com.pblabs.rendering2D.AnimationControllerInfo;
	import com.pblabs.rendering2D.SpriteSheetRenderer;
	import com.pblabs.rendering2D.spritesheet.CellCountDivider;
	import com.pblabs.rendering2D.ui.PBLabel;
	import com.pblabs.rendering2D.ui.SceneView;
	import com.pblabs.sound.BackgroundMusicComponent;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	[SWF(width="960", height="680", frameRate="30", backgroundColor="0x000000")]
	public class Main extends Sprite
	{
		/*
		 * Whether or not the game is over
		 */
		public static var gameOver:Boolean = false;
		
		/*
		 * Whether or not the game is currently running (not paused)
		 */
		private static var _running:Boolean = true;
		
		public function Main() {
			// These types need to be registered in order to be used in pbelevel files
			PBE.registerType(com.pblabs.engine.components.GroupManagerComponent);
			PBE.registerType(com.pblabs.animation.AnimatorComponent);
			PBE.registerType(com.pblabs.sound.BackgroundMusicComponent);
			PBE.registerType(com.pblabs.rendering2D.SpriteSheetRenderer);
			PBE.registerType(com.pblabs.rendering2D.AnimationController);
			PBE.registerType(com.pblabs.rendering2D.AnimationControllerInfo);
			PBE.registerType(com.pblabs.rendering2D.spritesheet.CellCountDivider);
			PBE.registerType(com.pblabs.rendering2D.ui.PBLabel);
			
			PBE.registerType(com.brutaldoodle.components.ai.BasicAIComponent);
			PBE.registerType(com.brutaldoodle.components.ai.CannibalAIComponent);
			PBE.registerType(com.brutaldoodle.components.ai.EnemyMobilityComponent);
			PBE.registerType(com.brutaldoodle.components.ai.BeamerAIComponent);
			PBE.registerType(com.brutaldoodle.components.ai.ButterflyAIComponent);
			PBE.registerType(com.brutaldoodle.components.ai.WarperAIComponent);
			
			PBE.registerType(com.brutaldoodle.components.controllers.CanonController);
			PBE.registerType(com.brutaldoodle.components.controllers.PlayerController);
			PBE.registerType(com.brutaldoodle.components.controllers.LoadLevelOnKeypress);
			
			PBE.registerType(com.brutaldoodle.components.collisions.BoundingBoxComponent);
			PBE.registerType(com.brutaldoodle.components.collisions.ChangeStateOnDamaged);
			PBE.registerType(com.brutaldoodle.components.collisions.LoadLevelOnCollision);
			PBE.registerType(com.brutaldoodle.components.collisions.DropBloodOnDamaged);
			PBE.registerType(com.brutaldoodle.components.collisions.DisplayTextOnDamaged);
			PBE.registerType(com.brutaldoodle.components.collisions.UpdateHealthDisplayOnDamaged);
			PBE.registerType(com.brutaldoodle.components.collisions.DropCoinOnDeath);
			PBE.registerType(com.brutaldoodle.components.collisions.ChangeLevelOnArrow);
			PBE.registerType(com.brutaldoodle.components.collisions.DisplayTutorialOnDamaged);
			PBE.registerType(com.brutaldoodle.components.collisions.LoadLevelOnDeath);
			PBE.registerType(com.brutaldoodle.components.collisions.FadeInDisplayOnCollision);
			PBE.registerType(com.brutaldoodle.components.controllers.UpdateStatsOnClick);
			PBE.registerType(com.brutaldoodle.components.collisions.DestroyOnAllDead);
			PBE.registerType(com.brutaldoodle.components.controllers.ChangeVolumeOnDrag);
			
			PBE.registerType(com.brutaldoodle.components.animations.ChangeStateOnRaycastWithPlayer);
			PBE.registerType(com.brutaldoodle.components.animations.CircularMotionComponent);
			PBE.registerType(com.brutaldoodle.components.animations.ChangeEnvironmentComponent);
			PBE.registerType(com.brutaldoodle.components.animations.WiggleComponent);
			
			PBE.registerType(com.brutaldoodle.components.basic.HealthComponent);
			PBE.registerType(com.brutaldoodle.components.basic.MoneyComponent);
			PBE.registerType(com.brutaldoodle.components.basic.HeartComponent);
			
			// Tell PushButtonEngine that this is the main class
			PBE.startup(this);
			PBE.addResources(new Resources());
			
			// Resources can only be loaded if they were properly embedded into the main swf file
			PBE.resourceManager.onlyLoadEmbeddedResources = true;
			
			// Default game configs
			Main.resetEverythingAndReloadGame(false);
			
			// Creates the scene on which PBE can draw display objects
			createScene();
			
			// Singletons are initialized : one for collisions mangement, one for particles management
			ParticleManager.instance.initialize(stage.stageWidth, stage.stageHeight);
			CollisionManager.instance.initialize();
			
			// Event handler for pausing the game (must not be handled by the game loop)
			PBE.mainStage.addEventListener(KeyboardEvent.KEY_UP, handleKeys);
			
			// loads the main menu
			LevelManager.instance.load("../assets/Levels/LevelDescription.xml", 0);
		}
		
		/*
		 * A SceneView instance is created with the same dimensions as the stage
		 * This is the scene on which PBE will render all the display objects
		 */
		private function createScene():void {
			var sceneView:SceneView = new SceneView();
			sceneView.width = stage.stageWidth;
			sceneView.height = stage.stageHeight;
			PBE.initializeScene(sceneView, "MainScene");
		}
		
		/*
		* Pauses the game when the "P" key is pressed once
		* Resume the game when it is pressed once again
		* Return to the main menu when the user press escape
		*/
		private function handleKeys(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.P) {
				if (Main.running) {
					PBE.processManager.stop();
					ParticleManager.instance.pause();
					_running = false;
				} else {
					PBE.processManager.start();
					ParticleManager.instance.resume();
					_running = true;
				}
			} else if (event.keyCode == Keyboard.ESCAPE) {
				Main.resetEverythingAndReloadGame(true, true);
			}
		}
		
		/*
		* Reset the game stats to their base defaults
		*
		* @param reload  Reload the main menu and remove all existing display objects
		* @param countdown  Show a countdown while loading the level
		*/
		public static function resetEverythingAndReloadGame(reload:Boolean=true, countdown:Boolean=false):void {
			Main.gameOver = false;
			UpdateStatsOnClick.resetShop();
			MoneyComponent.coins = 0;
			PlayerController.moveSpeed = 10;
			EnemyMobilityComponent.reset();
			CanonController.reloadSpeed = 0.2;
			HeartComponent.life = 3;
			Bullet.damage = 25;
			
			
			if (reload) {
				ParticleManager.instance.removeAllParticles();
				CollisionManager.instance.reset();
				DestroyOnAllDead.reset();
				
				LevelManager.instance.loadLevel(0, true);
			}
			
			if (countdown) var cd:Countdown = new Countdown();
		}
		
		/*
		* Load a specific level while removing all existing display objects
		*
		* @param level  The index of the level that will be loaded
		* @param countdown  Show a countdown while loading the level
		*/
		public static function resetEverythingAndLoadLevel(level:int, countdown:Boolean=false):void {
			ParticleManager.instance.removeAllParticles();
			CollisionManager.instance.reset();
			EnemyMobilityComponent.reset();
			DestroyOnAllDead.reset();
			
			LevelManager.instance.loadLevel(level, true);
			if (countdown) var cd:Countdown = new Countdown();
		}
		
		public static function get running():Boolean { return _running; }
	}
}