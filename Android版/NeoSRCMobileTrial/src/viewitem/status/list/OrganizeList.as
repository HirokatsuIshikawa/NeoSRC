package viewitem.status.list
{
	import common.CommonDef;
	import system.custom.customSprite.CButton;
	import system.custom.customSprite.CImage;
	import database.user.UnitCharaData;
	import starling.events.Event;
	import scene.main.MainController;
	import viewitem.parts.numbers.ImgNumber;
	import viewitem.status.list.UnitListBase;
	import viewitem.status.list.listitem.OrganizeListItem;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class OrganizeList extends UnitListBase
	{
		/**暗幕画像*/
		private var _itemList:Vector.<OrganizeListItem> = null;
		private var _startBtn:CButton = null;
		private var _organizeCount:ImgNumber = null;
		
		private var _unitCount:int = 0;
		private var _posX:int = 0;
		private var _posY:int = 0;
		private var _uWidth:int = 0;
		private var _uHeight:int = 0;
		
		public function OrganizeList(datalist:Vector.<UnitCharaData>, count:int, posX:int, posY:int, uWidth:int, uHeight:int)
		{
			super();
			
			/**出撃領域に収まらない場合*/
			var num:int = (int)(Math.ceil(uWidth * uHeight / 2.0));
			if (num < count)
			{
				count = num;
			}
			
			
			_unitCount = count;
			_posX = posX;
			_posY = posY;
			_uWidth = uWidth;
			_uHeight = uHeight;
			
			_itemList = new Vector.<OrganizeListItem>;
			
			for (var i:int = 0; i < datalist.length; i++)
			{
				if (datalist[i].launched)
				{
					continue;
				}
				
				_itemList[i] = new OrganizeListItem(datalist[i]);
				_itemList[i].x = 60 + (OrganizeListItem.LIST_WIDTH + 40) * (int)(i % 3);
				_itemList[i].y = (OrganizeListItem.LIST_HEIGHT + 24) * (int)(i / 3);
				this.addChild(_itemList[i]);
			}
			
			_startBtn = new CButton();
			_startBtn.label = "出撃";
			_startBtn.styleName = "bigBtn";
			_startBtn.x = 780;
			_startBtn.y = 360;
			_startBtn.width = 160;
			_startBtn.height = 160;
			_startBtn.addEventListener(Event.TRIGGERED, compOrganized);
			addChild(_startBtn);
			
			_organizeCount = new ImgNumber();
			_organizeCount.x = 20;
			_organizeCount.y = CommonDef.WINDOW_H - 48;
			checkOrganize();
		}
		
		public function checkOrganize():void
		{
			var count:int = 0;
			var i:int = 0;
			for (i = 0; i < _itemList.length; i++)
			{
				if (_itemList[i].selected)
				{
					count++;
				}
			}
			
			if (count <= 0 || count > _unitCount)
			{
				_startBtn.isEnabled = false;
				_startBtn.alpha = 0.7;
			}
			else
			{
				_startBtn.isEnabled = true;
				_startBtn.alpha = 1;
			}
			
			_organizeCount.setMaxNumber(count, _unitCount);
			addChild(_organizeCount);
		}
		
		override public function dispose():void
		{
			
			for (var i:int = 0; i < _itemList.length; i++)
			{
				this.removeChild(_itemList[i]);
				_itemList[i].dispose();
				_itemList[i] = null;
			}
			
			if (_startBtn != null)
			{
				removeChild(_startBtn);
				_startBtn.removeEventListener(Event.TRIGGERED, compOrganized);
				_startBtn.dispose();
			}
			_startBtn = null;
			
			super.dispose();
		}
		
		
		private function compOrganized(e:Event):void
		{
			MainController.$.map.startOrganized();
		}
		
		public function get posX():int 
		{
			return _posX;
		}
		
		public function get posY():int 
		{
			return _posY;
		}
		
		public function get itemList():Vector.<OrganizeListItem> 
		{
			return _itemList;
		}
		
		public function get uWidth():int 
		{
			return _uWidth;
		}
		
		public function get uHeight():int 
		{
			return _uHeight;
		}
	
	}

}