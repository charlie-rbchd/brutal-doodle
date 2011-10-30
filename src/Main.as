package
{
	import com.brutaldoodle.collisions.CollisionManager;
	import com.brutaldoodle.components.BoundingBoxComponent;
	import com.brutaldoodle.components.CanonController;
	import com.brutaldoodle.components.ChangeStateOnDamaged;
	import com.brutaldoodle.components.DropBloodOnBeingHit;
	import com.brutaldoodle.components.EnemyMobilityComponent;
	import com.brutaldoodle.components.PlayerController;
	import com.brutaldoodle.components.ai.NormalShotAI;
	import com.pblabs.animation.AnimatorComponent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.core.LevelManager;
	import com.pblabs.rendering2D.AnimationController;
	import com.pblabs.rendering2D.AnimationControllerInfo;
	import com.pblabs.rendering2D.SpriteSheetRenderer;
	import com.pblabs.rendering2D.spritesheet.CellCountDivider;
	import com.pblabs.rendering2D.ui.SceneView;
	import com.pblabs.sound.BackgroundMusicComponent;
	
	import flash.display.Sprite;
	
	[SWF(width="960", height="680", frameRate="30")]
	public class Main extends Sprite
	{
		public function Main()
		{
			// these types need to be registered in order to use them in pbelevel files
			PBE.registerType(com.pblabs.animation.AnimatorComponent);
			PBE.registerType(com.pblabs.sound.BackgroundMusicComponent);
			PBE.registerType(com.pblabs.rendering2D.SpriteSheetRenderer);
			PBE.registerType(com.pblabs.rendering2D.AnimationController);
			PBE.registerType(com.pblabs.rendering2D.AnimationControllerInfo);
			PBE.registerType(com.pblabs.rendering2D.spritesheet.CellCountDivider);
			
			PBE.registerType(com.brutaldoodle.components.ai.NormalShotAI);
			PBE.registerType(com.brutaldoodle.components.CanonController);
			PBE.registerType(com.brutaldoodle.components.PlayerController);
			PBE.registerType(com.brutaldoodle.components.BoundingBoxComponent);
			PBE.registerType(com.brutaldoodle.components.ChangeStateOnDamaged);
			PBE.registerType(com.brutaldoodle.components.LoadLevelOnCollision);
			PBE.registerType(com.brutaldoodle.components.EnemyMobilityComponent);
			PBE.registerType(com.brutaldoodle.components.DropBloodOnBeingHit);
			
			// start the factory!
			PBE.startup(this);
			
			// resources are collected directly from the files instead of being embedded in the .swf
			PBE.resourceManager.onlyLoadEmbeddedResources = false;
			
			// empty vectors are created to hold the many hitboxes it will contain later on
			CollisionManager.instance.initialize();
			
			// creates the scene on which PBE can draw display objects
			createScene();
			
			// loads the main menu
			LevelManager.instance.load("../assets/Levels/LevelDescription.xml", 0);
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