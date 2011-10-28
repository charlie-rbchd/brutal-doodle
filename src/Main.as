package
{
	import com.brutaldoodle.collisions.CollisionManager;
	import com.brutaldoodle.collisions.CollisionType;
	import com.brutaldoodle.components.BoundingBoxComponent;
	import com.brutaldoodle.components.CanonController;
	import com.brutaldoodle.components.ChangeStateOnDamaged;
	import com.brutaldoodle.components.EnemyMobilityComponent;
	import com.brutaldoodle.components.PlayerController;
	import com.brutaldoodle.events.TankEvent;
	import com.pblabs.animation.AnimatorComponent;
	import com.pblabs.components.basic.HealthComponent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.core.LevelEvent;
	import com.pblabs.engine.core.LevelManager;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.AnimationController;
	import com.pblabs.rendering2D.AnimationControllerInfo;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	import com.pblabs.rendering2D.SpriteRenderer;
	import com.pblabs.rendering2D.SpriteSheetRenderer;
	import com.pblabs.rendering2D.spritesheet.CellCountDivider;
	import com.pblabs.rendering2D.spritesheet.SpriteSheetComponent;
	import com.pblabs.rendering2D.ui.SceneView;
	import com.pblabs.sound.BackgroundMusicComponent;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[SWF(width="960", height="680", frameRate="30")]
	public class Main extends Sprite
	{
		private const NUM_MENU_ELEMENTS:int = 4;
		private const PATH_MENU_ELEMENTS:String = "../assets/Images/Button";
		
		private const INVADERS_SPACING:int = 10;
		private const INVADERS_PER_ROW:int = 10;
		
		public function Main()
		{
			PBE.registerType(com.pblabs.animation.AnimatorComponent);
			PBE.registerType(com.pblabs.sound.BackgroundMusicComponent);
			PBE.registerType(com.brutaldoodle.components.EnemyMobilityComponent);
			PBE.registerType(com.brutaldoodle.components.BoundingBoxComponent);
			PBE.registerType(com.brutaldoodle.components.ChangeStateOnDamaged);
			PBE.registerType(com.brutaldoodle.components.LoadLevelOnCollision);
			
			PBE.startup(this);
			PBE.resourceManager.onlyLoadEmbeddedResources = false;
			
			CollisionManager.instance.initialize();
			
			createScene();
			createTank();
			createCanon();
			
			LevelManager.instance.load("../assets/Levels/LevelDescription.xml", 0);
			LevelManager.instance.addEventListener(LevelEvent.LEVEL_LOADED_EVENT, mainMenuLoaded);
		}
		
		private function mainMenuLoaded(event:LevelEvent):void
		{
			LevelManager.instance.removeEventListener(LevelEvent.LEVEL_LOADED_EVENT, mainMenuLoaded);
			//TO MODIFY
			var numButtons:int = (PBE.nameManager.lookup("Button1") as IEntity).owningGroup.length,
				boundingBox:BoundingBoxComponent;
			
			for (var i:int = 0; i < numButtons; ++i) {
				boundingBox = PBE.nameManager.lookupComponentByName("Button"+(i+1), "Collisions") as BoundingBoxComponent;
				CollisionManager.instance.registerForCollisions(boundingBox, CollisionType.ENEMY);
			}
			
			LevelManager.instance.addEventListener(LevelEvent.LEVEL_LOADED_EVENT, levelLoaded);
		}
		
		private function levelLoaded(event:LevelEvent):void {
			var numEnemies:int = (PBE.nameManager.lookup("Enemy1") as IEntity).owningGroup.length,
				boundingBox:BoundingBoxComponent;
			
			for (var i:int = 0; i < numEnemies; ++i) {
				boundingBox = PBE.nameManager.lookupComponentByName("Enemy"+(i+1), "Collisions") as BoundingBoxComponent;
				
				//A CHANGER DE PLACE
				CollisionManager.instance.registerForCollisions(boundingBox, CollisionType.ENEMY);
			}
		}
				
		private function createScene():void {
			var sceneView:SceneView = new SceneView();
			sceneView.width = stage.stageWidth;
			sceneView.height = stage.stageHeight;
			PBE.initializeScene(sceneView, "MainScene");
		}
		
		private function createTank():void {
			var hero:IEntity = PBE.allocateEntity();
			
			// spatial component
			var spatial:SimpleSpatialComponent = new SimpleSpatialComponent();
			spatial.position = new Point(0, 240);
			spatial.size = new Point(100, 55);
			spatial.spatialManager = PBE.spatialManager;
			
			hero.addComponent(spatial, "Spatial");
			
			// spritesheet dividers
			var normalDivider:CellCountDivider = new CellCountDivider();
			var alternateDivider:CellCountDivider = new CellCountDivider();
			alternateDivider.xCount = normalDivider.xCount = 8;
			
			// spritesheets
			var normalSpriteSheet:SpriteSheetComponent = new SpriteSheetComponent();
			normalSpriteSheet.imageFilename = "../assets/Images/TankNormal.png";
			normalSpriteSheet.divider = normalDivider;
			
			var alternateSpriteSheet:SpriteSheetComponent = new SpriteSheetComponent();
			alternateSpriteSheet.imageFilename = "../assets/Images/TankAlternate.png";
			alternateSpriteSheet.divider = alternateDivider;
			
			// spritesheet renderer
			var renderer:SpriteSheetRenderer = new SpriteSheetRenderer();
			renderer.positionProperty = new PropertyReference("@Spatial.position");
			renderer.spriteSheet = normalSpriteSheet;
			renderer.spriteIndex = 0;
			renderer.layerIndex = 6;
			renderer.scene = PBE.scene;
			
			hero.addComponent(renderer, "Render");
			
			// spritesheet animator
			var animator:AnimationController = new AnimationController();
			animator.spriteSheetReference = new PropertyReference("@Render.spriteSheet");
			animator.currentFrameReference = new PropertyReference("@Render.spriteIndex");
			animator.changeAnimationEvent = TankEvent.UPDATE_ANIMATION;
			animator.currentAnimationReference = new PropertyReference("@Input.currentAnimation");
			animator.defaultAnimation = "Idle_Normal";
			
			// idle animations
			var idleAnimation_Normal:AnimationControllerInfo = new AnimationControllerInfo();
			var idleAnimation_Alternate:AnimationControllerInfo = new AnimationControllerInfo();
			idleAnimation_Normal.frameRate = idleAnimation_Alternate.frameRate = 0;
			idleAnimation_Normal.loop = idleAnimation_Alternate.loop = false;
			idleAnimation_Normal.spriteSheet = normalSpriteSheet;
			idleAnimation_Alternate.spriteSheet = alternateSpriteSheet;
			
			animator.animations["Idle_Normal"] = idleAnimation_Normal;
			animator.animations["Idle_Alternate"] = idleAnimation_Alternate;
			
			// movement animations
			var moveAnimation_Normal:AnimationControllerInfo = new AnimationControllerInfo();
			var moveAnimation_Alternate:AnimationControllerInfo = new AnimationControllerInfo();
			moveAnimation_Normal.loop = moveAnimation_Alternate.loop = true;
			moveAnimation_Normal.frameRate = moveAnimation_Alternate.frameRate = 8;
			moveAnimation_Normal.spriteSheet = normalSpriteSheet;
			moveAnimation_Alternate.spriteSheet = alternateSpriteSheet;
			
			animator.animations["Move_Normal"] = moveAnimation_Normal;
			animator.animations["Move_Alternate"] = moveAnimation_Alternate;
			
			hero.addComponent(animator, "Animator");
			
			// collisions
			var boundingBox:BoundingBoxComponent = new BoundingBoxComponent();
			boundingBox.zone = new Rectangle(
				spatial.position.x - spatial.size.x/2,
				spatial.position.y,
				spatial.size.x,
				spatial.size.y + spatial.size.y/2
			);
			
			CollisionManager.instance.registerForCollisions(boundingBox, CollisionType.PLAYER);
			hero.addComponent(boundingBox, "Collisions");
			
			// health
			var health:HealthComponent = new HealthComponent();
			hero.addComponent(health, "Health");
			
			// keyboard input
			var input:PlayerController = new PlayerController();
			input.positionProperty = new PropertyReference("@Spatial.position");
			input.sizeProperty = new PropertyReference("@Spatial.size");
			input.boundingBoxProperty = new PropertyReference("@Collisions.zone");
			
			hero.addComponent(input, "Input");
			
			
			hero.initialize("Player");
		}
		
		private function createCanon():void {
			var canon:IEntity = PBE.allocateEntity();
			
			// spatial component
			var spatial:SimpleSpatialComponent = new SimpleSpatialComponent();
			spatial.size = new Point(8, 26);
			
			canon.addComponent(spatial, "Spatial");
			
			// sprite renderer
			var renderer:SpriteRenderer = new SpriteRenderer();
			renderer.fileName = "../assets/Images/Canon.png";
			renderer.layerIndex = 5;
			renderer.positionProperty = new PropertyReference("#Player.Spatial.position");
			renderer.positionOffset = new Point(0, -18);
			
			canon.addComponent(renderer, "Render");
			
			// keyboard input
			var input:CanonController = new CanonController();
			input.canonOffset = new PropertyReference("@Render.positionOffset");
			input.positionProperty = new PropertyReference("@Render.position");
			
			canon.addComponent(input, "Input");
			
			
			canon.initialize("Canon");
		}
	}
}