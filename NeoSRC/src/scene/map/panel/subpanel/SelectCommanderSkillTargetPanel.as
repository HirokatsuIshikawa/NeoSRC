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
	public class SelectCommanderSkillTargetPanel extends CSprite
	{
		
		public static const BTN_WIDTH:int = 160;
		
		private var _btnBack:CImgButton = null;
		private var _btnExecution:CImgButton = null;
		
		public function SelectCommanderSkillTargetPanel()
		{
			super();
			
			_btnBack = new CImgButton(MainController.$.imgAsset.getTexture("btn_Return"));
						
			_btnBack.x = BattleMapPanel.RIGHT_SIDE;
			_btnBack.y = BattleMapPanel.UNDER_LINE;
            
            _btnExecution = new CImgButton(MainController.$.imgAsset.getTexture("btn_execution"));
            _btnExecution.x = BattleMapPanel.RIGHT_SIDE - BattleMapPanel.BTN_WEIDTH - 20;
			_btnExecution.y = BattleMapPanel.UNDER_LINE;
			
			_btnBack.addEventListener(Event.TRIGGERED, MainController.$.view.battleMap.backCommanderTarget);
			_btnExecution.addEventListener(Event.TRIGGERED, MainController.$.view.battleMap.executeToAllCommanderSkill);
            
			addChild(_btnBack);
			addChild(_btnExecution);
		
		}
        
        
        public function toAllTarget(flg:Boolean):void
        {
            _btnExecution.visible = flg;
        }
        
		
		override public function dispose():void
		{
			
			_btnBack.removeEventListener(Event.TRIGGERED, MainController.$.view.battleMap.backCommanderTarget);
			_btnBack.dispose();
			_btnBack = null;
			_btnExecution.removeEventListener(Event.TRIGGERED, MainController.$.view.battleMap.executeToAllCommanderSkill);
			_btnExecution.dispose();
			_btnExecution = null;
			super.dispose();
		}
		
		
	}
}