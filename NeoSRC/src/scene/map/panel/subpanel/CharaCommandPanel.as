package scene.map.panel.subpanel 
{
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CButton;
	import system.custom.customSprite.CImgButton;
	import system.custom.customSprite.CSprite;
	import starling.events.Event;
	import main.MainController;
	import scene.map.panel.BattleMapPanel;
	/**
	 * ...
	 * @author ishikawa
	 */
	public class CharaCommandPanel extends CSprite
	{
		
		
		private var _btnMove:CImgButton = null;
		private var _btnSp:CImgButton = null;
		private var _btnBack:CImgButton = null;
		
		public function CharaCommandPanel() 
		{
			super();
			_btnMove = new CImgButton(MainController.$.imgAsset.getTexture("btn_Act"));
			_btnSp = new CImgButton(MainController.$.imgAsset.getTexture("btn_Act"));
			_btnBack = new CImgButton(MainController.$.imgAsset.getTexture("btn_Return"));
			
			_btnMove.x = BattleMapPanel.BTN_INTERBAL * 0;
			_btnSp.x = BattleMapPanel.BTN_INTERBAL * 1;
			_btnBack.x = BattleMapPanel.BTN_INTERBAL * 2;
			
			_btnMove.y = BattleMapPanel.UNDER_LINE;
			_btnSp.y = BattleMapPanel.UNDER_LINE;
			_btnBack.y = BattleMapPanel.UNDER_LINE;
			
			
			_btnMove.addEventListener(Event.TRIGGERED, MainController.$.view.battleMap.moveAreaSet);
			_btnBack.addEventListener(Event.TRIGGERED, MainController.$.view.battleMap.backMove);
			
			addChild(_btnMove);
			addChild(_btnBack);
			
		}
		
		override public function dispose():void
		{
			_btnMove.removeEventListener(Event.TRIGGERED, MainController.$.view.battleMap.moveAreaSet);
			_btnMove.dispose();
			_btnMove = null;
			
			_btnBack.removeEventListener(Event.TRIGGERED, MainController.$.view.battleMap.backMove);
			_btnBack.dispose();
			_btnBack = null;
			super.dispose();
		}
		
		/**味方の時に表示*/
		public function showPlayer(flg:Boolean):void
		{
			
			_btnMove.visible = flg;
			_btnSp.visible = flg;
			_btnBack.visible = true;
		}
		
		
	}
}