package com.brutaldoodle.entities
{
	import com.brutaldoodle.components.controllers.CanonController;
	import com.pblabs.animation.AnimationEvent;
	import com.pblabs.animation.Animator;
	import com.pblabs.animation.AnimatorComponent;
	import com.pblabs.animation.AnimatorType;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.IEntity;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.SimpleSpatialComponent;
	import com.pblabs.rendering2D.SpriteRenderer;
	import com.pblabs.rendering2D.SpriteSheetRenderer;
	import com.pblabs.rendering2D.spritesheet.CellCountDivider;
	import com.pblabs.rendering2D.spritesheet.SpriteSheetComponent;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class Countdown
	{
		private var __this:IEntity;
		private var _countAnimation:Animator;
		
		public function Countdown()
		{
			__this = PBE.allocateEntity();
			
			var spatial:SimpleSpatialComponent = new SimpleSpatialComponent();
			spatial.position = new Point(0, 0);
			spatial.size = new Point(273, 398);
			spatial.spatialManager = PBE.spatialManager;
			__this.addComponent(spatial, "Spatial");
			
			
			var divider:CellCountDivider = new CellCountDivider();
			divider.xCount = 3;
			divider.yCount = 1;
			
			var spriteSheet:SpriteSheetComponent = new SpriteSheetComponent();
			spriteSheet.divider = divider;
			spriteSheet.imageFilename = "../assets/Images/Countdown.png";
			
			var renderer:SpriteSheetRenderer = new SpriteSheetRenderer();
			renderer.scene = PBE.scene;
			renderer.layerIndex = 10;
			renderer.positionProperty = new PropertyReference("@Spatial.position");
			renderer.sizeProperty = new PropertyReference("@Spatial.size");
			renderer.spriteSheet = spriteSheet;
			renderer.spriteIndex = 0;
			__this.addComponent(renderer, "Render");
			
			
			var _countAnimation:Animator = new Animator();
			_countAnimation.animationType = AnimatorType.PLAY_ANIMATION_ONCE;
			_countAnimation.duration = 3;
			_countAnimation.repeatCount = 0;
			_countAnimation.startValue = 0;
			_countAnimation.targetValue = 3;
			
			var animator:AnimatorComponent = new AnimatorComponent();
			animator.animations = new Dictionary();
			animator.animations["counting"] = _countAnimation;
			animator.defaultAnimation = "counting";
			animator.reference = new PropertyReference("@Render.spriteIndex");
			__this.addComponent(animator, "Animation");
			
			
			__this.initialize("Countdown");
			
			
			CanonController.shootPermission = false;
			_countAnimation.addEventListener(AnimationEvent.ANIMATION_FINISHED_EVENT, onCountComplete);
		}
		
		private function onCountComplete (event:AnimationEvent):void {
			PBE.processManager.schedule(50, this, function ():void {
				CanonController.shootPermission = true;
				__this.destroy();
			});
		}
	}
}