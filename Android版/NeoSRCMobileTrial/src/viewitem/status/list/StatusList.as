package viewitem.status.list
{
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CImgButton;
	import database.user.UnitCharaData;
	import starling.events.Event;
	import scene.main.MainController;
	import viewitem.status.list.UnitListBase;
	import viewitem.status.list.listitem.StatusListItem;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class StatusList extends UnitListBase
	{
		/**暗幕画像*/
		private var _itemList:Vector.<StatusListItem> = null;
		private var _closeBtn:CImgButton = null;
		
		public function StatusList(datalist:Vector.<UnitCharaData>)
		{
			super();
			
			_itemList = new Vector.<StatusListItem>;
			
			for (var i:int = 0; i < datalist.length; i++)
			{
				_itemList[i] = new StatusListItem(datalist[i]);
				_itemList[i].x = 60 + (StatusListItem.LIST_WIDTH + 40) * (int)(i % 3);
				_itemList[i].y = (StatusListItem.LIST_HEIGHT + 24) * (int)(i / 3);
				this.addChild(_itemList[i]);
			}
			
			_closeBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_Return"));
			_closeBtn.x = 780;
			_closeBtn.y = 360;
			_closeBtn.width = 96;
			_closeBtn.height = 64;
			_closeBtn.addEventListener(Event.TRIGGERED, MainController.$.view.interMission.closeStatusList);
			addChild(_closeBtn);
		}
		
		override public function dispose():void
		{
			
			for (var i:int = 0; i < _itemList.length; i++)
			{
				this.removeChild(_itemList[i]);
				_itemList[i].dispose();
				_itemList[i] = null;
			}
			
			if (_closeBtn)
			{
				removeChild(_closeBtn);
				_closeBtn.removeEventListener(Event.TRIGGERED, MainController.$.view.interMission.closeStatusList);
				_closeBtn.dispose();
			}
			_closeBtn = null;
			
			super.dispose();
		}
	
	}

}