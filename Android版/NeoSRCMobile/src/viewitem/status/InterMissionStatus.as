package viewitem.status
{
	import bgm.SingleMusic;
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CImgButton;
	import system.custom.customSprite.CSprite;
	import starling.events.Event;
	import system.file.DataLoad;
	import scene.main.MainController;
	import scene.unit.BattleUnit;
	import viewitem.status.BaseStatusWindow;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class InterMissionStatus extends CSprite
	{
		
		private var _blackBackImg:CImage = null;
		private var _closeBtn:CImgButton = null;
		private var _customBGMBtn:CImgButton = null;
		private var _statusWindow:BaseStatusWindow = null;
		private var _unitId:int = 0;
		
		public function InterMissionStatus()
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
			
			// 閉じるボタン
			_closeBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_Return"));
			_closeBtn.x = 780;
			_closeBtn.y = 360;
			
			_closeBtn.width = 96;
			_closeBtn.height = 64;
			_closeBtn.addEventListener(Event.TRIGGERED, MainController.$.view.interMission.closeStatusWindow);
			addChild(_closeBtn);
			
			// カスタムBGM
			_customBGMBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_bgm"));
			_customBGMBtn.x = 780;
			_customBGMBtn.y = 240;
			
			_customBGMBtn.width = 64;
			_customBGMBtn.height = 64;
			_customBGMBtn.addEventListener(Event.TRIGGERED, callCustomBgm);
			addChild(_customBGMBtn);
		
		}
		
		override public function dispose():void
		{
			_blackBackImg.dispose();
			_blackBackImg = null;
			
			if (_closeBtn)
			{
				removeChild(_closeBtn);
				_closeBtn.removeEventListener(Event.TRIGGERED, MainController.$.view.interMission.closeSaveList);
				_closeBtn.dispose();
			}
			if (_customBGMBtn)
			{
				removeChild(_customBGMBtn);
				_customBGMBtn.removeEventListener(Event.TRIGGERED, callCustomBgm);
				_customBGMBtn.dispose();
			}
			_closeBtn = null;
			_customBGMBtn = null;
			super.dispose();
		}
		
		public function setCharaData(unit:BattleUnit):void
		{
			_unitId = unit.id;
			_statusWindow.setCharaData(unit);
			
			if (unit.customBgmPath != null && unit.customBgmPath.length > 0)
				try
				{
					SingleMusic.playBGM(unit.customBgmHeadPath, 1, 1);
				}
				catch (error:Error)
				{
					
				}
		}
		
		/**カスタムBGMセット*/
		public function callCustomBgm(event:Event):void
		{
			var i:int = 0;
			
			DataLoad.LoadPath("カスタムBGM", "*.mid;*.mp3", compLoad);
			function compLoad(path:String):void
			{
				
				for (i = 0; i < MainController.$.model.PlayerUnitData.length; i++)
				{
					if (MainController.$.model.PlayerUnitData[i].id == _unitId)
					{
						MainController.$.model.PlayerUnitData[i].customBgmPath = path;
						SingleMusic.playBGM(MainController.$.model.PlayerUnitData[i].customBgmHeadPath, 1, 1);
						break;
					}
				}
			
			}
		
		}
	
	}

}