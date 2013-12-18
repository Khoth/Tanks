package screens
{
	import elements.mobile.Tank;
	import fields.GameField;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import mx.containers.Canvas;
	import enums.Direction;
	
	public class Game extends Canvas
	{
		private var field:GameField;
		private var remainedEnemies:int = 16;
		
		private var gameStartSound:Sound = new Sound(new URLRequest("sound/start.mp3"));
		
		public function init():void
		{
			var level1:Array = new Array();
			level1.push([1, 1, 31]);
			level1.push([1, 2, 31]);
			level1.push([1, 3, 31]);
			level1.push([1, 4, 31]);
			level1.push([3, 1, 31]);
			level1.push([3, 2, 31]);
			level1.push([3, 3, 31]);
			level1.push([3, 4, 31]);
			level1.push([9, 1, 31]);
			level1.push([9, 2, 31]);
			level1.push([9, 3, 31]);
			level1.push([9, 4, 31]);
			level1.push([11, 1, 31]);
			level1.push([11, 2, 31]);
			level1.push([11, 3, 31]);
			level1.push([11, 4, 31]);
			level1.push([5, 1, 31]);
			level1.push([5, 2, 31]);
			level1.push([5, 3, 31]);
			level1.push([5, 4, 19]);
			level1.push([7, 1, 31]);
			level1.push([7, 2, 31]);
			level1.push([7, 3, 31]);
			level1.push([7, 4, 19]);
			level1.push([6, 3, 47]);
			level1.push([5, 11, 31]);
			level1.push([7, 11, 31]);
			level1.push([5, 10, 31]);
			level1.push([6, 10, 31]);
			level1.push([7, 10, 31]);
			level1.push([1, 8, 31]);
			level1.push([1, 9, 31]);
			level1.push([1, 10, 31]);
			level1.push([3, 8, 31]);
			level1.push([3, 9, 19]);
			level1.push([11, 8, 31]);
			level1.push([11, 9, 31]);
			level1.push([11, 10, 31]);
			level1.push([9, 8, 31]);
			level1.push([9, 9, 19]);
			level1.push([0, 6, 44]);
			level1.push([12, 6, 44]);
			level1.push([5, 8, 31]);
			level1.push([7, 8, 31]);
			level1.push([5, 5, 28]);
			level1.push([5, 6, 19]);
			level1.push([7, 5, 28]);
			level1.push([7, 6, 19]);
			level1.push([2, 6, 31]);
			level1.push([3, 6, 31]);
			level1.push([9, 6, 31]);
			level1.push([10, 6, 31]);
			level1.push([5, 7, 28]);
			level1.push([7, 7, 28]);
			level1.push([6, 8, 19]);
			
			this.width = 640;
			this.height = 480;
			this.x = 0;
			this.y = 0;
			this.autoLayout = false;
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";
			this.setStyle("backgroundColor", "0x71857F");
			
			this.field = new GameField(level1);
			this.field.init();
			spawnEnemies();
			this.addChild(this.field);
			
			gameStartSound.play(0, 1, null);
		}
		
		private function spawnEnemies():void
		{
			field.addTank(new Tank(36, 36, Direction.Bottom));
			field.addTank(new Tank(252, 36, Direction.Bottom));
			field.addTank(new Tank(468, 36, Direction.Bottom));
		}
	}
}