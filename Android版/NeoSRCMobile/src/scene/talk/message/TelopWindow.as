package scene.talk.message
{
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CSprite;
	import feathers.controls.ScrollText;
	import flash.text.TextFormat;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import scene.main.MainController;
	
	/**
	 * ...
	 * @author
	 */
	public class TelopWindow extends CSprite
	{
		
		/**背景画像*/
		protected var _backImg:CImage = null;
		/**テキスト表示エリア*/
		protected var _textArea:ScrollText = null;
		
		public function TelopWindow(param:Object)
		{
			super();
			
			if (!param.hasOwnProperty("backcolor"))
			{
				param.backcolor = 0x0;
			}
			else
			{
				param.back = Number(param.back);
			}
			if (!param.hasOwnProperty("backalpha"))
			{
				param.backalpha = 0.8;
			}
			else
			{
				param.backalpha = Number(param.backalpha);
			}

			
			if (!param.hasOwnProperty("fontcolor"))
			{
				param.fontcolor = 0xFFFFFF;
			}
			else
			{
				param.fontcolor = Number(param.fontcolor);
			}
			
			if (!param.hasOwnProperty("fontsize"))
			{
				param.fontsize = 24;
			}
			else
			{
				param.fontsize = Number(param.fontsize);
			}
			
			if (!param.hasOwnProperty("x"))
			{
				param.x = 0;
			}
			else
			{
				param.x = Number(param.x);
			}
			if (!param.hasOwnProperty("y"))
			{
				param.y = 0;
			}
			else
			{
				param.y = Number(param.y);
			}
			if (!param.hasOwnProperty("width"))
			{
				param.width = CommonDef.WINDOW_W;
			}
			else
			{
				param.width = Number(param.width);
			}
			if (!param.hasOwnProperty("height"))
			{
				param.height = CommonDef.WINDOW_H;
			}
			else
			{
				param.height = Number(param.height);
			}
			
			if (!param.hasOwnProperty("margin"))
			{
				param.margin = 28;
			}
			else
			{
				param.margin = Number(param.margin);
			}
			
			this.x = param.x;
			this.y = param.y;
			this.visible = false;
			
			var tex:Texture = MainController.$.imgAsset.getTexture("tex_white");
			_backImg = new CImage(tex);
			_backImg.color = param.backcolor;
			_backImg.alpha = param.backalpha;
			_backImg.width = param.width;
			_backImg.height = param.height;
			_backImg.textureSmoothing = TextureSmoothing.NONE;
			addChild(_backImg);
			
			//テキスト表示領域
			_textArea = new ScrollText();
			_textArea.isHTML = true;
			
			_textArea.touchable = false;
			_textArea.name = "free_window";
			_textArea.textFormat = new TextFormat("ComicFont", param.fontsize, param.fontcolor);
			_textArea.embedFonts = true;
			
			_textArea.text = "";
			_textArea.x = param.margin;
			_textArea.y = param.margin;
			
			_textArea.width = _backImg.width - param.margin * 2;
			_textArea.minHeight = _backImg.height - param.margin * 2;
			_textArea.maxHeight = _backImg.height - param.margin * 2;
			
			this.alpha = 0;
			this.addChild(_textArea);
		}
		
		override public function dispose():void
		{
			//_textArea.textViewPort.textField.filters = null;
			_backImg.dispose();
			_textArea.dispose();
			super.dispose();
		}
		
		override public function set alpha(value:Number):void
		{
			super.alpha = value;
			CONFIG::phone
			{
				if (_textArea != null)
				{
					_textArea.alpha = value;
					if (_textArea.alpha < 1)
					{
						_textArea.visible = false;
					}
					else
					{
						_textArea.visible = true;
					}
				}
			}
		}
		
		/**メッセージ追加*/
		public function addText(str:String):void
		{
			_textArea.text += str;
		}
		
		/**メッセージ追加*/
		public function setText(str:String):void
		{
			_textArea.text = str;
		}
		
		public function clearText():void
		{
			_textArea.text = "";
		}
		
		public function get textArea():ScrollText
		{
			return _textArea;
		}
	
	}
}