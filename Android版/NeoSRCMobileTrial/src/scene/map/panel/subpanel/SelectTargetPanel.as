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
	public class SelectTargetPanel extends CSprite
	{
		
		public static const BTN_WIDTH:int = 160;
		
		private var _btnBack:CImgButton = null;
		
		public function SelectTargetPanel()
		{
			super();
			
			_btnBack = new CImgButton(MainController.$.imgAsset.getTexture("btn_Return"));
						
			_btnBack.x = BattleMapPanel.RIGHT_SIDE;
			_btnBack.y = BattleMapPanel.UNDER_LINE;
			
			_btnBack.addEventListener(Event.TRIGGERED, MainController.$.view.battleMap.backAttackArea);
			
			addChild(_btnBack);
		
		}
		
		override public function dispose():void
		{
			
			_btnBack.removeEventListener(Event.TRIGGERED, MainController.$.view.battleMap.backAttackArea);
			_btnBack.dispose();
			_btnBack = null;
			super.dispose();
		}
		
		
	}
}