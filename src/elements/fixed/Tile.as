package elements.fixed
{
	import mx.containers.Canvas;
	import enums.Material;
	
	public class Tile extends Canvas
	{
		private const _width:int = 2;
		private const _height:int = 2;
		public var cells:Array = new Array();
		
		public function Tile(number:int)
		{
			for (var i:int = 0; i < _height; i++)
			{
				var line:Vector.<Cell> = new Vector.<Cell>(_width);
				this.cells[i] = line;
			}
			
			this.width = 36;
			this.height = 36;
			this.autoLayout = false;
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";
			this.currentNumber = number;
			GetCellsFromCurrentNumber();
		}
		
		public function SetCell(cell:Cell, x:int, y:int):void
		{
			if (x >= 0 && x <= _width && y >= 0 && y <= _height && cell != null)
			{
				if (this.cells[x][y] != null)
					removeChild(this.cells[x][y]);
				this.cells[x][y] = cell;
				this.cells[x][y].x = this.width / 2 * x;
				this.cells[x][y].y = this.height / 2 * y;
				addChild(this.cells[x][y]);
				GetCurrentNumber();
			}
		}
		
		public function ClearCell(x:int, y:int):void
		{
			if (x >= 0 && x <= _width && y >= 0 && y <= _height && this.cells[x][y] != null)
			{
				removeChild(this.cells[x][y]);
				this.cells[x][y] = null;
				GetCurrentNumber();
			}
		}
		
		public var currentNumber:int = 0;
		
		// Тип тайла определяется следующим образом:
		//     материал   номер ячейки (биты)
		// .. 8 7 6 5 4 | 3 2 1 0
		// ------------------------
		//    G W I C B | 1 1 1 1
		// например
		// .. 0 0 0 0 1   1 1 1 1 = 31 это кирпичный блок 4х4
		// .. 0 0 0 1 0   1 0 1 0 = 42 это вертикальный бетонный блок 1х2		
		// все тайлы из одного материала
		//
		// нумерация ячеек:
		//  0 | 1
		//  2 | 3
		
		private function GetCurrentNumber():void
		{
			this.currentNumber = (this.cells[0][0] != null ? 1 : 0) + 2 * (this.cells[1][0] != null ? 1 : 0) + 4 * (this.cells[0][1] != null ? 1 : 0) + 8 * (this.cells[1][1] != null ? 1 : 0);
			if (this.cells[0][0] != null)
				this.currentNumber += Math.pow(2, 4 + (this.cells[0][0] as Cell).material);
			else if (this.cells[0][1] != null)
				this.currentNumber += Math.pow(2, 4 + (this.cells[0][1] as Cell).material);
			else if (this.cells[1][0] != null)
				this.currentNumber += Math.pow(2, 4 + (this.cells[1][0] as Cell).material);
			else if (this.cells[1][1] != null)
				this.currentNumber += Math.pow(2, 4 + (this.cells[1][1] as Cell).material);
		}
		
		private var allowedTileForms:Array = [3, 5, 10, 12, 15];
		private var materialNumbers:Array = [Material.Brick, Material.Concrete, Material.Ice, Material.Water, Material.Grass];
		
		public function SetNextNumber():void
		{
			var newNumber:int = 19;
			var k:int = 0;
			var m:int = 0;
			while (newNumber <= this.currentNumber && newNumber > 0)
			{
				newNumber = Math.pow(2, 4 + materialNumbers[m]) + allowedTileForms[k]; // 2^(4 + m) + k
				k++;
				if (k >= allowedTileForms.length)
				{
					k = 0;
					m++;
				}
				if (m > materialNumbers.length)
					newNumber = 0;
			}
			this.currentNumber = newNumber;
			
			GetCellsFromCurrentNumber();
		}
		
		private function GetCellsFromCurrentNumber():void
		{
			if (currentNumber == 0)
			{
				ClearCell(0, 0);
				ClearCell(1, 0);
				ClearCell(0, 1);
				ClearCell(1, 1);
			}
			else
			{
				var charArray:Array = currentNumber.toString(2).split("");
				var stringForm:String = new String();
				
				for (var i:int = 4; i > 0; i--)
				{
					stringForm += charArray[charArray.length - i];
				}
				
				var tileForm:int = parseInt(stringForm, 2);
				var material:int = charArray.length - 5;
				
				if (tileForm == 3)
				{
					SetCell(new Cell(material), 0, 0);
					SetCell(new Cell(material), 1, 0);
					ClearCell(0, 1);
					ClearCell(1, 1);
				}
				else if (tileForm == 5)
				{
					SetCell(new Cell(material), 0, 0);
					SetCell(new Cell(material), 0, 1);
					ClearCell(1, 0);
					ClearCell(1, 1);
				}
				else if (tileForm == 10)
				{
					SetCell(new Cell(material), 1, 0);
					SetCell(new Cell(material), 1, 1);
					ClearCell(0, 0);
					ClearCell(0, 1);
				}
				else if (tileForm == 12)
				{
					SetCell(new Cell(material), 0, 1);
					SetCell(new Cell(material), 1, 1);
					ClearCell(0, 0);
					ClearCell(1, 0);
				}
				else if (tileForm == 15)
				{
					SetCell(new Cell(material), 0, 0);
					SetCell(new Cell(material), 1, 0);
					SetCell(new Cell(material), 0, 1);
					SetCell(new Cell(material), 1, 1);
				}
			}
		}
	}
}