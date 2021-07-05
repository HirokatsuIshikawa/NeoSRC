package viewitem.status.list
{
	import common.CommonDef;
    import feathers.controls.Slider;
	import system.custom.customSprite.CButton;
	import database.user.UnitCharaData;
	import starling.events.Event;
	import main.MainController;
    import system.custom.customSprite.CImage;
    import system.custom.customSprite.CImgButton;
    import system.custom.customSprite.CSprite;
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
		private var _closeBtn:CImgButton = null;
        
		
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
				_listContena.addChild(_itemList[count]);
				count++;
			}
			
            setSlider(_itemList.length);
            
            //閉じるボタン            
            _closeBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_Return"));
            _closeBtn.x = 960 - 96;
            _closeBtn.y = 460;
            _closeBtn.width = 96;
            _closeBtn.height = 64;
			_closeBtn.addEventListener(Event.TRIGGERED, MainController.$.view.interMission.closeStrengthList);
			addChild(_closeBtn);
		}
		
		override public function dispose():void
		{
			if (_itemList != null)
            {
                for (var i:int = 0; i < _itemList.length; i++)
                {
                    this.removeChild(_itemList[i]);
                    _itemList[i].dispose();
                    _itemList[i] = null;
                }
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
				
		public function get itemList():Vector.<StrengthListItem>
		{
			return _itemList;
		}
	
	}

}