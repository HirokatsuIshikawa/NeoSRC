package scene.talk.message
{
	import common.CommonDef;
	import common.util.CharaDataUtil;
	import system.custom.customSprite.CSprite;
	import database.master.MasterCharaData;
	import database.user.FaceData;
	import feathers.controls.ScrollText;
	import feathers.controls.TextArea;
	import flash.filters.DropShadowFilter;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.TextureSmoothing;
	import main.MainController;
	
	/**
	 * ...
	 * @author
	 */
	public class SystemWindow extends CSprite
	{
		
		/**背景画像*/
		private var _backImg:Image = null;
		/**テキスト表示エリア*/
		private var _textArea:ScrollText = null;
		
		private var _namePlate:Image = null;
		
		private var _nameTxt:TextArea = null;
		
		private var _charaName:String = null;
		
		public function SystemWindow()
		{
			super();
			
			_backImg = new Image(CommonDef.MSG_BACK_TEX);
			_backImg.width = 800;
			_backImg.height = 160;
			_backImg.textureSmoothing = TextureSmoothing.NONE;
			addChild(_backImg);
			
			_nameTxt = new TextArea();
			_nameTxt.styleName = "nameplate";
			_nameTxt.text = "";
			_nameTxt.width = 128;
			_nameTxt.height = 28;
			_nameTxt.x = 16;
			_nameTxt.y = 148;
			addChild(_nameTxt);
			
			//テキスト表示領域
			_textArea = new ScrollText();
			_textArea.isHTML = true;
			_textArea.styleName = "message_window";
			_textArea.text = "";
			_textArea.x = 160;
			_textArea.y = 16;
			
			//var dropShadowFilter:DropShadowFilter = new DropShadowFilter();
			//var dropShadowFilter:DropShadowFilter = new DropShadowFilter(2,0,0,1,1,1,1,1,false,false,false);
			//var ary:Array = [dropShadowFilter];
			//_textArea.textViewPort.textField.filters = ary;
			
			_textArea.width = 640;
			_textArea.minHeight = 132;
			_textArea.maxHeight = 132;
			
			this.addChild(_textArea);
			
			addChild(_nameTxt);
		
		}
		
		public function setImage(name:String):void
		{
			_charaName = name;
			//var selectData:MasterCharaData = CharaDataUtil.getMasterCharaDataName(name);
			var mask:Quad = null;
			
			var imgData:FaceData = MainController.$.model.getCharaImgDataFromName(name);
			
			
			switch (imgData.defaultType)
			{
			case "stand": 
				mask = new Quad(160, imgData.addPoint.y);
				mask.x = 0;
				mask.y = 160 - imgData.addPoint.y;
				break;
			case "icon": 
				break;
			}
			
			_nameTxt.text = name;
		}
		
		override public function dispose():void
		{
			//_textArea.textViewPort.textField.filters = null;
			super.dispose();
		}
		
		override public function set alpha(value:Number):void
		{
			super.alpha = value;
			CONFIG::phone
			{
				_textArea.alpha = value;
			}
		}
		
		/**メッセージ追加*/
		public function addText(str:String):void
		{
			_textArea.text += str;
			trace(str);
		}
		
		public function clearText():void
		{
			_textArea.text = "";
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