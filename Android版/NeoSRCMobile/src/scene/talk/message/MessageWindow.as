package scene.talk.message
{
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CSprite;
	import feathers.controls.ScrollText;
	import feathers.controls.TextArea;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import scene.main.MainController;
	
	/**
	 * ...
	 * @author
	 */
	public class MessageWindow extends CSprite
	{
		
		/**背景画像*/
		protected var _backImg:CImage = null;
		/**テキスト表示エリア*/
		protected var _textArea:ScrollText = null;
		
		protected var _nameTxt:TextArea = null;
		
		protected var _charaName:String = null;
		
		protected static var _dropShadow:DropShadowFilter = null;
		
		
		public function MessageWindow()
		{
			super();
			
			var tex:Texture = MainController.$.imgAsset.getTexture("msg_window_b");
			_backImg = new CImage(tex);
			_backImg.scale9Grid = new Rectangle(8, 24, 10, 4);
			_backImg.width = 600;
			_backImg.height = 140;
			_backImg.textureSmoothing = TextureSmoothing.NONE;
			addChild(_backImg);
			
			_nameTxt = new TextArea();
			_nameTxt.styleName = "nameplate";
			_nameTxt.text = "";
			_nameTxt.width = 540;
			_nameTxt.height = 28;
			_nameTxt.x = 16;
			_nameTxt.y = 0;
			addChild(_nameTxt);
						
			//テキスト表示領域
			_textArea = new ScrollText();
			_textArea.isHTML = true;
			_textArea.styleName = "message_window";
			_textArea.text = "";
			_textArea.x = 8;
			_textArea.y = 28;
			
			/*
			if (_dropShadow == null)
			{
				_dropShadow = new DropShadowFilter(1, 45, 0, 1, 4, 4, 1, 1, false, false, false);
			}
			var ary:Array = [_dropShadow];
			_textArea.textViewPort.textField.filters = ary;
			*/
			
			_textArea.width = 560;
			_textArea.minHeight = 96;
			_textArea.maxHeight = 96;
			
			this.addChild(_textArea);
			
			addChild(_nameTxt);
			
		}
		
		public function setName(name:String):void
		{
			if (name === "システム")
			{
				_charaName = "";
				_nameTxt.text = "";
			}
			else
			{
				_charaName = name;
				//var selectData:MasterCharaData = CharaDataUtil.getMasterCharaDataName(name);
				_nameTxt.text = name;
			}
		}
		
		override public function dispose():void
		{
			//_textArea.textViewPort.textField.filters = null;
			_backImg.dispose();
			_nameTxt.dispose();
			super.dispose();
		}
		
		override public function set alpha(value:Number):void
		{
			super.alpha = value;
			CONFIG::phone
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
				
		public function deleteText():void
		{
			_textArea.text = "";
			_nameTxt.text = "";
		}
		
		
		public function get textArea():ScrollText
		{
			return _textArea;
		}
		
		public function get charaName():String 
		{
			return _charaName;
		}
	
	}
}