package elements.fixed
{
	import flash.utils.Dictionary;
	import mx.containers.Canvas;
	import mx.controls.Image;
	import enums.Material;
	
	public class Cell extends Canvas
	{
		public var material:int = 0;
		private var images:Dictionary = new Dictionary();
		
		public function Cell(material:int)
		{
			LoadTextures();
			
			if (material == Material.Brick || material == Material.Concrete || material == Material.Grass || material == Material.Ice || Material.Water)
			{
				this.material = material;
			}
			
			this.width = 18;
			this.height = 18;
			this.autoLayout = false;
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";
			addChild(this.images[this.material]);
		}
		
		private function LoadTextures():void
		{
			// сократить
			var brick:Image = new Image();
			brick.width = 18;
			brick.height = 18;
			brick.load("graphics/brick.png");
			this.images[Material.Brick] = brick;
			
			var concrete:Image = new Image();
			concrete.width = 18;
			concrete.height = 18;
			concrete.load("graphics/concrete.png");
			this.images[Material.Concrete] = concrete;
			
			var grass:Image = new Image();
			grass.width = 18;
			grass.height = 18;
			grass.load("graphics/grass.png");
			this.images[Material.Grass] = grass;
			
			var water:Image = new Image();
			water.width = 18;
			water.height = 18;
			water.load("graphics/water.png");
			this.images[Material.Water] = water;
			
			var ice:Image = new Image();
			ice.width = 18;
			ice.height = 18;
			ice.load("graphics/ice.png");
			this.images[Material.Ice] = ice;
		}
	}
}