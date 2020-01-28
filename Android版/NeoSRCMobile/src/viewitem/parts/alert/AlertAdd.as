package viewitem.parts.alert {
	import feathers.controls.Button;
	import flash.display.BitmapData;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import parts.Input.LabelTextInput;
	
	/**
	 * ...
	 * @author
	 */
	public class AlertAdd extends AlertBase
	{
		
		public function AlertAdd(name:String)
		{
			super();
			//名前
			super.setLabel = name;
		}
	
	}

}