package system.custom.customTheme
{
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CButton;
	import system.custom.customSprite.CImgButton;
	import system.custom.customSprite.CTextArea;
	import feathers.controls.Button;
	import feathers.controls.ScrollText;
	import feathers.controls.TextArea;
	import feathers.controls.text.ITextEditorViewPort;
	import feathers.controls.text.TextFieldTextEditorViewPort;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.themes.MetalWorksMobileTheme;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import starling.display.Image;
	import starling.events.*;
	import starling.filters.DropShadowFilter;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import scene.main.MainController;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class CustomTheme extends MetalWorksMobileTheme
	{
		//ドロップダウンリスト
		
		[Embed(source = "../../../../asset/system/btn_list_main.png")]
		public static const img_listBtnMain:Class;
		[Embed(source = "../../../../asset/system/btn_list_sub.png")]
		public static const img_listBtnSub:Class;
		/*
		[Embed(source = "../../../asset/system/nameplate.png")]
		public static const img_nameplate:Class;
		*/
		/*
		   //切り替えボタン
		   [Embed(source="../../assets/img/btn_on.png")]
		   public static const img_btnOn:Class;
		   [Embed(source="../../assets/img/btn_off.png")]
		   public static const img_btnOff:Class;
		   //サウンドボタン
		   [Embed(source="../../assets/img/btn_sound.png")]
		   public static const img_btnSound:Class;
		 */
		//フォント
		[Embed(source="../../../../asset/font/f910-shin-comic-2.otf", fontName = 'ComicFont', embedAsCFF = 'false')]
		public static const ComicFont:Class;
		
		// textures
		private var _btnTex:Texture = null;
		private var _textBackTex:Texture = null;
		private var _listTextBackTex:Texture = null;
		private var _mstTextBackTex:Texture = null;
		private var _defaultListBtnTex:Texture = null;
		private var _downListBtnTex:Texture = null;
		private var _namePlateTex:Texture = null;
		
		/**コンストラクタ*/
		public function CustomTheme()
		{
			super();
		}
		
		/**スタイル初期化*/
		override protected function initializeStyleProviders():void
		{
			super.initializeStyleProviders(); // don't forget this!
			
			// デフォルト設定
			this.getStyleProviderForClass(Button).defaultStyleFunction = this.setDefaultBtn;
			this.getStyleProviderForClass(TextArea).defaultStyleFunction = this.setTextArea;
			
			// スタイル設定
			this.getStyleProviderForClass(Button).setFunctionForStyleName("setListBtn", this.setListBtnMain);
			this.getStyleProviderForClass(Button).setFunctionForStyleName("imgBtn", this.setImgBtn);
			this.getStyleProviderForClass(Button).setFunctionForStyleName("systemBtn", this.setSystemBtn);
			this.getStyleProviderForClass(Button).setFunctionForStyleName("bigBtn", this.setBigBtn);
			this.getStyleProviderForClass(Button).setFunctionForStyleName("touchBtn", this.setTouchBtn);
			this.getStyleProviderForClass(TextArea).setFunctionForStyleName("custom_text", this.setWeaponTextArea);
			this.getStyleProviderForClass(TextArea).setFunctionForStyleName("list_text", this.setListTextArea);
			this.getStyleProviderForClass(TextArea).setFunctionForStyleName("nameplate", this.setNamePlate);
			this.getStyleProviderForClass(TextArea).setFunctionForStyleName("noveltext", this.setNovelTextArea);
			
			
			//this.getStyleProviderForClass(TextArea).setFunctionForStyleName("message_window", this.setMessageText);
			this.getStyleProviderForClass(ScrollText).setFunctionForStyleName("message_window", this.setScrollMessageText);
			this.getStyleProviderForClass(ScrollText).setFunctionForStyleName("free_window", this.setDefaultScrollMessageText);
			this.getStyleProviderForClass(Button).setFunctionForStyleName("tipBtn", this.setTipBtn);
		}
		
		/**リストボタンメイン*/
		protected function setTipBtn(button:Button):void
		{
		}
		
		/**リストボタンメイン*/
		protected function setSystemBtn(button:Button):void
		{
			if (_defaultListBtnTex == null)
			{
				_defaultListBtnTex = Texture.fromBitmap(new img_listBtnMain());
			}
			if (_downListBtnTex == null)
			{
				_downListBtnTex = Texture.fromBitmap(new img_listBtnSub());
			}
			
			button.defaultSkin = new Image(_defaultListBtnTex);
			button.downSkin = new Image(_downListBtnTex);
			(Image)(button.defaultSkin).textureSmoothing = TextureSmoothing.NONE;
			(Image)(button.downSkin).textureSmoothing = TextureSmoothing.NONE;
			
			(button.defaultSkin as Image).scale9Grid = new Rectangle(2, 0, 2, _defaultListBtnTex.frameHeight);
			(button.downSkin as Image).scale9Grid = new Rectangle(2, 0, 2, _downListBtnTex.frameHeight);
			
			button.labelFactory = function():ITextRenderer
			{
				var textField:TextFieldTextRenderer = new TextFieldTextRenderer();
				textField.textFormat = new TextFormat("ComicFont", 16, 0x0);
				textField.embedFonts = false;
				return textField;
			};
		}
		
		protected function setDefaultBtn(button:Button):void
		{
			
		}
		
		/**リストボタンメイン*/
		protected function setListBtnMain(button:Button):void
		{
			
			// デフォルト設定
			this.getStyleProviderForClass(Button).defaultStyleFunction = this.setListBtnMain;
			this.getStyleProviderForClass(TextArea).defaultStyleFunction = this.setTextArea;
			if (_defaultListBtnTex == null)
			{
				_defaultListBtnTex = MainController.$.imgAsset.getTexture("btn_list_main");
			}
			if (_downListBtnTex == null)
			{
				_downListBtnTex = MainController.$.imgAsset.getTexture("btn_list_sub");
			}
			
			button.defaultSkin = new Image(_defaultListBtnTex);
			button.downSkin = new Image(_downListBtnTex);
			
			(Image)(button.defaultSkin).textureSmoothing = TextureSmoothing.NONE;
			(Image)(button.downSkin).textureSmoothing = TextureSmoothing.NONE;
			
			(button.defaultSkin as Image).scale9Grid = new Rectangle(2, 0, 2, _defaultListBtnTex.frameHeight);
			(button.downSkin as Image).scale9Grid = new Rectangle(2, 0, 2, _downListBtnTex.frameHeight);
			
			button.labelFactory = function():ITextRenderer
			{
				var textField:TextFieldTextRenderer = new TextFieldTextRenderer();
				textField.textFormat = new TextFormat("ComicFont", 16, 0x0);
				textField.embedFonts = false;
				return textField;
			};
		}
		
		/**リストボタンメイン*/
		protected function setBigBtn(button:CButton):void
		{
			_defaultListBtnTex = MainController.$.imgAsset.getTexture("btn_list_main");
			_downListBtnTex = MainController.$.imgAsset.getTexture("btn_list_sub");
			
			//_defaultListBtnTex = TextureManager.loadTexture("system", "btn_list_main", TextureManager.TYPE_OTHER);
			//_downListBtnTex = TextureManager.loadTexture("system", "btn_list_sub", TextureManager.TYPE_OTHER);
			
			button.defaultSkin = new Image(_defaultListBtnTex);
			button.downSkin = new Image(_downListBtnTex);
			(Image)(button.defaultSkin).textureSmoothing = TextureSmoothing.NONE;
			(Image)(button.downSkin).textureSmoothing = TextureSmoothing.NONE;
			
			(button.defaultSkin as Image).scale9Grid = new Rectangle(2, 0, 2, _defaultListBtnTex.frameHeight);
			(button.downSkin as Image).scale9Grid = new Rectangle(2, 0, 2, _downListBtnTex.frameHeight);
			
			button.labelFactory = function():ITextRenderer
			{
				var textField:TextFieldTextRenderer = new TextFieldTextRenderer();
				textField.textFormat = new TextFormat("ComicFont", button.fontSize, 0x0);
				textField.embedFonts = false;
				return textField;
			};
		}
		
		/**透明ボタン*/
		protected function setTouchBtn(button:Button):void
		{
			if (_btnTex == null)
			{
				_btnTex = Texture.fromBitmapData(new BitmapData(4, 4, true, 0x0));
			}
			button.defaultSkin = new Image(_btnTex);
		}
		
		/**リストボタンサブ*/
		protected function setListBtnSub(button:Button):void
		{
			
			if (_downListBtnTex == null)
			{
				_downListBtnTex = MainController.$.imgAsset.getTexture("btn_list_sub");
			}
			
			(button.defaultSkin as Image).scale9Grid = new Rectangle(2, 0, 2, _downListBtnTex.frameHeight);
			button.labelFactory = function():ITextRenderer
			{
				var textField:TextFieldTextRenderer = new TextFieldTextRenderer();
				textField.textFormat = new TextFormat("Font Bold", 16, 0x0);
				textField.embedFonts = false;
				return textField;
			};
		}
		
		/**テキスト表示*/
		protected function setTextArea(textArea:TextArea):void
		{
			
			if (_textBackTex == null)
			{
				_textBackTex = Texture.fromBitmapData(new BitmapData(24, 24, true, 0x88FFFFFF))
			}
			
			textArea.backgroundSkin = new Image(_textBackTex);
			textArea.isEditable = false;
			textArea.touchable = false;
			textArea.textEditorFactory = function():ITextEditorViewPort
			{
				var editor:TextFieldTextEditorViewPort = new TextFieldTextEditorViewPort();
				editor.styleProvider = null;
				editor.textFormat = new TextFormat("ComicFont", 24, 0x6666FF);
				editor.embedFonts = true;
				//editor.pivotX = -6;
				return editor;
			}
		}
		
		
		/**テキスト表示*/
		protected function setNovelTextArea(textArea:CTextArea):void
		{
			if (textArea.backTex != null)
			{
				textArea.backgroundSkin = new Image(textArea.backTex);
			}
			textArea.isEditable = textArea.input;
			textArea.touchable = textArea.input;
			textArea.textEditorFactory = function():ITextEditorViewPort
			{
				var editor:TextFieldTextEditorViewPort = new TextFieldTextEditorViewPort();
				editor.styleProvider = null;
				editor.textFormat = new TextFormat("ComicFont", textArea.textSize, textArea.textColor);
				editor.textFormat.align = textArea.align;
				editor.embedFonts = true;
				editor.multiline = textArea.multiLine;
				//editor.pivotX = -6;
				return editor;
			}
		}
		
		
		/**テキスト表示*/
		protected function setWeaponTextArea(textArea:CTextArea):void
		{
			
			if (_textBackTex == null)
			{
				_textBackTex = Texture.fromBitmapData(new BitmapData(24, 24, true, 0x00FFFFFF))
			}
			
			textArea.backgroundSkin = new Image(_textBackTex);
			textArea.isEditable = false;
			textArea.touchable = false;
			textArea.textEditorFactory = function():ITextEditorViewPort
			{
				var editor:TextFieldTextEditorViewPort = new TextFieldTextEditorViewPort();
				editor.styleProvider = null;
				editor.textFormat = new TextFormat("ComicFont", textArea.textSize, textArea.textColor);
				editor.textFormat.align = textArea.align;
				editor.embedFonts = true;
				//editor.pivotX = -6;
				return editor;
			}
		}
		
		/**テキスト表示*/
		protected function setListTextArea(textArea:TextArea):void
		{
			
			if (_textBackTex == null)
			{
				_textBackTex = Texture.fromBitmapData(new BitmapData(24, 24, true, 0x00FFFFFF))
			}
			
			textArea.backgroundSkin = new Image(_textBackTex);
			textArea.isEditable = false;
			textArea.touchable = false;
			textArea.textEditorFactory = function():ITextEditorViewPort
			{
				var editor:TextFieldTextEditorViewPort = new TextFieldTextEditorViewPort();
				editor.styleProvider = null;
				editor.textFormat = new TextFormat("ComicFont", 18, 0xFF6688);
				editor.embedFonts = true;
				//editor.pivotX = -6;
				return editor;
			}
		}
		
		/**テキスト表示*/
		protected function setMessageText(textArea:TextArea):void
		{
			
			if (_mstTextBackTex == null)
			{
				_mstTextBackTex = Texture.fromBitmapData(new BitmapData(24, 24, true, 0x888888FF));
			}
			
			textArea.backgroundSkin = new Image(_mstTextBackTex);
			textArea.isEditable = false;
			textArea.touchable = false;
			textArea.textEditorFactory = function():ITextEditorViewPort
			{
				var editor:TextFieldTextEditorViewPort = new TextFieldTextEditorViewPort();
				editor.styleProvider = null;
				editor.textFormat = new TextFormat("ComicFont", 24, 0xFFFFFF);
				editor.embedFonts = true;
				//editor.pivotX = -6;
				return editor;
			}
		}
		
		
		
		
		/**テキスト表示*/
		protected function setNamePlate(textArea:TextArea):void
		{
			/*
			if (_namePlateTex == null)
			{
				_namePlateTex = Texture.fromBitmap(new img_nameplate);
			}
			*/
			
			//textArea.backgroundSkin = new Image(_namePlateTex);
			//(textArea.backgroundSkin as Image).scale9Grid = new Rectangle(4, 0, 4, 24);
			textArea.isEditable = false;
			textArea.touchable = false;
						
			var _dropShadow:DropShadowFilter = new DropShadowFilter(2, 0.785, 0x0, 1, 0, 0.5);
			textArea.filter = _dropShadow;
			
			textArea.textEditorFactory = function():ITextEditorViewPort
			{
				var editor:TextFieldTextEditorViewPort = new TextFieldTextEditorViewPort();
				editor.styleProvider = null;
				//editor.textFormat = new TextFormat( "_sans", 12, 0x333333 );
				editor.textFormat = new TextFormat("ComicFont", 24, 0xF5F5DC, null, null, null, null, null, TextFormatAlign.LEFT);
				editor.embedFonts = true;
				editor.pivotY = -1;
				return editor;
			}
		}
		
		/**テキスト表示*/
		protected function setScrollMessageText(textArea:ScrollText):void
		{
			//textArea.backgroundSkin = Image.fromBitmap(new Bitmap(new BitmapData(24, 24, true, 0x888888FF)));
			//textArea.hori = false;
			textArea.touchable = false;
			textArea.textFormat = new TextFormat("ComicFont", 22, 0xFFFFFF);
			textArea.embedFonts = true;
		/*
		   textArea.textFormat = function():ITextEditorViewPort
		   {
		   var editor:TextFieldTextEditorViewPort = new TextFieldTextEditorViewPort();
		   editor.textFormat = new TextFormat("ComicFont", 24, 0xFFFFFF);
		   editor.embedFonts = true;
		   //editor.pivotX = -6;
		   return editor;
		   }
		 */
		}
		
		
		/**テキスト表示*/
		protected function setDefaultScrollMessageText(textArea:ScrollText):void
		{
		}
		
		protected function setImgBtn(btn:Button):void
		{
			
		}
	
	}
}