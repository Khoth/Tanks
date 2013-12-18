package fields
{
	import elements.fixed.Tile;
	import elements.mobile.Bullet;
	import elements.mobile.Tank;
	import enums.Direction;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import mx.containers.Canvas;
	
	public class GameField extends Canvas
	{
		public const _width:int = 13;
		public const _height:int = 12;
		public var tanks:Vector.<Tank> = new Vector.<Tank>();
		private var bullets:Vector.<Bullet> = new Vector.<Bullet>();
		public var tiles:Array = new Array();
		
		public function GameField(tiles:Array):void
		{
			for (var i:int = 0; i < _width; i++)
				this.tiles[i] = new Vector.<Tile>(_height);
			
			for each (var tile:Array in tiles)
			{
				if (tile.length == 3)
				{
					var x:int = tile[0];
					var y:int = tile[1];
					var number:int = tile[2];
					if (x >= 0 && x < this._width && y >= 0 && y < this._height)
						this.tiles[x][y] = new Tile(number);
						trace("123");
				}
			}
		}
		
		public function init():void
		{
			this.width = 468;
			this.height = 432;
			this.x = 24;
			this.y = 24;
			this.autoLayout = false;
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";
			this.setStyle("backgroundColor", "0x000000");
			// пустые слои для z-index
			this.addChild(new Canvas());
			this.addChild(new Canvas());
			this.addChild(new Canvas());
			
			//----------- удалить тестовые даннные ---------------//			
			// тестовый танк
			addTank(new Tank(108, 396, Direction.Top));
			//addTank(new Tank(335, 296));
			//----------------------------------------------------//
			initObjects();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage); // TODO исправить потерю stage!!!!
			addEventListener(Event.ENTER_FRAME, moveObjects);
			this.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			this.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		}
		
		// здесь будет вызываться Move пуль и врагов
		private function moveObjects(e:Event):void
		{
			// захват фокуса для управления клавиатурой
			if (stage.focus != this)
				stage.focus = this;
			
			// пули летят
			for each (var bullet:Bullet in this.bullets)
			{
				bullet.moveForward();
			}
			
			// танк едет
			if (tankIsMoving)
				this.tanks[0].moveForward();
			
			// танк стреляет
			if (tankIsShoting)
				this.tanks[0].shoot();
		}
		
		private var tankIsMoving:Boolean = false;
		private var tankIsShoting:Boolean = false;
		private var pressedMovingControlKeys:Vector.<int> = new Vector.<int>(); // массив нажатых клавиш управления танком
		
		private function addedToStage(event:Event):void
		{
			stage.focus = this;
		}
		
		private function keyUp(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case 32: 
					if (tankIsShoting)
						tankIsShoting = false;
					break;
				case 37: 
					this.pressedMovingControlKeys.splice(this.pressedMovingControlKeys.indexOf(37), 1);
					break;
				case 38: 
					this.pressedMovingControlKeys.splice(this.pressedMovingControlKeys.indexOf(38), 1);
					break;
				case 39: 
					this.pressedMovingControlKeys.splice(this.pressedMovingControlKeys.indexOf(39), 1);
					break;
				case 40: 
					this.pressedMovingControlKeys.splice(this.pressedMovingControlKeys.indexOf(40), 1);
					break;
			}
			if (this.pressedMovingControlKeys.length == 0)
				tankIsMoving = false;
		}
		
		private function keyDown(e:KeyboardEvent):void
		{
			if (!tankIsMoving || this.pressedMovingControlKeys.indexOf(e.keyCode) == -1)
			{
				switch (e.keyCode)
				{
					case 37: 
						this.pressedMovingControlKeys.push(37);
						this.tanks[0].setDirection(Direction.Left);
						tankIsMoving = true;
						break;
					case 38: 
						this.pressedMovingControlKeys.push(38);
						this.tanks[0].setDirection(Direction.Top);
						tankIsMoving = true;
						break;
					case 39: 
						this.pressedMovingControlKeys.push(39);
						this.tanks[0].setDirection(Direction.Right);
						tankIsMoving = true;
						break;
					case 40: 
						this.pressedMovingControlKeys.push(40);
						this.tanks[0].setDirection(Direction.Bottom);
						tankIsMoving = true;
						break;
				}
			}
			if (e.keyCode == 32)
				tankIsShoting = true;
		}
		
		public function initObjects():void
		{
			for (var y:int = 0; y < _height; y++)
			{
				for (var x:int = 0; x < _width; x++)
				{
					if (this.tiles[x][y] != null)
					{
						(this.tiles[x][y] as Tile).x = 36 * x;
						(this.tiles[x][y] as Tile).y = 36 * y;
						
						if (this.tiles[x][y].currentNumber >= 64 && this.tiles[x][y].currentNumber <= 79)
							this.addChildAt(this.tiles[x][y], 0);
						else
							this.addChildAt(this.tiles[x][y], 2);
					}
				}
			}
		}
		
		public function addBullet(bullet:Bullet):void
		{
			this.bullets.push(bullet);
			this.addChild(this.bullets[bullets.length - 1]);
		}
		
		public function removeTile(x:int, y:int):void
		{
		
		}
		
		public function addTank(tank:Tank):void
		{
			this.tanks.push(tank);
			this.addChildAt(tank, 1);
		}
		
		public function removeTank(tank:Tank):void
		{
			if (this.tanks.indexOf(tank) >= 0)
			{
				this.removeChild(tank);
				this.tanks.splice(this.tanks.indexOf(tank), 1);
			}
		}
		
		public function removeBullet(bullet:Bullet):void
		{
			if (this.bullets.indexOf(bullet) >= 0)
			{
				this.removeChild(bullet);
				this.bullets.splice(this.bullets.indexOf(bullet), 1);
			}
		}
	}
}