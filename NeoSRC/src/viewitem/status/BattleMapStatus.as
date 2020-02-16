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
	public class BattleMapStatus extends CSprite
	{
		private var _customBGMBtn:CImgButton = null;
		private var _statusWindow:BaseStatusWindow = null;
		private var _unitId:int = 0;
		
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
		
		public function setCharaData(unit:BattleUnit):void
		{
			_unitId = unit.id;
			_statusWindow.setCharaData(unit);
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