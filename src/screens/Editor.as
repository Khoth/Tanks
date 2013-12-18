package screens
{
	import mx.containers.Canvas;
	import fields.EditorField;
	
	public class Editor extends Canvas
	{
		private var field:EditorField = new EditorField();		
		
		public function Init():void {
			this.width = 640;
			this.height = 480;
			this.x = 0;
			this.y = 0;
			this.autoLayout = false;
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";
			this.setStyle("backgroundColor", "0x71857F");
			this.field.Init();
			addChild(this.field);
		}
	}

}