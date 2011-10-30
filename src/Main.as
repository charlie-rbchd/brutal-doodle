package
{
	import com.brutaldoodle.collisions.CollisionManager;
	import com.brutaldoodle.components.BoundingBoxComponent;
	import com.brutaldoodle.components.CanonController;
	import com.brutaldoodle.components.ChangeStateOnDamaged;
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
			PBE.registerType(com.pblabs.animation.AnimatorComponent);
			PBE.registerType(com.pblabs.sound.BackgroundMusicComponent);
			PBE.registerType(com.pblabs.rendering2D.SpriteSheetRenderer);
			PBE.registerType(com.pblabs.rendering2D.AnimationController);
			PBE.registerType(com.pblabs.rendering2D.AnimationControllerInfo);
			PBE.registerType(com.pblabs.rendering2D.spritesheet.CellCountDivider);
			
			PBE.registerType(com.brutaldoodle.components.CanonController);
			PBE.registerType(com.brutaldoodle.components.PlayerController);
			PBE.registerType(com.brutaldoodle.components.EnemyMobilityComponent);
			PBE.registerType(com.brutaldoodle.components.BoundingBoxComponent);
			PBE.registerType(com.brutaldoodle.components.ChangeStateOnDamaged);
			PBE.registerType(com.brutaldoodle.components.LoadLevelOnCollision);
			PBE.registerType(com.brutaldoodle.components.ai.NormalShotAI);
			
			PBE.startup(this);
			PBE.resourceManager.onlyLoadEmbeddedResources = false;
			
			CollisionManager.instance.initialize();
			
			createScene();
			
			LevelManager.instance.load("../assets/Levels/LevelDescription.xml", 0);
		}
				
		private function createScene():void {
			var sceneView:SceneView = new SceneView();
			sceneView.width = stage.stageWidth;
			sceneView.height = stage.stageHeight;
			PBE.initializeScene(sceneView, "MainScene");
		}
	}
}