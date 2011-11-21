package com.brutaldoodle.components.basic
{
	import com.pblabs.engine.entity.EntityComponent;
	import com.pblabs.engine.entity.PropertyReference;
	
	import flash.text.TextField;
	
	public class MoneyComponent extends EntityComponent
	{
		public static var coins:int;
		public var textProperty:PropertyReference;
		
		public function MoneyComponent()
		{
			super();
		}
		
		override protected function onAdd():void
		{
			super.onAdd();
			updateText();
		}
		
		public function addCoins (amount:int):void {
			MoneyComponent.coins += amount;
			updateText();
		}
		
		public function removeCoins (amount:int):void {
			MoneyComponent.coins -= amount;
			updateText();
		}
		
		private function updateText ():void {
			var coins:TextField = owner.getProperty(textProperty);
			coins.text = String(MoneyComponent.coins);
			owner.setProperty(textProperty, coins);
		}
	}
}