package elements.mobile
{
	import elements.fixed.Cell;
	import elements.fixed.Tile;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import enums.Direction;
	import fields.GameField;
	import enums.Material;
	
	public class Tank extends MovingObject
	{
		private var health:int = 10;
		public var shootFrequency:int = 40; // скорострельность 
		private var reloadingProgress:int = 0; // состояние перезарядки (0 - можно стрелять, 1..shootFrequency - идет перезарядка)
		
		private var shootSound:Sound = new Sound(new URLRequest("sound/shoot.mp3"));
		private var movingSound:Sound = new Sound(new URLRequest("sound/move.mp3"));
		private var blowSound:Sound = new Sound(new URLRequest("sound/blow.mp3"));
		
		public function Tank(x:int, y:int, direction:int)
		{
			this.width = 36;
			this.height = 36;
			this.x = x;
			this.y = y;
			this.velocity = 2;
			this.image.width = this.width;
			this.image.height = this.height;
			this.image.load("graphics/yellow_tank_level_1.png");
			addChild(this.image);			
			this.addEventListener(Event.ENTER_FRAME, reload);
			setDirection(direction);
		}
		
		private var x_delta:int; // смещение пули относительно верхнего левого угла танка
		private var y_delta:int; // смещение пули относительно верхнего левого угла танка
		private const bullet_delta:int = 2; // поправка смещения пули с учетом ширины пули
		
		public function shoot():void
		{
			if (this.reloadingProgress == 0)
			{
				// двигаем пулю к дулу
				switch (this.direction)
				{
					case Direction.Top: 
						x_delta = this.width / 2 - bullet_delta;
						y_delta = 0;
						break;
					case Direction.Bottom: 
						x_delta = this.width / 2 + bullet_delta;
						y_delta = this.height;
						break;
					case Direction.Left: 
						x_delta = 0;
						y_delta = this.height / 2 + bullet_delta;
						break;
					case Direction.Right: 
						x_delta = this.width;
						y_delta = this.height / 2 - bullet_delta;
						break;
				}
				// отправляем пулю лететь в поле
				(this.parent as GameField).addBullet(new Bullet(this.direction, this.x + x_delta, this.y + y_delta));
				this.reloadingProgress++;
				shootSound.play();
			}
		}
		
		private function reload(e:Event):void
		{
			if (this.reloadingProgress > 0 && this.reloadingProgress <= this.shootFrequency)
				this.reloadingProgress++;
			else if (this.reloadingProgress > this.shootFrequency)
				this.reloadingProgress = 0;
		}
		
		public function setHealth(health:int):void
		{
			this.health += health;
			if (this.health <= 0)
				die();
		}
		
		private function die():void
		{
			(this.parent as GameField).removeTank(this);
			blowSound.play();
			// возможно когда-нибудь здесь будет анимация
		}
		
		public override function moveForward():void
		{
			switch (this.direction)
			{
				case Direction.Right: 
					this.x += velocity;
					if (this.x > (this.parent as GameField).width - this.width)
						this.x = (this.parent as GameField).width - this.width;
					break;
				
				case Direction.Left: 
					this.x -= velocity;
					if (this.x < 0)
						this.x = 0;
					break;
				
				case Direction.Top: 
					this.y -= velocity;
					if (this.y < 0)
						this.y = 0;
					break;
				
				case Direction.Bottom: 
					this.y += velocity;
					if (this.y > (this.parent as GameField).height - this.height)
						this.y = (this.parent as GameField).height - this.height;
					break;
			}
			checkTilesCollisions();
			//checkTanksCollisions();
			movingSound.play();
		}
		
		private function checkTilesCollisions():void
		{
			var frontLine:Vector.<Point> = new Vector.<Point>();
			var x:int;
			var y:int;
			switch (this.direction)
			{
				case Direction.Top: 
					for (x = this.x; x < this.x + this.width; x++)
						frontLine.push(new Point(x, this.y));
					break;
				case Direction.Bottom: 
					for (x = this.x; x < this.x + this.width; x++)
						frontLine.push(new Point(x, this.y + this.height - 1));
					break;
				case Direction.Left: 
					for (y = this.y; y < this.y + this.height; y++)
						frontLine.push(new Point(this.x, y));
					break;
				case Direction.Right: 
					for (y = this.y; y < this.y + this.height; y++)
						frontLine.push(new Point(this.x + this.width - 1, y));
					break;
			}
			var isCollapsed:Boolean = false;
			for each (var point:Point in frontLine)
				isCollapsed = isCollapsed || isFacedWithCell(point.x, point.y);
			if (isCollapsed)
			{
				var k:int = 0;
				switch (this.direction)
				{
					case Direction.Top: 
						k = this.y / 18;
						this.y = (k + 1) * 18;
						break;
					case Direction.Bottom: 
						k = this.y / 18;
						this.y = k * 18;
						break;
					case Direction.Left: 
						k = this.x / 18;
						this.x = (k + 1) * 18;
						break;
					case Direction.Right: 
						k = this.x / 18;
						this.x = k * 18;
						break;
				}
			}
		}
		
		private function isFacedWithCell(x:int, y:int):Boolean
		{
			var tileX:int = x / 36;
			var tileY:int = y / 36;
			if (tileX < (this.parent as GameField)._width && tileY < (this.parent as GameField)._height && (this.parent as GameField).tiles[tileX][tileY] != null)
			{
				var cellX:int = (x - 36 * tileX) / 18;
				var cellY:int = (y - 36 * tileY) / 18;
				if (((this.parent as GameField).tiles[tileX][tileY] as Tile).cells[cellX][cellY] != null)
				{
					var cell:Cell = ((this.parent as GameField).tiles[tileX][tileY] as Tile).cells[cellX][cellY];
					if (cell.material == Material.Brick || cell.material == Material.Concrete)
						return true;
				}
			}
			return false;
		}
		
		private function checkTanksCollisions():void
		{
		
		}
	}
}