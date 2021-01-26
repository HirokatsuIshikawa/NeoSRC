package viewitem.status
{
    import database.user.CommanderData;
    import main.MainController;
    import scene.unit.BattleUnit;
    import starling.events.Event;
    import system.custom.customSprite.CImgButton;
    import system.custom.customSprite.CSprite;
    import system.file.DataLoad;
    import viewitem.status.BaseStatusWindow;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class BattleMapStatus extends CSprite
	{
		private var _customBGMBtn:CImgButton = null;
		private var _statusWindow:BaseStatusWindow = null;
		private var _unitId:int = 0;
		private var _unit:BattleUnit = null;
		
		public function BattleMapStatus()
		{
			super();
			
			_statusWindow = new BaseStatusWindow();
			_statusWindow.x = 0;
			_statusWindow.y = 0;
			addChild(_statusWindow);
			
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
			if (_customBGMBtn)
			{
				removeChild(_customBGMBtn);
				_customBGMBtn.removeEventListener(Event.TRIGGERED, callCustomBgm);
				_customBGMBtn.dispose();
			}
			_customBGMBtn = null;
			super.dispose();
		}
		
        /**キャラデータセット*/
		public function setCharaData(unit:BattleUnit, customBgmFlg:Boolean):void
		{
			_unitId = unit.id;
			_statusWindow.setCharaData(unit);
			_unit = unit;
			_customBGMBtn.visible = customBgmFlg;
		}
        
        /**軍師データセット*/
        public function setCommanderData(commander:CommanderData, cost:int):void
        {
            _statusWindow.setCommanderData(commander, cost);
			_customBGMBtn.visible = false;
        }
        
		/**カスタムBGMセット*/
		public function callCustomBgm(event:Event):void
		{
			var i:int = 0;
			
			DataLoad.LoadPath("カスタムBGM", "*.mid;*.mp3", compLoad);
			function compLoad(path:String):void
			{
                _unit.customBgmPath = path;
                
				for (i = 0; i < MainController.$.model.PlayerUnitData.length; i++)
				{
					if (MainController.$.model.PlayerUnitData[i].id == _unitId)
					{
						MainController.$.model.PlayerUnitData[i].customBgmPath = path;
						//SingleMusic.playBGM(MainController.$.model.PlayerUnitData[i].customBgmHeadPath, 1, 1);
						break;
                    }
				}
			}
		}	
	}
}