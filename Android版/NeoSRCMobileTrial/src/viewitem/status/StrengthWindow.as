package viewitem.status
{
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CImgButton;
	import system.custom.customSprite.CSprite;
	import system.custom.customSprite.CTextArea;
	import starling.events.Event;
	import scene.main.MainController;
	import scene.unit.BattleUnit;
	import viewitem.status.BaseStatusWindow;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class StrengthWindow extends CSprite
	{
		private var _unitId:int = 0;
		private var _blackBackImg:CImage = null;
		private var _strengthBtn:CImgButton = null;
		private var _closeBtn:CImgButton = null;
		private var _statusWindow:BaseStatusWindow = null;
		private var _moneyTxt:CTextArea = null;
		private var _useTxt:CTextArea = null;
		
		public function StrengthWindow()
		{
			
			super();
			
			//暗幕設定
			_blackBackImg = new CImage(MainController.$.imgAsset.getTexture("tex_black"));
			_blackBackImg.alpha = 0.8;
			_blackBackImg.width = CommonDef.WINDOW_W;
			_blackBackImg.height = CommonDef.WINDOW_H;
			addChildAt(_blackBackImg, 0);
			
			_statusWindow = new BaseStatusWindow();
			_statusWindow.x = 40;
			_statusWindow.y = 10;
			addChild(_statusWindow);
			
			// 強化ボタン
			_strengthBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_Strength"));
			_strengthBtn.x = 780;
			_strengthBtn.y = 360;
			
			_strengthBtn.width = 96;
			_strengthBtn.height = 64;
			_strengthBtn.addEventListener(Event.TRIGGERED, charaStrength);
			addChild(_strengthBtn);
			
			// 閉じるボタン
			_closeBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_Return"));
			_closeBtn.x = 780;
			_closeBtn.y = 460;
			
			_closeBtn.width = 96;
			_closeBtn.height = 64;
			_closeBtn.addEventListener(Event.TRIGGERED, MainController.$.view.interMission.closeStrengthWindow);
			addChild(_closeBtn);
		}
		
		private function charaStrength(e:Event):void
		{
			var i:int = 0;
			var usePoint:int = 0;
			for (i = 0; i < MainController.$.model.PlayerUnitData.length; i++)
			{
				if (_unitId == MainController.$.model.PlayerUnitData[i].id)
				{
					usePoint = CommonSystem.STRENGTH_MONEY[MainController.$.model.PlayerUnitData[i].strengthPoint];
					MainController.$.model.PlayerUnitData[i].addStrength();
					break;
				}
			}
			
			MainController.$.model.playerParam.money -= usePoint;
			MainController.$.view.interMission.compStrengthChara();
		
		}
		
		override public function dispose():void
		{
			_blackBackImg.dispose();
			_blackBackImg = null;
			
			if (_strengthBtn)
			{
				removeChild(_strengthBtn);
				_strengthBtn.removeEventListener(Event.TRIGGERED, charaStrength);
				_strengthBtn.dispose();
			}
			
			if (_closeBtn)
			{
				removeChild(_closeBtn);
				_closeBtn.removeEventListener(Event.TRIGGERED, MainController.$.view.interMission.closeStrengthWindow);
				_closeBtn.dispose();
			}
			_strengthBtn = null;
			_closeBtn = null;
			super.dispose();
		}
		
		public function setCharaData(unit:BattleUnit):void
		{
			_unitId = unit.id;
			_statusWindow.setCharaData(unit);
			
			
			
			if (unit.strengthPoint >= CommonSystem.STRENGTH_MONEY.length)
			{
				_strengthBtn.isEnabled = false;
				_moneyTxt = new CTextArea(24, 0xFFFFFF, 0x0);
			}
			else if (MainController.$.model.playerParam.money < CommonSystem.STRENGTH_MONEY[unit.strengthPoint])
			{
				_strengthBtn.isEnabled = false;
				_moneyTxt = new CTextArea(24, 0xFF4444, 0x0);
			}
			else
			{
				_strengthBtn.isEnabled = true;
				_moneyTxt = new CTextArea(24, 0xFFFFFF, 0x0);
			}
			
			_moneyTxt.x = 700;
			_moneyTxt.y = 20;
			_moneyTxt.width = 300;
			_moneyTxt.height = 40;
			_moneyTxt.text = "資金：" + MainController.$.model.playerParam.money;
			addChild(_moneyTxt);
			
			_useTxt = new CTextArea(24, 0xFFFFFF, 0x0);
			_useTxt.x = 700;
			_useTxt.y = 50;
			_useTxt.width = 300;
			_useTxt.height = 80;
			
			_useTxt.text = "費用：" + CommonSystem.STRENGTH_MONEY[unit.strengthPoint];
			addChild(_useTxt);
		}
	
	}

}