package scene.map.panel.subpanel
{
    import common.CommonDef;
    import common.CommonSystem;
    import database.master.MasterCharaData;
    import scene.base.BaseTip;
    import scene.map.tip.TerrainData;
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
        private var _btnBack:CImgButton = null;
        private var _btnBaseInfo:CImgButton = null;
        private var _btnFly:CImgButton = null;
        private var _btnLanding:CImgButton = null;
        
        public function CharaCommandPanel()
        {
            super();
            _btnMove = new CImgButton(MainController.$.imgAsset.getTexture("btn_Act"));
            _btnBack = new CImgButton(MainController.$.imgAsset.getTexture("btn_Return"));
            _btnBaseInfo = new CImgButton(MainController.$.imgAsset.getTexture("btn_info_base"));
            _btnFly = new CImgButton(MainController.$.imgAsset.getTexture("btn_fly"));
            _btnLanding = new CImgButton(MainController.$.imgAsset.getTexture("btn_landing"));
            
            _btnMove.x = BattleMapPanel.BTN_INTERBAL * 0;
            _btnFly.x = BattleMapPanel.BTN_INTERBAL * 1;
            _btnLanding.x = BattleMapPanel.BTN_INTERBAL * 1;
            _btnBack.x = BattleMapPanel.BTN_INTERBAL * 3;
            _btnBaseInfo.x = BattleMapPanel.BTN_INTERBAL * 5;
            
            _btnMove.y = BattleMapPanel.UNDER_LINE;
            _btnBack.y = BattleMapPanel.UNDER_LINE;
            _btnBaseInfo.y = BattleMapPanel.UNDER_LINE;
            _btnFly.y = BattleMapPanel.UNDER_LINE;
            _btnLanding.y = BattleMapPanel.UNDER_LINE;
            
            _btnMove.addEventListener(Event.TRIGGERED, MainController.$.view.battleMap.moveAreaSet);
            _btnBack.addEventListener(Event.TRIGGERED, MainController.$.view.battleMap.backMove);
            _btnBaseInfo.addEventListener(Event.TRIGGERED, MainController.$.view.battleMap.baseConquest);
            _btnFly.addEventListener(Event.TRIGGERED, pushFly);
            _btnLanding.addEventListener(Event.TRIGGERED, pushLanding);
            
            addChild(_btnMove);
            addChild(_btnBack);
            addChild(_btnBaseInfo);
            addChild(_btnFly);
            addChild(_btnLanding);
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
            
            _btnFly.removeEventListener(Event.TRIGGERED, pushFly);
            _btnFly.dispose();
            _btnFly = null;
            
            _btnLanding.removeEventListener(Event.TRIGGERED, pushLanding);
            _btnLanding.dispose();
            _btnLanding = null;
            
            super.dispose();
        }
        
        public function pushFly(e:Event):void
        {
            var unit:BattleUnit = MainController.$.map.getSelectSideUnitData();
            unit.flyUp();
            _btnFly.visible = false;
            _btnLanding.visible = true;
            MainController.$.map.removeMoveAreaImg();
            MainController.$.map.resetMoveTerrainData();
            MainController.$.map.terrainDataReset();
            var list:Vector.<String> = new Vector.<String>;
            MainController.$.map.remakeMoveArea(unit, unit.PosX - 1, unit.PosY - 1, unit.param.MOV, list, 0);
        }
        
        public function pushLanding(e:Event):void
        {
            
            var unit:BattleUnit = MainController.$.map.getSelectSideUnitData();
            unit.landing();
            _btnFly.visible = true;
            _btnLanding.visible = false;
            MainController.$.map.removeMoveAreaImg();
            MainController.$.map.resetMoveTerrainData();
            MainController.$.map.terrainDataReset();
            var list:Vector.<String> = new Vector.<String>;
            MainController.$.map.remakeMoveArea(unit, unit.PosX - 1, unit.PosY - 1, unit.param.MOV, list, 0);
        }
        
        /**味方の時に表示*/
        public function showPlayer(flg:Boolean):void
        {
            _btnMove.visible = flg;
            _btnBack.visible = true;
            
            var unit:BattleUnit = MainController.$.map.getSelectSideUnitData();
            
            //飛行可能なら飛行・着地を設定
            if (flg && unit.masterData.terrain[TerrainData.TERRAIN_TYPE_SKY] >= 0)
            {
                if (unit.isFly)
                {
                    _btnFly.visible = false;
                    _btnLanding.visible = true;
                }
                else
                {
                    _btnFly.visible = true;
                    _btnLanding.visible = false;
                }
            }
            else
            {
                _btnFly.visible = false;
                _btnLanding.visible = false;
            }
            
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