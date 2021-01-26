package scene.map.panel.subpanel
{
    import common.CommonDef;
    import common.CommonSystem;
    import scene.base.BaseTip;
    import scene.unit.BattleUnit;
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
        private var _btnBaseInfo:CImgButton = null;
        
        public function CharaCommandPanel()
        {
            super();
            _btnMove = new CImgButton(MainController.$.imgAsset.getTexture("btn_Act"));
            _btnSp = new CImgButton(MainController.$.imgAsset.getTexture("btn_Act"));
            _btnBack = new CImgButton(MainController.$.imgAsset.getTexture("btn_Return"));
            _btnBaseInfo = new CImgButton(MainController.$.imgAsset.getTexture("btn_info_base"));
            
            _btnMove.x = BattleMapPanel.BTN_INTERBAL * 0;
            _btnSp.x = BattleMapPanel.BTN_INTERBAL * 1;
            _btnBack.x = BattleMapPanel.BTN_INTERBAL * 2;
            _btnBaseInfo.x = BattleMapPanel.BTN_INTERBAL * 5;
            
            _btnMove.y = BattleMapPanel.UNDER_LINE;
            _btnSp.y = BattleMapPanel.UNDER_LINE;
            _btnBack.y = BattleMapPanel.UNDER_LINE;
            _btnBaseInfo.y = BattleMapPanel.UNDER_LINE;
            
            _btnMove.addEventListener(Event.TRIGGERED, MainController.$.view.battleMap.moveAreaSet);
            _btnBack.addEventListener(Event.TRIGGERED, MainController.$.view.battleMap.backMove);
            _btnBaseInfo.addEventListener(Event.TRIGGERED, MainController.$.view.battleMap.baseConquest);
            
            addChild(_btnMove);
            addChild(_btnBack);
            addChild(_btnBaseInfo);
        }
        
        override public function dispose():void
        {
            _btnMove.removeEventListener(Event.TRIGGERED, MainController.$.view.battleMap.moveAreaSet);
            _btnMove.dispose();
            _btnMove = null;
            
            _btnBack.removeEventListener(Event.TRIGGERED, MainController.$.view.battleMap.backMove);
            _btnBack.dispose();
            _btnBack = null;
            
            _btnBaseInfo.removeEventListener(Event.TRIGGERED, MainController.$.view.battleMap.baseConquest);
            _btnBaseInfo.dispose();
            _btnBaseInfo = null;
            super.dispose();
        }
        
        /**味方の時に表示*/
        public function showPlayer(flg:Boolean):void
        {
            _btnMove.visible = flg;
            _btnSp.visible = flg;
            _btnBack.visible = true;
            
            var unit:BattleUnit = MainController.$.map.getSelectSideUnitData();
            
            if (unit != null && unit.param.CON > 0 && MainController.$.map.isUnitOnOtherBase(unit))
            {
                _btnBaseInfo.visible = flg;
            }
            else
            {
                _btnBaseInfo.visible = false;
            }
        }
    }
}