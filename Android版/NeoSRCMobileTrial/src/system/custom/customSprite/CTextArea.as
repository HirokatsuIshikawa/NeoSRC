package system.custom.customSprite 
{
	import feathers.controls.TextArea;
	import flash.display.BitmapData;
	import flash.text.TextFormatAlign;
	import starling.display.Image;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author ...
	 */
	public class CTextArea extends TextArea
	{
		private var _textSize:int = 18
		private var _textColor:uint = 0x0;
		private var _input:Boolean = false;
		private var _backColor:uint = 0xFFFFFFFF;
		private var _backTex:Texture = null;
		private var _multiLine:Boolean = false;
		private var _align:String = "left";
		
		public function CTextArea(textSize:int = 18, textColor:uint = 0x0, backColor:uint = 0xFFFFFFFF, align:String = TextFormatAlign.LEFT, input:Boolean = false, multiLine:Boolean = false ) 
		{
			_align = align;
			_textSize = textSize;
			_textColor = textColor;
			_input = input;
			_backColor = backColor;
			_multiLine = multiLine;
			if (_backColor > 0)
			{
				_backTex = Texture.fromBitmapData(new BitmapData(4, 4, true, _backColor))
			}
			super();
			styleName = "noveltext";
		}
		
		override public function dispose():void
		{
			if (_backTex != null)
			{
				_backTex.dispose();
			}
			_backTex = null;
			super.dispose();
		}
		
		
		public function get textSize():int 
		{
			return _textSize;
		}
		
		public function get textColor():uint 
		{
			return _textColor;
		}
		
		public function get input():Boolean 
		{
			return _input;
		}
		
		public function get backColor():uint 
		{
			return _backColor;
		}
		
		public function get backTex():Texture 
		{
			return _backTex;
		}
		
		public function get multiLine():Boolean 
		{
			return _multiLine;
		}
		
		public function get align():String 
		{
			return _align;
		}
		
	}

}