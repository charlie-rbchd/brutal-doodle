package
{
	import com.brutaldoodle.collisions.CollisionManager;
	import com.brutaldoodle.components.ai.EnemyMobilityComponent;
	import com.brutaldoodle.components.ai.NormalShotAI;
	import com.brutaldoodle.components.animations.ChangeStateOnRaycastWithPlayer;
	import com.brutaldoodle.components.basic.HealthComponent;
	import com.brutaldoodle.components.collisions.BoundingBoxComponent;
	import com.brutaldoodle.components.collisions.ChangeLevelOnArrow;
	import com.brutaldoodle.components.collisions.ChangeStateOnDamaged;
	import com.brutaldoodle.components.collisions.DisplayTutorialOnDamaged;
	import com.brutaldoodle.components.collisions.DropBloodOnDamaged;
	import com.brutaldoodle.components.collisions.DropCoinOnDeath;
	import com.brutaldoodle.components.collisions.UpdateHealthDisplayOnDamaged;
	import com.brutaldoodle.components.controllers.CanonController;
	import com.brutaldoodle.components.controllers.LoadLevelOnKeypress;
	import com.brutaldoodle.components.controllers.PlayerController;
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
	
	[SWF(width="960", height="680", frameRate="30", backgroundColor="0x000000")]
	public class Main extends Sprite
	{
		public function Main()
		{
			// these types need to be registered in order to use them in pbelevel files
			PBE.registerType(com.pblabs.engine.components.GroupManagerComponent);
			PBE.registerType(com.pblabs.animation.AnimatorComponent);
			PBE.registerType(com.pblabs.sound.BackgroundMusicComponent);
			PBE.registerType(com.pblabs.rendering2D.SpriteSheetRenderer);
			PBE.registerType(com.pblabs.rendering2D.AnimationController);
			PBE.registerType(com.pblabs.rendering2D.AnimationControllerInfo);
			PBE.registerType(com.pblabs.rendering2D.spritesheet.CellCountDivider);
			PBE.registerType(com.pblabs.rendering2D.ui.PBLabel);
			
			PBE.registerType(com.brutaldoodle.components.ai.NormalShotAI);
			PBE.registerType(com.brutaldoodle.components.ai.EnemyMobilityComponent);
			PBE.registerType(com.brutaldoodle.components.controllers.CanonController);
			PBE.registerType(com.brutaldoodle.components.controllers.PlayerController);
			PBE.registerType(com.brutaldoodle.components.collisions.BoundingBoxComponent);
			PBE.registerType(com.brutaldoodle.components.collisions.ChangeStateOnDamaged);
			PBE.registerType(com.brutaldoodle.components.collisions.LoadLevelOnCollision);
			PBE.registerType(com.brutaldoodle.components.collisions.DropBloodOnDamaged);
			PBE.registerType(com.brutaldoodle.components.collisions.DisplayTextOnDamaged);
			PBE.registerType(com.brutaldoodle.components.collisions.UpdateHealthDisplayOnDamaged);
			PBE.registerType(com.brutaldoodle.components.collisions.DropCoinOnDeath);
			PBE.registerType(com.brutaldoodle.components.collisions.RemoveHeartOnDeath);
			PBE.registerType(com.brutaldoodle.components.collisions.ChangeLevelOnArrow);
			PBE.registerType(com.brutaldoodle.components.collisions.DisplayTutorialOnDamaged);
			PBE.registerType(com.brutaldoodle.components.collisions.LoadLevelOnDeath);
			PBE.registerType(com.brutaldoodle.components.animations.ChangeStateOnRaycastWithPlayer);
			PBE.registerType(com.brutaldoodle.components.basic.HealthComponent);
			PBE.registerType(com.brutaldoodle.components.controllers.LoadLevelOnKeypress);
			
			// start the factory!
			PBE.startup(this);
			
			// resources are collected directly from the files instead of being embedded in the .swf
			PBE.resourceManager.onlyLoadEmbeddedResources = false;
			
			// creates the scene on which PBE can draw display objects
			createScene();
			
			// singletons are initialized : one for collisions mangement, one for particles management
			ParticleManager.instance.initialize(stage.stageWidth, stage.stageHeight);
			CollisionManager.instance.initialize();
			
			// loads the main menu
			LevelManager.instance.load("../assets/Levels/LevelDescription.xml", 3);
		}
		
		// A SceneView instance is created with the same dimensions as the stage
		private function createScene():void {
			var sceneView:SceneView = new SceneView();
			sceneView.width = stage.stageWidth;
			sceneView.height = stage.stageHeight;
			PBE.initializeScene(sceneView, "MainScene");
		}
	}
}