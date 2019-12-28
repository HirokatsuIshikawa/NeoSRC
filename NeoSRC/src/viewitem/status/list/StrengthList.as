package viewitem.status.list
{
	import common.CommonDef;
	import system.custom.customSprite.CButton;
	import database.user.UnitCharaData;
	import starling.events.Event;
	import scene.main.MainController;
	import viewitem.parts.numbers.ImgNumber;
	import viewitem.status.list.listitem.StrengthListItem;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class StrengthList extends UnitListBase
	{
		/**暗幕画像*/
		private var _itemList:Vector.<StrengthListItem> = null;
		private var _closeBtn:CButton = null;
		
		public function StrengthList(datalist:Vector.<UnitCharaData>)
		{
			super();
			
			_itemList = new Vector.<StrengthListItem>;
			var count:int = 0;
			for (var i:int = 0; i < datalist.length; i++)
			{
				if (datalist[i].launched)
				{
					continue;
				}
				
				_itemList[count] = new StrengthListItem(datalist[i]);
				_itemList[count].x = 60 + (StrengthListItem.LIST_WIDTH + 40) * (int)(count % 3);
				_itemList[count].y = (StrengthListItem.LIST_HEIGHT + 24) * (int)(count / 3);
				this.addChild(_itemList[count]);
				count++;
			}
			
			_closeBtn = new CButton();
			_closeBtn.label = "閉じる";
			_closeBtn.styleName = "bigBtn";
			_closeBtn.x = 780;
			_closeBtn.y = 360;
			_closeBtn.width = 160;
			_closeBtn.height = 160;
			_closeBtn.addEventListener(Event.TRIGGERED, MainController.$.view.interMission.closeStrengthList);
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
			
			if (_closeBtn != null)
			{
				removeChild(_closeBtn);
				_closeBtn.removeEventListener(Event.TRIGGERED, MainController.$.view.interMission.closeStrengthList);
				_closeBtn.dispose();
			}
			_closeBtn = null;
			
			super.dispose();
		}
		
		private function close(e:Event):void
		{
			MainController.$.map.startOrganized();
		}
		
		public function get itemList():Vector.<StrengthListItem>
		{
			return _itemList;
		}
	
	}

}