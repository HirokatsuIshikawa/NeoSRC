package scene.intermission.save
{
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CButton;
	import system.custom.customSprite.CSprite;
	import system.custom.customSprite.CTextArea;
	import flash.text.TextFormatAlign;
	import starling.display.Image;
	import starling.events.Event;
	import main.MainController;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class ConfirmPopup extends CSprite
	{
		/**暗幕画像*/
		private var _backImg:Image = null;
		/**ポップアップメッセージ*/
		private var _text:CTextArea = null;
		/**確認ボタン*/
		private var _comfirmBtn:CButton = null;
		
		/**コンストラクタ*/
		public function ConfirmPopup(msg:String, btnMsg:String = "OK")
		{
			super();
			//暗幕設定
			_backImg = new Image(MainController.$.imgAsset.getTexture("tex_black"));
			_backImg.alpha = 0.8;
			_backImg.width = CommonDef.WINDOW_W;
			_backImg.height = CommonDef.WINDOW_H;
			addChild(_backImg);
			
			//メッセージ設定
			_text = new CTextArea(32, 0xFFFFFF, 0x0, TextFormatAlign.CENTER);
			_text.styleName = "custom_text";
			_text.width = 480;
			_text.height = 160;
			_text.text = msg;
			_text.x = (CommonDef.WINDOW_W - _text.width) / 2;
			_text.y = (CommonDef.WINDOW_H - _text.height) / 2 - 80;
			addChild(_text);
			
			//ボタン設定
			_comfirmBtn = new CButton();
			_comfirmBtn.styleName = "bigBtn";
			_comfirmBtn.label = btnMsg;
			_comfirmBtn.width = 240;
			_comfirmBtn.height = 180;
			_comfirmBtn.x = (CommonDef.WINDOW_W - _comfirmBtn.width) / 2;
			_comfirmBtn.y = (CommonDef.WINDOW_H - _comfirmBtn.height) / 2 + 120;
			_comfirmBtn.addEventListener(Event.TRIGGERED, pushBtn);
			addChild(_comfirmBtn);
		
		}
		
		/**ボタン押下処理*/
		public function pushBtn(event:Event):void
		{
			this.parent.removeChild(this);
			dispose();
		}
		
		/**廃棄*/
		override public function dispose():void
		{
			
			if (_backImg != null)
			{
				_backImg.dispose();
				_backImg = null;
			}
			
			if (_text != null)
			{
				_text.dispose();
				_text = null;
			}
			
			if (_comfirmBtn != null)
			{
				_comfirmBtn.removeEventListener(Event.TRIGGERED, pushBtn);
				_comfirmBtn.dispose();
				_comfirmBtn = null;
			}
			
			super.dispose();
		}
	
	}

}