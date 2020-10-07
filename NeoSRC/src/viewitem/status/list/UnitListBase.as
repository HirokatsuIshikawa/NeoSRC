package viewitem.status.list
{
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CSprite;
	import database.user.UnitCharaData;
	import main.MainController;
	import viewitem.status.list.listitem.StatusListItem;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class UnitListBase extends CSprite
	{
		/**暗幕画像*/
		private var _backImg:CImage = null;
		private var _itemList:Vector.<StatusListItem> = null;
		
		public function UnitListBase()
		{
			super();
			
			//暗幕設定
			_backImg = new CImage(MainController.$.imgAsset.getTexture("tex_black"));
			_backImg.alpha = 0.8;
			_backImg.width = CommonDef.WINDOW_W;
			_backImg.height = CommonDef.WINDOW_H;
			addChild(_backImg);
		
		}
	}

}