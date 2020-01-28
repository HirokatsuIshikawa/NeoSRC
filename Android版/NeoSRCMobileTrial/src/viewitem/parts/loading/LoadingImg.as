package viewitem.parts.loading
{
	import common.CommonDef;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CSprite;
	import system.custom.customSprite.CTextArea;
	import flash.text.TextFormatAlign;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class LoadingImg extends CSprite
	{
		
		private var _darkField:CImage = null;
		private var _textArea:CTextArea = null;
		
		public function LoadingImg()
		{
			super();
						
			_darkField = new CImage(Texture.fromBitmap(new CommonDef.TexBlackImg()));
			
			_darkField.width = CommonDef.WINDOW_W;
			_darkField.height = CommonDef.WINDOW_H;
			_darkField.alpha = 0.4;
			
			_textArea = new CTextArea(24,0xFFFFFF,0x0, TextFormatAlign.CENTER);
			//_textArea.styleName = "custom_text";
			_textArea.width = 240;
			_textArea.height = 32;
			_textArea.x = (CommonDef.WINDOW_W - 240) / 2;
			_textArea.y = (CommonDef.WINDOW_H - 32) / 2;
			_textArea.text = "NowLoading..."
			
			
			addChild(_darkField);
			addChild(_textArea);
		}
		
		public function setLoadingText(str:String):void
		{
			this.visible = true;
			_textArea.text = str;
		}
		
		public function initLoadingText():void
		{
			this.visible = true;
			_textArea.text = "NowLoading..."
		}
		
		

		public function setAlpha(num:Number):void
		{
			_darkField.alpha = num;
			
			
		}
		
	
	}

}