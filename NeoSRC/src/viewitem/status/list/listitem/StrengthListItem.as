package viewitem.status.list.listitem
{
	import common.CommonSystem;
	import common.util.CharaDataUtil;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CTextArea;
	import database.master.MasterCharaData;
	import database.user.UnitCharaData;
	import feathers.controls.TextArea;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.TextureSmoothing;
	import main.MainController;
	import viewitem.status.list.listitem.ListItemBase;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class StrengthListItem extends ListItemBase
	{
		public static const LIST_WIDTH:int = 240;
		public static const LIST_HEIGHT:int = 104;
		public static const ICON_SIZE:int = 96;
		
		/**ユニットデータ*/
		private var _data:UnitCharaData = null;
		/**ユニット画像*/
		private var _unitImg:CImage = null;
		/**名前エリア*/
		private var _nameTxt:CTextArea = null;
		/**強化段階*/
		private var _strengthTxt:CTextArea = null;
		
		public function StrengthListItem(data:UnitCharaData)
		{
			super(LIST_WIDTH, LIST_HEIGHT);
			var i:int = 0;
			_data = data;
			
			//マスターキャラデータ取得
			var charaData:MasterCharaData = CharaDataUtil.getMasterCharaDataName(data.name);
			
			//_unitImg = new CImage(TextureManager.loadUnitNameTexture(charaData.unitsImgName, TextureManager.TYPE_UNIT));
			
			_unitImg = new CImage(MainController.$.imgAsset.getTexture(charaData.unitsImgName));
			
			_unitImg.x = 4;
			_unitImg.y = 4;
			_unitImg.width = ICON_SIZE;
			_unitImg.height = ICON_SIZE;
			_unitImg.textureSmoothing = TextureSmoothing.NONE;
			
			_nameTxt = new CTextArea();
			_nameTxt.styleName = "list_text";
			_nameTxt.x = 112;
			_nameTxt.y = 40;
			_nameTxt.width = 120;
			_nameTxt.text = charaData.name;

			_strengthTxt = new CTextArea();
			_strengthTxt.styleName = "list_text";
			_strengthTxt.x = 112;
			_strengthTxt.y = 64;
			_strengthTxt.width = 120;
			_strengthTxt.text = "+" + data.strengthPoint;
			
			if (data.strengthPoint < CommonSystem.STRENGTH_MONEY.length)
			{
				this.addEventListener(TouchEvent.TOUCH, clickHandler);
				_unitImg.color = 0xFFFFFF;
			}
			else
			{
				_unitImg.color = 0x888888;
			}
			
			addChild(_unitImg);
			addChild(_nameTxt);
			addChild(_strengthTxt);
			
		}
		
		override public function dispose():void
		{
			
			removeChild(_unitImg);
			_unitImg.dispose();
			_unitImg = null;
			
			removeChild(_nameTxt);
			_nameTxt.dispose();
			_nameTxt = null;
			
			this.removeEventListener(TouchEvent.TOUCH, clickHandler);
			super.dispose();
		}
		
		private function clickHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			//タッチしているか
			if (touch)
			{
				//クリック上げた時
				switch (touch.phase)
				{
				//ボタン離す
				case TouchPhase.ENDED: 
					MainController.$.view.interMission.callStrengthWindow(_data);
					break;
				//マウスオーバー
				case TouchPhase.HOVER: 
					break;
				case TouchPhase.STATIONARY: 
					break;
				//ドラッグ
				case TouchPhase.MOVED: 
					break;
				//押した瞬間
				case TouchPhase.BEGAN: 
					break;
				}
			}
			else
			{
				//_listImg.color = 0xFFFFFF;
			}
		}	
	}
}