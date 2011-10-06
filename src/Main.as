package
{
	import com.brutaldoodle.components.CanonController;
	import com.brutaldoodle.components.EnemyMobilityComponent;
	import com.brutaldoodle.components.TankController;
	import com.brutaldoodle.events.TankEvent;
	import com.pblabs.animation.AnimatorComponent;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.core.LevelEvent;
	import com.pblabs.engine.core.LevelManager;
	import com.pblabs.engine.core.PBGroup;
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
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	[SWF(width="960", height="680", frameRate="30")]
	public class Main extends Sprite
	{
		private const INVADERS_SPACING:int = 10;
		private const INVADERS_PER_ROW:int = 10;
		
		private var _mainMenuElements:PBGroup;
		
		public function Main()
		{
			PBE.registerType(com.pblabs.animation.AnimatorComponent);
			PBE.registerType(com.pblabs.sound.BackgroundMusicComponent);
			PBE.registerType(com.brutaldoodle.components.EnemyMobilityComponent);

			PBE.startup(this);
			PBE.resourceManager.onlyLoadEmbeddedResources = false;
			
			_mainMenuElements = new PBGroup();
			
			createScene();
			createBackground();
			createTank();
			createCanon();
			createMenu();
			
			PBE.mainStage.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function levelLoaded(e:LevelEvent):void {
			var baseX:int = -(stage.stageWidth/2) + 30;
			var baseY:int = -(stage.stageHeight/2) + 35;
			var position:SimpleSpatialComponent;
			
			for(var i:int=0; i<40; ++i){
				position = PBE.nameManager.lookupComponentByName("ennemi"+(i+1), "Spatial") as SimpleSpatialComponent;
				position.x = baseX + (50+INVADERS_SPACING) * (i%INVADERS_PER_ROW);
				position.y = baseY + (50+INVADERS_SPACING) * (Math.floor(i/INVADERS_PER_ROW));
			}			
		}
		
		private function clickHandler(event:MouseEvent):void
		{
			PBE.mainStage.removeEventListener(MouseEvent.CLICK, clickHandler);
			
			_mainMenuElements.destroy();
			
			LevelManager.instance.load("../assets/Levels/LevelDescription.xml", 1);
			LevelManager.instance.addEventListener(LevelEvent.LEVEL_LOADED_EVENT, levelLoaded);
			
			/*
			var results:Array = new Array();
			var worldPoint:Point = PBE.scene.transformScreenToWorld(new Point(event.stageX, event.stageY));
			PBE.spatialManager.getObjectsUnderPoint(worldPoint, results);
			
			for (var i:int=0; i < results.length; ++i) {
				Logger.print(this, (results[i] as SimpleSpatialComponent).owner.name);
			}
			*/
		}
				
		private function createScene():void {
			var sceneView:SceneView = new SceneView();
			sceneView.width = stage.stageWidth;
			sceneView.height = stage.stageHeight;
			PBE.initializeScene(sceneView, "MainScene");
		}
		
		private function createBackground():void {
			var background:IEntity = PBE.allocateEntity();
			
			var spatial:SimpleSpatialComponent = new SimpleSpatialComponent();
			spatial.position = new Point(0,0);
			
			background.addComponent(spatial, "Spatial");
			
			var renderer:SpriteRenderer = new SpriteRenderer();
			renderer.fileName = "../assets/Images/background_menu.jpg";
			renderer.positionProperty = new PropertyReference("@Spatial.position");
			renderer.layerIndex = 1;
			renderer.scene = PBE.scene;
			
			background.addComponent(renderer, "Renderer");
			
			background.owningGroup = _mainMenuElements;
			background.initialize("MenuBackground");
		}
		
		private function createTank():void {
			var hero:IEntity = PBE.allocateEntity();
			
			// spatial component
			var spatial:SimpleSpatialComponent = new SimpleSpatialComponent();
			spatial.position = new Point(0, 240);
			spatial.size = new Point(100, 55);
			spatial.spatialManager = PBE.spatialManager;
			
			hero.addComponent(spatial, "Spatial");
			
			// keyboard input
			var input:TankController = new TankController();
			input.positionProperty = new PropertyReference("@Spatial.position");
			input.sizeProperty = new PropertyReference("@Spatial.size");
			
			hero.addComponent(input, "Input");
			
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
			
			
			hero.initialize("Tank");
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
			renderer.positionProperty = new PropertyReference("#Tank.Spatial.position");
			renderer.positionOffset = new Point(0, -18);
			
			canon.addComponent(renderer, "Render");
			
			// keyboard input
			var input:CanonController = new CanonController();
			input.canonOffset = new PropertyReference("@Render.positionOffset");
			input.positionProperty = new PropertyReference("@Render.position");
			
			canon.addComponent(input, "Input");
			
			
			canon.initialize("Canon");
		}
		
		private function createMenu():void {
			for (var i:int=0; i < 4; i++)
				createMenuElement("../assets/Images/Button"+ i +".png", i, 220, 105, 30, 20);
		}
		
		private function createMenuElement(pFilePath:String, elementIndex:int, width:int, height:int, horizontalSpacing:int, verticalSpacing:int):void {
			var element:IEntity = PBE.allocateEntity();
			
			// spatial component
			var spatial	:SimpleSpatialComponent = new SimpleSpatialComponent();
			spatial.size = new Point(width, height);
			spatial.position = new Point(-480+width/2+width*elementIndex+horizontalSpacing*elementIndex, -340+height/2+verticalSpacing);
			
			element.addComponent(spatial, "Spatial");
			
			// spritesheet
			var divider:CellCountDivider = new CellCountDivider();
			divider.xCount = 2;
			divider.yCount = 1;
			
			var elementSpriteSheet:SpriteSheetComponent = new SpriteSheetComponent();
			elementSpriteSheet.imageFilename = pFilePath;
			elementSpriteSheet.divider = divider;
			
			//rendering
			var renderer:SpriteSheetRenderer = new SpriteSheetRenderer();
			renderer.positionProperty = new PropertyReference("@Spatial.position");
			renderer.spriteSheet = elementSpriteSheet;
			renderer.spriteIndex = 0;
			renderer.layerIndex = 10;
			renderer.scene = PBE.scene;
			
			element.addComponent(renderer, "Renderer");
			
			//controller
			var animator:AnimationController = new AnimationController();
			animator.spriteSheetReference = new PropertyReference("@Renderer.spriteSheet");
			animator.currentFrameReference = new PropertyReference("@Renderer.spriteIndex");
			animator.defaultAnimation = "Normal";
			
			// Button's normal state display
			var normalState:AnimationControllerInfo = new AnimationControllerInfo;
			normalState.frameRate = 0;
			normalState.loop = false;
			normalState.spriteSheet = elementSpriteSheet;
			animator.animations["Normal"] = normalState;
			
			// Button's hover state display
			var hoverState:AnimationControllerInfo = new AnimationControllerInfo;
			hoverState.maxFrameDelay = 1000;
			hoverState.frameRate = 5;
			hoverState.loop = true;
			hoverState.spriteSheet = elementSpriteSheet;
			animator.animations["Hover"] = hoverState;
			
			element.addComponent(animator, "Animator");
			
			
			element.owningGroup = _mainMenuElements;
			element.initialize("MenuButton" + elementIndex);
		}
	}
}