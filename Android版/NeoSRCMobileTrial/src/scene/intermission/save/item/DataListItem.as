package scene.intermission.save.item
{
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CButton;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CImgButton;
	import system.custom.customSprite.CTextArea;
	import flash.geom.Rectangle;
	import scene.main.MainController;
	import viewitem.status.list.listitem.ListItemBase;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class DataListItem extends ListItemBase
	{
		
		public static const LIST_WIDTH:int = 480;
		public static const LIST_HEIGHT:int = 160;
		
		protected var _noText:CTextArea = null;
		protected var _timeText:CTextArea = null;
		protected var _clearText:CTextArea = null;
		protected var _saveBtn:CImgButton = null;
		
		public function DataListItem()
		{;
			super(LIST_WIDTH, LIST_HEIGHT);
			
			_noText = new CTextArea(18,0xFF4444);
			_noText.styleName = "custom_text";
			_noText.text = "空きデータ";
			_noText.x = 20;
			_noText.y = 20;
			_noText.width = LIST_WIDTH;
			_noText.height = LIST_HEIGHT;
			addChild(_noText);
			
			_clearText = new CTextArea(18,0xFFFFFF);
			_clearText.styleName = "custom_text";
			_clearText.text = "";
			_clearText.x = 20;
			_clearText.y = 60;
			_clearText.width = LIST_WIDTH;
			_clearText.height = LIST_HEIGHT;
			addChild(_clearText);
			
			_timeText = new CTextArea(18,0xFFFFFF);
			_timeText.styleName = "custom_text";
			_timeText.text = "";
			_timeText.x = 20;
			_timeText.y = 100;
			_timeText.width = LIST_WIDTH;
			_timeText.height = LIST_HEIGHT;
			addChild(_timeText);
			
			
			_saveBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_listsave"));
			_saveBtn.x = LIST_WIDTH - 96 - 20;
			_saveBtn.y = LIST_HEIGHT / 2 - 32;
			_saveBtn.width = 96;
			_saveBtn.height = 64;
			addChild(_saveBtn);
		
		}
		
		override public function dispose():void
		{
			if (_noText != null)
			{
				_noText.dispose();
				_noText = null;
			}
			
			if (_timeText != null)
			{
				_timeText.dispose();
				_timeText = null;
			}
			
			if (_saveBtn != null)
			{
				_saveBtn.dispose();
				_saveBtn = null;
			}
			
			super.dispose();
		}
		
		public function setEnable(flg:Boolean):void
		{
			if (flg)
			{
				
				_listImg.texture = MainController.$.imgAsset.getTexture("listitem");
			}
			else
			{
				
				_listImg.texture = MainController.$.imgAsset.getTexture("emptylistitem");
			}
		}
	
	}

}