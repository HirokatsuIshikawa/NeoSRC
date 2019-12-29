package custom
{
	import feathers.controls.Button;
	import feathers.controls.NumericStepper;
	import feathers.controls.Slider;
	import feathers.controls.TextArea;
	import feathers.controls.TextInput;
	import feathers.controls.ToggleButton;
	import feathers.controls.text.ITextEditorViewPort;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.controls.text.TextFieldTextEditorViewPort;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextEditor;
	import feathers.core.ITextRenderer;
	import feathers.themes.MetalWorksMobileTheme;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import starling.display.Image;
	import starling.events.*;
	import starling.textures.Texture;
	import system.UserImage;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class CustomTheme extends MetalWorksMobileTheme
	{


		
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
		//[Embed(source='../../asset/font/f910-shin-comic-2.otf',fontName='ComicFont',embedAsCFF='false')]
		//public static const ComicFont:Class;
		
		/**コンストラクタ*/
		public function CustomTheme()
		{
			super();
		}
		
		/**スタイル初期化*/
		override protected function initializeStyleProviders():void
		{
			super.initializeStyleProviders(); // don't forget this!
			
			this.getStyleProviderForClass(Button).defaultStyleFunction = this.setListBtnMain;
			this.getStyleProviderForClass(Button).setFunctionForStyleName("iconBtn", this.setIconBtn);
			this.getStyleProviderForClass(TextArea).defaultStyleFunction = this.setTextArea;
			this.getStyleProviderForClass(TextInput).defaultStyleFunction = this.setTextInput;
			this.getStyleProviderForClass(Button).setFunctionForStyleName("slideBtn", this.setSlideBtn);
			this.getStyleProviderForClass(Slider).defaultStyleFunction = this.setSlider;
			this.getStyleProviderForClass(ToggleButton).defaultStyleFunction = this.setToggleBtn;

			this.getStyleProviderForClass(TextArea).setFunctionForStyleName("defText", this.setDefTextArea);
			
			this.getStyleProviderForClass(TextArea).setFunctionForStyleName("titleText", this.setTitleTextArea);
			
			
			this.getStyleProviderForClass(Button).setFunctionForStyleName("stepUp", this.setStepUpBtn);
			this.getStyleProviderForClass(Button).setFunctionForStyleName("stepDown", this.setStepDownBtn);
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName("nameInput", this.setNameInput);
			this.getStyleProviderForClass(TextInput).setFunctionForStyleName("fileInput", this.setBigTextInput);
			
			
			
			this.getStyleProviderForClass(Button).setFunctionForStyleName("tipBtn", this.setTipBtn);
			this.getStyleProviderForClass(NumericStepper).defaultStyleFunction = this.setCustomNumericStepper;
		/*
		   //リストメイン
		   this.getStyleProviderForClass(Button).setFunctionForStyleName("list-main", this.setListBtnMain);
		   //リストサブ
		   this.getStyleProviderForClass(Button).setFunctionForStyleName("list-sub", this.setListBtnSub);
		   //サウンドボタン
		   this.getStyleProviderForClass(Button).setFunctionForStyleName("btn-sound", this.setBtnSound);
		
		   //切り替えボタン
		   this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName("btn-onoff", this.setOnOffStyles);
		 */
		}
		
		/**リストボタンメイン*/
		protected function setTipBtn(button:Button):void
		{
		}
		
		/**
		 * スライダー背景ボタン
		 */
		protected function setSlideBtn(btn:Button):void
		{
			btn.defaultSkin = new Image(Texture.fromBitmapData(new BitmapData(4, 4, true, 0xFF000000)));
		}
		
		
		/**リストボタンメイン*/
		protected function setListBtnMain(button:Button):void
		{
			var texture:Texture = UserImage.$.getSystemTex("btn_list_main");
			var texture2:Texture = UserImage.$.getSystemTex("btn_list_sub");
			
			//var textures:Scale3Textures = new Scale3Textures(texture, 2, 2);
			//var textures2:Scale3Textures = new Scale3Textures(texture2, 2, 2);
			
			button.defaultSkin = new Image(texture);
			button.downSkin = new Image(texture2);
			(button.defaultSkin as Image).scale9Grid = new Rectangle(2, 0, 2, texture.height);
			(button.downSkin as Image).scale9Grid = new Rectangle(2, 0, 2, texture2.height);
			
			
			button.labelFactory = function():ITextRenderer
			{
				var textField:TextFieldTextRenderer = new TextFieldTextRenderer();
				textField.textFormat = new TextFormat("Font Bold", 16, 0x0);
				textField.embedFonts = false;
				return textField;
			};
		}
		
		
		/**リストボタンメイン*/
		protected function setIconBtn(button:Button):void
		{
			
		}
		
		/**切り替えボタン*/
		protected function setToggleBtn(button:ToggleButton):void
		{
			var texture:Texture = UserImage.$.getSystemTex("btn_list_main");
			var texture2:Texture = UserImage.$.getSystemTex("btn_list_sub");
			
			//var textures:Scale3Textures = new Scale3Textures(texture, 2, 2);
			//var textures2:Scale3Textures = new Scale3Textures(texture2, 2, 2);
			
			button.defaultSkin = new Image(texture);
			button.defaultSelectedSkin = new Image(texture2);
			(button.defaultSkin as Image).scale9Grid = new Rectangle(2, 0, 2, texture.height);
			(button.defaultSelectedSkin as Image).scale9Grid = new Rectangle(2, 0, 2, texture2.height);
			
			button.labelFactory = function():ITextRenderer
			{
				var textField:TextFieldTextRenderer = new TextFieldTextRenderer();
				textField.textFormat = new TextFormat("Font Bold", 16, 0x0);
				textField.embedFonts = false;
				return textField;
			};
		}
		
		
		/**リストボタンサブ*/
		protected function setListBtnSub(button:Button):void
		{			
			var texture:Texture = UserImage.$.getSystemTex("btn_list_sub");
			//var textures:Scale3Textures = new Scale3Textures(texture, 2, 2);
			
			(button.defaultSkin as Image).scale9Grid = new Rectangle(2,0,4,texture.height);
			button.labelFactory = function():ITextRenderer
			{
				var textField:TextFieldTextRenderer = new TextFieldTextRenderer();
				textField.styleProvider = null;
				textField.textFormat = new TextFormat("Font Bold", 16, 0x0);
				textField.embedFonts = false;
				return textField;
			};
		}
		
		/**テキスト表示*/
		protected function setTextArea(textArea:TextArea):void
		{
			textArea.backgroundSkin = new Image(Texture.fromBitmap(new Bitmap(new BitmapData(24, 24, true, 0x88FFFFFF))));
			textArea.isEditable = false;
			textArea.touchable = false;
			textArea.textEditorFactory = function():ITextEditorViewPort
			{
				var editor:TextFieldTextEditorViewPort = new TextFieldTextEditorViewPort();
				editor.styleProvider = null;
				//editor.textFormat = new TextFormat("ComicFont", 18, 0xFF6688);
				editor.textFormat = new TextFormat("Font Bold", 24, 0x6666FF);
				editor.embedFonts = false;
				//editor.pivotX = -6;
				return editor;
			}
		}
		
		
		protected function setDefTextArea(textArea:TextArea):void
		{
			textArea.backgroundSkin = new Image(Texture.fromBitmap(new Bitmap(new BitmapData(24, 24, true, 0xFFFFFFFF))));
			textArea.isEditable = false;
			textArea.touchable = false;
			textArea.textEditorFactory = function():ITextEditorViewPort
			{
				var editor:TextFieldTextEditorViewPort = new TextFieldTextEditorViewPort();
				editor.styleProvider = null;
				//editor.textFormat = new TextFormat("ComicFont", 18, 0xFF6688);
				editor.textFormat = new TextFormat("Font Bold", 16, 0x0);
				editor.embedFonts = false;
				//editor.pivotX = -6;
				return editor;
			}
		}
		
		
		
		protected function setTitleTextArea(textArea:TextArea):void
		{
			textArea.backgroundSkin = new Image(Texture.fromBitmap(new Bitmap(new BitmapData(24, 24, true, 0x0))));
			textArea.isEditable = false;
			textArea.touchable = false;
			textArea.textEditorFactory = function():ITextEditorViewPort
			{
				var editor:TextFieldTextEditorViewPort = new TextFieldTextEditorViewPort();
				editor.styleProvider = null;
				//editor.textFormat = new TextFormat("ComicFont", 18, 0xFF6688);
				editor.textFormat = new TextFormat("Font Bold", 16, 0xFF8888);
				editor.embedFonts = false;
				//editor.pivotX = -6;
				return editor;
			}
		}
		
		
		/** スライダー */
		protected function setSlider(slider:Slider):void
		{
			slider.customMaximumTrackStyleName = "slideBtn";
			slider.customMinimumTrackStyleName = "slideBtn";
			//slider.width = 16;
			//slider.thumbProperties.width = 16;
		}
		
		
		/**捨てっパー*/
		protected function setCustomNumericStepper(stepper:NumericStepper):void
		{
			stepper.buttonLayoutMode = NumericStepper.BUTTON_LAYOUT_MODE_RIGHT_SIDE_VERTICAL;
			stepper.customIncrementButtonStyleName = "stepUp";
			stepper.customDecrementButtonStyleName = "stepDown";
			stepper.customTextInputStyleName = "nameInput";
		}
		
		/**ステッパー上*/
		protected function setStepUpBtn(btn:Button):void
		{
			
			
			btn.defaultSkin = new Image(UserImage.$.getSystemTex("btn_up_n"));
			btn.hoverSkin = new Image(UserImage.$.getSystemTex("btn_up_o"));
			btn.downSkin = new Image(UserImage.$.getSystemTex("btn_up_p"));
			btn.disabledSkin = new Image(UserImage.$.getSystemTex("btn_up_d"));
			
		}
		
		/**ステッパー下*/
		protected function setStepDownBtn(btn:Button):void
		{
			btn.defaultSkin = new Image(UserImage.$.getSystemTex("btn_down_n"));
			btn.hoverSkin = new Image(UserImage.$.getSystemTex("btn_down_o"));
			btn.downSkin = new Image(UserImage.$.getSystemTex("btn_down_p"));
			btn.disabledSkin = new Image(UserImage.$.getSystemTex("btn_down_d"));
		}
		
		
		protected function setTextInput(input:TextInput):void
		{
			input.textEditorFactory = function():ITextEditor
			{
				var stageTextTextEditor:StageTextTextEditor = new StageTextTextEditor();
				stageTextTextEditor.styleProvider = null;
				stageTextTextEditor.autoCorrect = true;
				stageTextTextEditor.color = 0x0;
				
				stageTextTextEditor.fontFamily = "Font Bold";
				stageTextTextEditor.fontSize = 14;
				stageTextTextEditor.multiline = false;
				return stageTextTextEditor;
			}
			input.textEditorProperties.textAlign = "center";
			input.backgroundSkin = new Image(Texture.fromBitmap(new Bitmap(new BitmapData(40, 24, true, 0xFFFFFFFF))));
		}		
		
		
		protected function setBigTextInput(input:TextInput):void
		{
			input.textEditorFactory = function():ITextEditor
			{
				var stageTextTextEditor:StageTextTextEditor = new StageTextTextEditor();
				stageTextTextEditor.styleProvider = null;
				stageTextTextEditor.autoCorrect = true;
				stageTextTextEditor.color = 0x0;
				stageTextTextEditor.textAlign = "top";
				stageTextTextEditor.fontFamily = "Font Bold";
				stageTextTextEditor.fontSize = 14;
				stageTextTextEditor.multiline = true;
				return stageTextTextEditor;
			}
			input.textEditorProperties.textAlign = "left";
			input.backgroundSkin = new Image(Texture.fromBitmap(new Bitmap(new BitmapData(40, 24, true, 0xFFFFFFFF))));
			input.backgroundSkin.touchable = true;
		}		
		
		
		/**入力欄*/
		protected function setNameInput(input:TextInput):void
		{
			input.textEditorFactory = function():ITextEditor
			{
				var stageTextTextEditor:StageTextTextEditor = new StageTextTextEditor();
				stageTextTextEditor.styleProvider = null;
				stageTextTextEditor.autoCorrect = true;
				stageTextTextEditor.color = 0x0;
				
				stageTextTextEditor.fontFamily = "Font Bold";
				stageTextTextEditor.fontSize = 16;
				stageTextTextEditor.multiline = false;
				return stageTextTextEditor;
			}
			input.textEditorProperties.textAlign = "center";
			input.backgroundSkin = new Image(Texture.fromBitmap(new Bitmap(new BitmapData(40, 24, true, 0xFFFFFFFF))));
		}
	
	}
}