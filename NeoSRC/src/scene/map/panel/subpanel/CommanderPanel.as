package scene.map.panel.subpanel 
{
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CButton;
	import system.custom.customSprite.CImgButton;
	import system.custom.customSprite.CSprite;
	import starling.events.Event;
	import scene.main.MainController;
	import scene.map.panel.BattleMapPanel;
	/**
	 * ...
	 * @author ishikawa
	 */
	public class CommanderPanel extends CSprite
	{
		private var _btnSp:CImgButton = null;
		private var _btnBack:CImgButton = null;
		
		public function CommanderPanel() 
		{
			super();
			_btnSp = new CImgButton(MainController.$.imgAsset.getTexture("btn_Skill"));
			_btnBack = new CImgButton(MainController.$.imgAsset.getTexture("btn_Return"));
			
			_btnSp.x = BattleMapPanel.BTN_INTERBAL * 1;
			_btnBack.x = BattleMapPanel.BTN_INTERBAL * 2;
			
			_btnSp.y = BattleMapPanel.UNDER_LINE;
			_btnBack.y = BattleMapPanel.UNDER_LINE;
			
			
			_btnSp.addEventListener(Event.TRIGGERED, MainController.$.view.battleMap.showCommanderSkillList);
			_btnBack.addEventListener(Event.TRIGGERED, MainController.$.view.battleMap.backMove);
			
			addChild(_btnSp);
			addChild(_btnBack);
			
		}
		
		override public function dispose():void
		{
            CommonDef.disposeList([_btnSp, _btnBack]);
			super.dispose();
		}
		
		/**味方の時に表示*/
		public function showPlayer(flg:Boolean):void
		{
			_btnSp.visible = flg;
			_btnBack.visible = true;
		}
		
		
	}
}