package viewitem.status.list
{
	import common.CommonDef;
	import system.custom.customSprite.CButton;
	import system.custom.customSprite.CImage;
	import database.user.UnitCharaData;
	import starling.events.Event;
	import main.MainController;
	import system.custom.customSprite.CSprite;
	import viewitem.parts.numbers.ImgNumber;
	import viewitem.status.list.UnitListBase;
	import viewitem.status.list.listitem.OrganizeListItem;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class OrganizeList extends UnitListBase
	{
		
		public static const TYPE_UNIQUE:String = "UNIQUE";
		public static const TYPE_GENERIC:String = "GENERIC";
		public static const TYPE_UNIQUE_J:String = "ユニーク";
		public static const TYPE_GENERIC_J:String = "汎用";
		
		/**暗幕画像*/
		private var _itemList:Vector.<OrganizeListItem> = null;
		private var _genericItemList:Vector.<OrganizeListItem> = null;
		private var _uniqueBtn:CButton = null;
		private var _genericBtn:CButton = null;
		private var _startBtn:CButton = null;
		private var _organizeCount:ImgNumber = null;
		
		private var _uniqueSpr:CSprite = null;
		private var _genericSpr:CSprite = null;
		
		private var _unitCount:int = 0;
		private var _posX:int = 0;
		private var _posY:int = 0;
		private var _uWidth:int = 0;
		private var _uHeight:int = 0;
		
		public function OrganizeList(datalist:Vector.<UnitCharaData>, count:int, posX:int, posY:int, uWidth:int, uHeight:int, type:String, cost:int)
		{
			super();
			var i:int = 0;
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
			
			if (type.indexOf(TYPE_UNIQUE) >= 0 || type.indexOf(TYPE_UNIQUE_J) >= 0)
			{
				_uniqueSpr = new CSprite();
				_itemList = new Vector.<OrganizeListItem>;
				
				for (i = 0; i < datalist.length; i++)
				{
					if (datalist[i].launched)
					{
						continue;
					}
					
					_itemList[i] = new OrganizeListItem(datalist[i]);
					_itemList[i].x = 60 + (OrganizeListItem.LIST_WIDTH + 40) * (int)(i % 3);
					_itemList[i].y = (OrganizeListItem.LIST_HEIGHT + 24) * (int)(i / 3);
					_uniqueSpr.addChild(_itemList[i]);
				}
				this.addChild(_uniqueSpr);
			}
			
			if (type.indexOf(TYPE_GENERIC) >= 0 || type.indexOf(TYPE_GENERIC_J) >= 0)
			{
				_genericSpr = new CSprite();
				_genericItemList = new Vector.<OrganizeListItem>;
				
				for (i = 0; i < datalist.length; i++)
				{
					if (datalist[i].launched)
					{
						continue;
					}
					
					_genericItemList[i] = new OrganizeListItem(datalist[i]);
					_genericItemList[i].x = 60 + (OrganizeListItem.LIST_WIDTH + 40) * (int)(i % 3);
					_genericItemList[i].y = (OrganizeListItem.LIST_HEIGHT + 24) * (int)(i / 3);
					_genericSpr.addChild(_genericItemList[i]);
				}
				
				this.addChild(_genericSpr);
			}
			_startBtn = new CButton();
			_startBtn.label = "出撃";
			_startBtn.styleName = "bigBtn";
			_startBtn.x = 780;
			_startBtn.y = 480;
			_startBtn.width = 120;
			_startBtn.height = 40;
			_startBtn.addEventListener(Event.TRIGGERED, compOrganized);
			addChild(_startBtn);
			
			//ネームドと汎用を併用する場合
			if ((type.indexOf(TYPE_UNIQUE) >= 0 || type.indexOf(TYPE_UNIQUE_J) >= 0) && (type.indexOf(TYPE_GENERIC) >= 0 || type.indexOf(TYPE_GENERIC_J) >= 0))
			{
				_uniqueBtn = new CButton();
				_uniqueBtn.label = "ユニーク";
				_uniqueBtn.styleName = "bigBtn";
				_uniqueBtn.x = 640;
				_uniqueBtn.y = 480;
				_uniqueBtn.width = 120;
				_uniqueBtn.height = 40;
				_uniqueBtn.addEventListener(Event.TRIGGERED, selectUnique);
				addChild(_uniqueBtn);
				
				_genericBtn = new CButton();
				_genericBtn.label = "汎用";
				_genericBtn.styleName = "bigBtn";
				_genericBtn.x = 500;
				_genericBtn.y = 480;
				_genericBtn.width = 120;
				_genericBtn.height = 40;
				_genericBtn.addEventListener(Event.TRIGGERED, selectGeneric);
				addChild(_genericBtn);
			}
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
			CommonDef.disposeList([_uniqueSpr, _genericSpr]);
			var i:int = 0;
			if (_itemList != null)
			{
				for (i = 0; i < _itemList.length; i++)
				{
					_uniqueSpr.removeChild(_itemList[i]);
					_itemList[i].dispose();
					_itemList[i] = null;
				}
			}
			
			if (_genericItemList != null)
			{
				for (i = 0; i < _genericItemList.length; i++)
				{
					_genericSpr.removeChild(_genericItemList[i]);
					_genericItemList[i].dispose();
					_genericItemList[i] = null;
				}
			}
			
			if (_startBtn != null)
			{
				removeChild(_startBtn);
				_startBtn.removeEventListener(Event.TRIGGERED, compOrganized);
				_startBtn.dispose();
			}
			if (_uniqueBtn != null)
			{
				removeChild(_uniqueBtn);
				_uniqueBtn.removeEventListener(Event.TRIGGERED, selectUnique);
				_uniqueBtn.dispose();
			}
			if (_genericBtn != null)
			{
				removeChild(_genericBtn);
				_genericBtn.removeEventListener(Event.TRIGGERED, selectGeneric);
				_genericBtn.dispose();
			}
			
			_startBtn = null;
			_uniqueBtn = null;
			_genericBtn = null;
			
			super.dispose();
		}
		
		private function compOrganized(e:Event):void
		{
			MainController.$.map.startOrganized();
		}
		
		private function selectUnique(e:Event):void
		{
		
		}
		
		private function selectGeneric(e:Event):void
		{
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