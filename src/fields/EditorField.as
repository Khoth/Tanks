package fields
{
	import elements.fixed.Tile;
	import flash.events.MouseEvent;
	import mx.containers.Canvas;
	
	public class EditorField extends Canvas
	{
		private const _width:int = 13;
		private const _height:int = 12;
		private var tiles:Array = new Array();
		private var cellWidth:int;
		private var cellHeight:int;
		
		public function Init():void
		{
			this.width = 468;
			this.height = 432;
			this.x = 24;
			this.y = 24;
			this.autoLayout = false;
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";
			this.buttonMode = true;
			
			cellWidth = this.width / _width;
			cellHeight = this.height / _height;
			
			for (var x:int = 0; x < _width; x++)
				this.tiles[x] = new Vector.<Tile>(_height);
			
			// Рисуем фон
			this.graphics.beginFill(0x000000, 1);
			this.graphics.drawRect(0, 0, this.width, this.height);
			this.graphics.endFill();
			
			// Неизменяемые клетки
			this.graphics.beginFill(0x222222, 1);
			this.graphics.drawRect(0, 0, cellWidth, cellHeight);
			this.graphics.drawRect(cellWidth * (_width - 1) / 2, 0, cellWidth, cellHeight);
			this.graphics.drawRect(cellWidth * (_width - 1) / 2, cellHeight * (_height - 1), cellWidth, cellHeight);
			this.graphics.drawRect(cellWidth * (_width - 1), 0, cellWidth, cellHeight);
			this.graphics.endFill();
			
			// пробные тайлы			
			var center:int = (_width - 1) / 2;
			
			/*
			   this.tiles[center - 1][_height - 1] = new Tile();
			   this.tiles[center - 1][_height - 1].SetCell(new Cell(Material.Brick), 0, 0);
			   this.tiles[center - 1][_height - 1].SetCell(new Cell(Material.Brick), 0, 1);
			   this.tiles[center - 1][_height - 1].SetCell(new Cell(Material.Brick), 1, 0);
			   this.tiles[center - 1][_height - 1].SetCell(new Cell(Material.Brick), 1, 1);
			
			   this.tiles[2][4] = new Tile();
			   this.tiles[2][4].SetCell(new Cell(Material.Water), 0, 0);
			   this.tiles[2][4].SetCell(new Cell(Material.Water), 1, 0);
			 */
			
			DrawGrid();
			InitTiles();
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, MouseMove);
			this.addEventListener(MouseEvent.CLICK, MouseClick);
		}
		
		private function MouseMove(event:MouseEvent):void
		{
			if (IsLocked(event.target.mouseX, event.target.mouseY))
				this.buttonMode = false;
			else
				this.buttonMode = true;
		}
		
		private function InitTiles():void
		{
			for (var y:int = 0; y < _height; y++)
			{
				for (var x:int = 0; x < _width; x++)
				{
					this.tiles[x][y] = new Tile(0);
					(this.tiles[x][y] as Tile).x = 36 * x;
					(this.tiles[x][y] as Tile).y = 36 * y;
					addChild(this.tiles[x][y]);
					this.tiles[x][y].buttonMode = true;
				}
			}
		}
		
		// метод проверят не было ли попадания мышью по клетке спавна или базе
		private function IsLocked(x:int, y:int):Boolean
		{
			return ((x >= 0) && (x <= cellWidth) && (y >= 0) && (y <= cellHeight)) || ((x >= cellWidth * (_width - 1) / 2) && (x <= (cellWidth * (_width - 1) / 2 + cellWidth)) && (y >= 0) && (y <= cellHeight)) || ((x >= cellWidth * (_width - 1) / 2) && (x <= (cellWidth * (_width - 1) / 2 + cellWidth)) && (y >= cellHeight * (_height - 1)) && (y <= (cellHeight * (_height - 1) + cellHeight))) || ((x >= cellWidth * (_width - 1)) && (x <= (cellWidth * (_width - 1) + cellWidth)) && (y >= 0) && (y <= cellHeight));
		}
		
		private function MouseClick(event:MouseEvent):void
		{
			if (!IsLocked(event.currentTarget.mouseX, event.currentTarget.mouseY))
			{
				var currentTile:Tile = GetTileByCoord(event.currentTarget.mouseX, event.currentTarget.mouseY);
				if (currentTile != null)
				{
					currentTile.SetNextNumber();
				}
			}
		}
		
		private function GetTileByCoord(x:int, y:int):Tile
		{
			var cellX:int = x / cellWidth;
			var cellY:int = y / cellHeight;
			if (cellX >= 0 && cellX < _width && cellY >= 0 && cellY < _height)
				return this.tiles[cellX][cellY];
			return null;
		}
		
		private function DrawGrid():void
		{
			this.graphics.lineStyle(1, 0x222222, 1);
			
			for (var i:int = 1; i < _height; i++)
			{
				this.graphics.moveTo(0, i * cellHeight);
				this.graphics.lineTo(this.width, i * cellHeight);
			}
			
			for (var k:int = 1; k < _width; k++)
			{
				this.graphics.moveTo(k * cellWidth, 0);
				this.graphics.lineTo(k * cellWidth, this.height);
			}
		}
	}
}