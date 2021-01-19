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
	import scene.map.battle.AttackListItem;
	import scene.map.battle.AttackPredictList;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class PredictionPanel extends CSprite
	{
		
		private var _btnBack:CImgButton = null;
		private var _btnAttack:CImgButton = null;
		
		/**戦闘予測パネル*/
		private var _attackPredictPanel:AttackPredictList = null;
		
		public function PredictionPanel()
		{
			super();
			
			_btnAttack = new CImgButton(MainController.$.imgAsset.getTexture("btn_Atk"));
			_btnAttack.x = BattleMapPanel.BTN_INTERBAL * 0;
			_btnAttack.y = BattleMapPanel.UNDER_LINE;
			_btnAttack.addEventListener(Event.TRIGGERED, MainController.$.view.battleMap.callAttackStart);
			addChild(_btnAttack);
			
			_btnBack = new CImgButton(MainController.$.imgAsset.getTexture("btn_Return"));
			_btnBack.x = CommonDef.WINDOW_W - BattleMapPanel.BTN_WEIDTH;
			_btnBack.y = BattleMapPanel.UNDER_LINE;
			_btnBack.addEventListener(Event.TRIGGERED, MainController.$.view.battleMap.backAttackArea);
			addChild(_btnBack);
		}
		
		//予測リスト作成
		public function setPrediction(list:Vector.<AttackListItem>):void
		{
			
			if (_attackPredictPanel != null)
			{
				removeChild(_attackPredictPanel);
				_attackPredictPanel.dispose();
				_attackPredictPanel = null;
			}
			
			_attackPredictPanel = new AttackPredictList(list);
			_attackPredictPanel.alpha = 1;
			_attackPredictPanel.visible = true;
			_attackPredictPanel.x = CommonDef.WINDOW_W / 2;
			addChild(_attackPredictPanel);
		
		}
		
		override public function dispose():void
		{
			if (_btnAttack != null)
			{
				_btnAttack.removeEventListener(Event.TRIGGERED, MainController.$.view.battleMap.callAttackStart);
				_btnAttack.dispose();
			}
			_btnBack.removeEventListener(Event.TRIGGERED, MainController.$.view.battleMap.backAttackArea);
			_btnBack.dispose();
			_btnAttack = null;
			_btnBack = null;
			super.dispose();
		}
	
	}
}