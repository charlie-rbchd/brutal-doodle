package com.brutaldoodle.components.collisions
{
	import com.brutaldoodle.components.ai.EnemyMobilityComponent;
	import com.brutaldoodle.components.basic.HeartComponent;
	import com.brutaldoodle.components.basic.MoneyComponent;
	import com.brutaldoodle.components.controllers.CanonController;
	import com.brutaldoodle.components.controllers.PlayerController;
	import com.brutaldoodle.effects.Bullet;
	import com.brutaldoodle.entities.Dialog;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.components.TickedComponent;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.PropertyReference;
	import com.pblabs.rendering2D.SpriteSheetRenderer;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.Dictionary;
	
	public class UpdateStatsOnClick extends TickedComponent
	{	
		private static var _statsStatus:Dictionary = new Dictionary();
		private static var _money:MoneyComponent;
		private static const UPGRADE_COSTS:Array = new Array(100, 150, 200, 250, 300, 400, 500, 750, 999);
		private static const MAX_UPGRADE_COUNT:int = 8;
		
		public var upgradedStat:String;
		public var numberIndexProperty:PropertyReference;
		private var _displayObject:Sprite;
		private var _renderer:SpriteSheetRenderer;
		
		public function UpdateStatsOnClick() {
			super();
			if (_money == null) {
				_money = PBE.lookupComponentByName("AmountOfCoins", "Money") as MoneyComponent;
			}
		}
		
		override protected function onAdd():void {
			super.onAdd();
			if (!_statsStatus[upgradedStat]) _statsStatus[upgradedStat] = 0;
			_renderer = owner.lookupComponentByName("Render") as SpriteSheetRenderer;
		}
		
		override protected function onRemove():void {
			super.onRemove();
			with (_displayObject) {
				removeEventListener(MouseEvent.CLICK, updateStats);
				removeEventListener(MouseEvent.MOUSE_OVER, onHover);
				removeEventListener(MouseEvent.MOUSE_OUT, onHover);
			}
		}
		
		override public function onTick(deltaTime:Number):void {
			super.onTick(deltaTime);
			if (_renderer.bitmapData != null) {
				_displayObject = _renderer.displayObject as Sprite;
				with (_displayObject) {
					mouseEnabled = true;
					addEventListener(MouseEvent.CLICK, updateStats);
					addEventListener(MouseEvent.MOUSE_OVER, onHover);
					addEventListener(MouseEvent.MOUSE_OUT, onHover);
				}
				this.registerForTicks = false;
			}
		}
		
		private function updateStats (event:MouseEvent):void {
			var cost:int = UPGRADE_COSTS[_statsStatus[upgradedStat]];
			if (MoneyComponent.coins - cost < 0) {
				var dialog:Dialog = new Dialog("../assets/Images/NotEnoughMoney.png", new Point(118, 155), new Point(360, 110));
				return;
			}
			
			switch (upgradedStat) {
				case "speed":
					PlayerController.moveSpeed += 1; // 18 move speed at max level
					break;
				case "damage":
					Bullet.damage += 6.25; // 75 damage at max level
					break;
				case "life":
					HeartComponent.addHeart(); // 9-12 life at max level
					break;
				case "firerate":
					CanonController.reloadSpeed -= 0.01; // 0.1 reload speed at max level
					break;
				default:
					throw new Error();
			}
			
			if (_statsStatus[upgradedStat] >= MAX_UPGRADE_COUNT) {
				_displayObject.mouseEnabled = false;
			}
			
			_statsStatus[upgradedStat] += 1;
			_renderer.spriteIndex = _statsStatus[upgradedStat];
			owner.setProperty(numberIndexProperty, _statsStatus[upgradedStat]);
			_money.removeCoins(cost);
		}
		
		private function onHover (event:MouseEvent):void {
			switch (event.type) {
				case MouseEvent.MOUSE_OVER:
					Mouse.cursor = MouseCursor.BUTTON;
					break;
				case MouseEvent.MOUSE_OUT:
					Mouse.cursor = MouseCursor.AUTO;
					break;
				default:
					throw new Error();
			}
		}
	}
}