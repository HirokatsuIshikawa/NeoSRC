package viewitem.parts.alert {
	import feathers.controls.Button;
	import feathers.controls.TextArea;
	import flash.display.BitmapData;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author
	 */
	public class AlertBase extends Sprite
	{
		/**背景*/
		private var _backImg:Image = null;
		/**ラベル名*/
		private var _labelName:String = null;
		/**ラベル*/
		private var _label:TextArea = null;
		/**OKボタン*/
		private var _btnYes:Button = null;
		/**キャンセルボタン*/
		private var _btnNo:Button = null;
		
		/**ボタンタイプ*/
		static const BTN_TYPE:int = 1;
		
		public function AlertBase()
		{
			super();
			//背景セット
			_backImg = new Image(Texture.fromBitmapData(new BitmapData(320, 160, true, 0xFFFFAAAA)));
			addChild(_backImg);
			
			//名前
			_label = new TextArea();
			_label.x = 4;
			_label.y = 4;
			addChild(_label);
		
		}
		
		public function setLabel(str:String):void
		{
			_labelName = str;
			_label.text = str;
		}
	
	}

}