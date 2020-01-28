package scene.map.panel.subpanel
{
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CButton;
	import system.custom.customSprite.CImgButton;
	import system.custom.customSprite.CSprite;
	import feathers.controls.Button;
	import starling.events.Event;
	import scene.main.MainController;
	import scene.map.panel.BattleMapPanel;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class MovePanel extends CSprite
	{
		
		public static const BTN_WIDTH:int = 160;
		private var _btnMove:CImgButton = null;
		private var _btnAttack:CImgButton = null;
		private var _btnSkill:CImgButton = null;
		private var _btnBack:CImgButton = null;
		
		public function MovePanel()
		{
			super();
			_btnMove = new CImgButton(MainController.$.imgAsset.getTexture("btn_Move"));
			_btnAttack = new CImgButton(MainController.$.imgAsset.getTexture("btn_Atk"));
			_btnSkill = new CImgButton(MainController.$.imgAsset.getTexture("btn_Skill"));
			_btnBack = new CImgButton(MainController.$.imgAsset.getTexture("btn_Return"));
			
			_btnMove.x = BattleMapPanel.BTN_INTERBAL * 0;
			_btnAttack.x = BattleMapPanel.BTN_INTERBAL * 1;
			_btnSkill.x = BattleMapPanel.BTN_INTERBAL * 2;
			_btnBack.x = BattleMapPanel.RIGHT_SIDE;
			
			_btnMove.y = BattleMapPanel.UNDER_LINE;
			_btnAttack.y = BattleMapPanel.UNDER_LINE;
			_btnSkill.y = BattleMapPanel.UNDER_LINE;
			_btnBack.y = BattleMapPanel.UNDER_LINE;
			
			_btnMove.addEventListener(Event.TRIGGERED, MainController.$.view.battleMap.startMove);
			_btnAttack.addEventListener(Event.TRIGGERED, MainController.$.view.battleMap.showWeaponList);
			_btnSkill.addEventListener(Event.TRIGGERED, MainController.$.view.battleMap.showSkillList);
			_btnBack.addEventListener(Event.TRIGGERED, MainController.$.view.battleMap.backMove);
			
			addChild(_btnMove);
			addChild(_btnAttack);
			addChild(_btnSkill);
			addChild(_btnBack);
		
		}
		
		
		override public function dispose():void
		{
			_btnMove.removeEventListener(Event.TRIGGERED, MainController.$.view.battleMap.startMove);
			_btnMove.dispose();
			_btnMove = null;
			
			_btnAttack.removeEventListener(Event.TRIGGERED, MainController.$.view.battleMap.showWeaponList);
			_btnAttack.dispose();
			_btnAttack = null;
			
			_btnSkill.removeEventListener(Event.TRIGGERED, MainController.$.view.battleMap.showSkillList);
			_btnSkill.dispose();
			_btnSkill = null;
			
			_btnBack.removeEventListener(Event.TRIGGERED, MainController.$.view.battleMap.backMove);
			_btnBack.dispose();
			_btnBack = null;
			
			super.dispose();
		}
	}
}