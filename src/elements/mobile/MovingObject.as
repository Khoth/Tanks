package elements.mobile
{
	import flash.geom.Matrix;
	import mx.containers.Canvas;
	import mx.controls.Image;
	import enums.Direction;
	
	public class MovingObject extends Canvas
	{
		public function MovingObject()
		{
			this.autoLayout = false;
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";
		}
		
		protected var image:Image = new Image();
		public var direction:int = Direction.Top;
		protected var velocity:int = 0;
		
		public function setDirection(direction:int):void
		{
			if (direction != this.direction)
			{
				undoRotation();
				this.direction = direction;
				
				switch (this.direction)
				{
					case Direction.Top: 
						rotateImage(0);
						break;
					case Direction.Right: 
						rotateImage(90);
						break;
					case Direction.Bottom: 
						rotateImage(180);
						break;
					case Direction.Left: 
						rotateImage(-90);
						break;
				}
			}
		}
		
		public function moveForward():void
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
		}
		
		private function rotateImage(degrees:Number):void
		{
			var radians:Number = degrees * (Math.PI / 180.0);
			var offsetWidth:Number = this.image.contentWidth / 2.0;
			var offsetHeight:Number = this.image.contentHeight / 2.0;
			var matrix:Matrix = new Matrix();
			matrix.translate(-offsetWidth, -offsetHeight);
			matrix.rotate(radians);
			matrix.translate(+offsetWidth, +offsetHeight);
			matrix.concat(this.image.transform.matrix);
			this.image.transform.matrix = matrix;
		}
		
		private function undoRotation():void
		{
			switch (this.direction)
			{
				case Direction.Right: 
					rotateImage(-90);
					break;
				
				case Direction.Left: 
					rotateImage(90);
					break;
				
				case Direction.Top: 
					break;
				
				case Direction.Bottom: 
					rotateImage(180);
					break;
			}
		}
	}

}