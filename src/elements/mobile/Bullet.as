package elements.mobile
{
	import elements.fixed.Cell;
	import elements.fixed.Tile;
	import elements.mobile.Bullet;
	import enums.Direction;
	import enums.Material;
	import fields.GameField;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	public class Bullet extends MovingObject
	{
		public var power:int = 10;
		
		private var concreteSound:Sound = new Sound(new URLRequest("sound/concrete.mp3"));
		private var brickSound:Sound = new Sound(new URLRequest("sound/brick.mp3"));
		
		public function Bullet(direction:int, x:int, y:int)
		{
			this.width = 5;
			this.height = 6;
			this.x = x;
			this.y = y;
			this.velocity = 6;
			this.image.load("../bin/graphics/bullet.png");
			this.image.width = this.width;
			this.image.height = this.height;
			addChild(this.image);
			setDirection(direction);
		}
		
		public override function moveForward():void
		{
			switch (this.direction)
			{
				case Direction.Right: 
					this.x += velocity;
					break;
				
				case Direction.Left: 
					this.x -= velocity;
					break;
				
				case Direction.Top: 
					this.y -= velocity;
					break;
				
				case Direction.Bottom: 
					this.y += velocity;
					break;
			}
			detectCollision();
		}
		
		private function detectCollision():void
		{
			// вылет за пределы поля
			if (this.x < 0 || this.x > (this.parent as GameField).width - this.width || this.y < 0 || this.y > (this.parent as GameField).height + this.height)
			{
				(this.parent as GameField).removeBullet(this);
				concreteSound.play();
			}
			// столкновение с объектами
			else
			{
				if (!checkTanksCollisions())
					checkTilesCollisions();
			}
		}
		
		private function checkTanksCollisions():Boolean
		{
			for each (var tank:Tank in(this.parent as GameField).tanks)
			{
				if (this.hitTestObject(tank))
				{
					tank.setHealth(-this.power);
					(this.parent as GameField).removeBullet(this);
					brickSound.play();
					return true;
				}
			}
			return false;
		}
		
		private function checkTilesCollisions():void
		{
			var x:int = this.x / 36; // координата тайла
			var y:int = this.y / 36;
			if (x < (this.parent as GameField)._width && y < (this.parent as GameField)._height && (this.parent as GameField).tiles[x][y] != null)
			{
				var cellX:int = (this.x - ((this.parent as GameField).tiles[x][y] as Tile).width * x) / (((this.parent as GameField).tiles[x][y] as Tile).width / 2);
				var cellY:int = (this.y - ((this.parent as GameField).tiles[x][y] as Tile).height * y) / (((this.parent as GameField).tiles[x][y] as Tile).height / 2);
				if (((this.parent as GameField).tiles[x][y] as Tile).cells[cellX][cellY] != null)
				{
					var cellMaterial:int = (((this.parent as GameField).tiles[x][y] as Tile).cells[cellX][cellY] as Cell).material;
					// если есть что сломать - ломаем
					if (cellMaterial == Material.Brick)
					{
						((this.parent as GameField).tiles[x][y] as Tile).ClearCell(cellX, cellY);
						// ломаем соседний блок, если такой имеется
						if (this.direction == Direction.Right || this.direction == Direction.Left)
						{
							var nearCellY:int = cellY == 0 ? 1 : 0;
							if (((this.parent as GameField).tiles[x][y] as Tile).cells[cellX][nearCellY] != null)
								((this.parent as GameField).tiles[x][y] as Tile).ClearCell(cellX, nearCellY);
						}
						if (this.direction == Direction.Top || this.direction == Direction.Bottom)
						{
							var nearCellX:int = cellX == 0 ? 1 : 0;
							if (((this.parent as GameField).tiles[x][y] as Tile).cells[nearCellX][cellY] != null)
								((this.parent as GameField).tiles[x][y] as Tile).ClearCell(nearCellX, cellY);
						}
						brickSound.play();
					}
					if (cellMaterial == Material.Concrete)
						concreteSound.play();
					// если пуля не может пролететь через этот объект - убираем
					if (cellMaterial != Material.Grass && cellMaterial != Material.Ice && cellMaterial != Material.Water)
						(this.parent as GameField).removeBullet(this);
				}
			}
		}
	}
}