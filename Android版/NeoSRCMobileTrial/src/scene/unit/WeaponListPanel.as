package scene.unit
{
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CButton;
	import system.custom.customSprite.CImgButton;
	import system.custom.customSprite.CSprite;
	import database.master.MasterWeaponData;
	import flash.geom.Point;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import scene.main.MainController;
	import scene.map.panel.BattleMapPanel;
	
	/**
	 * ...
	 * @author ...
	 */
	public class WeaponListPanel extends CSprite
	{
		
		public static const BTN_WIDTH:int = 160;
		private var _btnBack:CImgButton = null;
		private var _selectWeapon:MasterWeaponData = null;
		private var _counterEnable:Boolean = false;
		
		//-------------------------------------------------------------
		//
		// construction
		//
		//-------------------------------------------------------------
		public function WeaponListPanel()
		{
			var i:int = 0;
			_btnBack = new CImgButton(MainController.$.imgAsset.getTexture("btn_Return"));
			_btnBack.x = BattleMapPanel.RIGHT_SIDE;
			_btnBack.y = BattleMapPanel.UNDER_LINE;
			_btnBack.addEventListener(Event.TRIGGERED, pushBackBtn);
			super();
		}
		
		// 武器セット、0の時は攻撃、それ以上の時は反撃射程
		public function setWeapon(unit:BattleUnit, range:int = 0):void
		{
			var datalist:Vector.<MasterWeaponData> = unit.masterData.weaponDataList;
			_counterEnable = false;
			var i:int = 0;
			var count:int = 0;
			if (_itemList != null)
			{
				removeItemList();
				_itemList = null;
			}
			
			_baseSpr = new CSprite();
			_baseSpr.addEventListener(TouchEvent.TOUCH, touchSpr);
			addChild(_baseSpr);
			_itemList = new Vector.<WeaponListItem>;
			for (i = 0; i < datalist.length; i++)
			{
				var counterFlg:Boolean = false;
				var weaponItem:WeaponListItem = new WeaponListItem(datalist[i], unit);
				
				// 攻撃時、防御系の技はリストから飛ばす
				if (range == 0 && datalist[i].actType != MasterWeaponData.ACT_TYPE_ATK)
				{
					continue;
				}
				
				weaponItem.x = (CommonDef.WINDOW_W - weaponItem.width) / 2;
				weaponItem.y = count * 140;
				weaponItem.addEventListener(TouchEvent.TOUCH, touchFunc);
				weaponItem.alpha = 1;
				
				// 反撃時処理
				if (range > 0)
				{
					if (datalist[i].minRange <= range && range <= datalist[i].maxRange)
					{
						counterFlg = true;
					}
					else if (datalist[i].actType != MasterWeaponData.ACT_TYPE_ATK)
					{
						counterFlg = true;
					}
					else
					{
						counterFlg = false;
						weaponItem.touchable = false;
						weaponItem.alpha = 0.5;
					}
				}
				
				//使用回数
				if (datalist[i].maxCount > 0)
				{
					if (datalist[i].useCount <= 0)
					{
						counterFlg = false;
						weaponItem.touchable = false;
						weaponItem.alpha = 0.5;
					}
				}
				
				//消費エネルギー
				if (datalist[i].useFp > 0)
				{
					if (unit.nowFp < datalist[i].useFp)
					{
						counterFlg = false;
						weaponItem.touchable = false;
						weaponItem.alpha = 0.5;
					}
				}
				
				//攻撃側の時
				if (range == 0)
				{
					//移動後使用可能
					if (!datalist[i].pWeapon)
					{
						if (MainController.$.map.selectMoved)
						{
							counterFlg = false;
							weaponItem.touchable = false;
							weaponItem.alpha = 0.5;
						}
					}
				}
				if (counterFlg)
				{
					_counterEnable = true;
				}
				
				_baseSpr.addChild(weaponItem);
				_itemList.push(weaponItem);
				count++;
			}
			
			if (MainController.$.map.selectSide == 0)
			{
				
				addChild(_btnBack);
			}
			else
			{
				removeChild(_btnBack);
			}
		}
		
		//-------------------------------------------------------------
		//
		// override
		//
		//-------------------------------------------------------------
		override public function dispose():void
		{
			
			removeItemList();
			if (_btnBack != null)
			{
				_btnBack.removeEventListener(Event.TRIGGERED, pushBackBtn);
				_btnBack.dispose()
			}
			_btnBack = null;
			_selectWeapon = null;
			if (_baseSpr != null)
			{
				_baseSpr.removeEventListener(TouchEvent.TOUCH, touchSpr);
				_baseSpr.dispose();
			}
			_baseSpr = null;
			super.dispose();
		}
		
		public function removeItemList():void
		{
			var i:int = 0;
			if (_itemList != null)
			{
				for (i = 0; i < _itemList.length; i++)
				{
					_itemList[i].removeEventListener(TouchEvent.TOUCH, touchFunc);
					_itemList[i].dispose();
					_itemList[i] = null;
				}
			}
		}
		
		//-------------------------------------------------------------
		//
		// component
		//
		//-------------------------------------------------------------
		private var _itemList:Vector.<WeaponListItem> = null;
		private var _baseSpr:CSprite = null;
		
		//-------------------------------------------------------------
		//
		// variable
		//
		//-------------------------------------------------------------
		//-------------------------------------------------------------
		//
		// event handler
		//
		//-------------------------------------------------------------
		/**タッチイベント*/
		public function touchFunc(e:TouchEvent):void
		{
			var target:WeaponListItem = e.currentTarget as WeaponListItem;
			var touch:Touch = e.getTouch(target);
			if (touch != null)
			{
				//クリック上げた時
				switch (touch.phase)
				{
				//ボタン離す
				case TouchPhase.ENDED:
					
					var pos:Point = globalToLocal(new Point(touch.globalX, touch.globalY));
					if (touch.globalX > target.x && touch.globalX < target.x + target.width && touch.globalY > target.y && touch.globalY < target.y + target.height)
					{
						
						_selectWeapon = target.data;
						if (MainController.$.view.battleMap.selectSide == 0)
						{
							MainController.$.view.battleMap.makeAttackArea(target.data);
						}
						else
						{
							MainController.$.view.battleMap.selectCounterWeapon(target.data);
						}
						
					}
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
		}
		
		/**スプライトタッチ*/
		public function touchSpr(e:TouchEvent):void
		{
			var target:CSprite = e.currentTarget as CSprite;
			var touch:Touch = e.getTouch(target);
			if (touch != null)
			{
				//クリック上げた時
				switch (touch.phase)
				{
				//ボタン離す
				case TouchPhase.ENDED: 
					break;
				//マウスオーバー
				case TouchPhase.HOVER: 
					break;
				case TouchPhase.STATIONARY: 
					break;
				//ドラッグ
				case TouchPhase.MOVED: 
					if (_baseSpr.height < CommonDef.WINDOW_H)
					{
						return;
					}
					
					var pos:Point = globalToLocal(new Point(touch.globalX, touch.globalY));
					var addPos:int = touch.globalY - touch.previousGlobalY;
					if (_baseSpr.y + addPos >= 0)
					{
						_baseSpr.y = 0;
					}
					else if (_baseSpr.y + addPos <= -(_baseSpr.height - CommonDef.WINDOW_H))
					{
						_baseSpr.y = -(_baseSpr.height - CommonDef.WINDOW_H);
					}
					else
					{
						_baseSpr.y += addPos;
					}
					
					break;
				//押した瞬間
				case TouchPhase.BEGAN: 
					break;
				}
			}
		}
		
		/**武器リスト戻る*/
		public function pushBackBtn(e:Event):void
		{
			MainController.$.view.battleMap.removeWeaponList();
		}
		
		public function get selectWeapon():MasterWeaponData
		{
			return _selectWeapon;
		}
		
		public function get counterEnable():Boolean
		{
			return _counterEnable;
		}
	
		//-------------------------------------------------------------
		//
		// private function
		//
		//-------------------------------------------------------------
		//-------------------------------------------------------------
		//
		// public function
		//
		//-------------------------------------------------------------
	
	}

}