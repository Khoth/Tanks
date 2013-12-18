package screens
{
	import mx.containers.Canvas;
	
	public class Menu extends Canvas
	{		
		public function Init():void
		{
			this.width = 640;
			this.height = 480;
			this.x = 0;
			this.y = 0;
			this.autoLayout = false;
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";
			this.setStyle("backgroundColor", "0xAA0000");
		}
	}
}