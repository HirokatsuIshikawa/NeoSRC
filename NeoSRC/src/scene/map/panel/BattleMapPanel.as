package scene.map.panel
{
    import common.CommonDef;
    import scene.map.panel.subpanel.MapTalkPanel;
    import scene.unit.SkillListPanel;
    import scene.unit.WeaponListItem;
    import scene.unit.WeaponListPanel;
    import system.custom.customSprite.CSprite;
    import scene.main.MainController;
    import scene.map.battle.AttackListItem;
    import scene.map.panel.subpanel.CommandPanel;
    import scene.map.panel.subpanel.MovePanel;
    import scene.map.panel.subpanel.PredictionPanel;
    import scene.map.panel.subpanel.SelectTargetPanel;
    import scene.map.panel.subpanel.SystemPanel;
    
    /**
     * ...
     * @author ...
     */
    public class BattleMapPanel extends CSprite
    {
        private var _nowPanelType:int = 0;
        
        public static const PANEL_NONE:int = 0;
        public static const PANEL_SYSTEM:int = 1;
        public static const PANEL_COMMAND:int = 2;
        public static const PANEL_MOVE:int = 3;
        public static const PANEL_WEAPON:int = 4;
        public static const PANEL_PREDICTION:int = 5;
        public static const PANEL_SELECT_TARGET:int = 6;
        public static const PANEL_SKILL:int = 7;
        public static const PANEL_SELECT_SKILL_TARGET:int = 8;
        public static const PANEL_COMMAND_ENEMY:int = 10;
        public static const PANEL_ENEMY_TURN:int = 11;
        public static const PANEL_COUNTER_WEAPON:int = 12;
        public static const PANEL_MAP_TALK:int = 13;
        
        public static const UNDER_LINE:int = CommonDef.WINDOW_H - 64;
        public static const BTN_INTERBAL:int = 96 + 18;
        public static const RIGHT_SIDE:int = CommonDef.WINDOW_W - 96;
        public static const BTN_WEIDTH:int = 96;
        
        /**反撃武器射程*/
        private var _counterAttackRange:int = 0;
        /**マップシステムパネル*/
        private var _systemPanel:SystemPanel;
        /**マップ会話パネル*/
        private var _mapTalkPanel:MapTalkPanel;
        /**キャラ選択後コマンドパネル*/
        private var _commandPanel:CommandPanel;
        /**移動時パネル*/
        private var _movePanel:MovePanel;
        /**ターゲット選択時パネル*/
        private var _selectTargetPanel:SelectTargetPanel;
        /**戦闘予測表示パネル*/
        private var _predictionPanel:PredictionPanel;
        /** 武器表示リストパネル*/
        private var _weaponPanel:WeaponListPanel = null;
        /** 武器表示リストパネル*/
        private var _skillPanel:SkillListPanel = null;
        
        public function BattleMapPanel()
        {
            _systemPanel = new SystemPanel();
            _mapTalkPanel = new MapTalkPanel();
            _commandPanel = new CommandPanel();
            _movePanel = new MovePanel();
            _selectTargetPanel = new SelectTargetPanel();
            _predictionPanel = new PredictionPanel();
            _weaponPanel = new WeaponListPanel();
            _skillPanel = new SkillListPanel();
        }
        
        public function showPanel(type:int):void
        {
            _nowPanelType = type;
            removeChildren();
            switch (_nowPanelType)
            {
            case PANEL_SYSTEM: 
                _systemPanel.refresh();
                addChild(_systemPanel);
                break;
            case PANEL_COMMAND: 
                _commandPanel.showPlayer(true);
                addChild(_commandPanel);
                break;
            case PANEL_COMMAND_ENEMY: 
                _commandPanel.showPlayer(false);
                addChild(_commandPanel);
                break;
            
            case PANEL_MOVE: 
                addChild(_movePanel);
                break;
            case PANEL_WEAPON: 
                //選択中
                _weaponPanel.setWeapon(MainController.$.map.nowBattleUnit);
                addChild(_weaponPanel);
                break;
            case PANEL_SKILL: 
                //選択中
                _skillPanel.setSkill(MainController.$.map.nowBattleUnit);
                addChild(_skillPanel);
                break;
            case PANEL_PREDICTION: 
                addChild(_predictionPanel);
                break;
            case PANEL_SELECT_TARGET: 
            case PANEL_SELECT_SKILL_TARGET: 
                addChild(_selectTargetPanel);
                break;
            case PANEL_ENEMY_TURN:
                
                break;
            case PANEL_COUNTER_WEAPON: 
                //選択中
                _weaponPanel.setWeapon(MainController.$.map.targetUnit, _counterAttackRange);
                
                if (_weaponPanel.counterEnable)
                {
                    addChild(_weaponPanel);
                }
                else
                {
                    MainController.$.view.battleMap.selectCounterWeapon(null);
                }
                break;
            //マップ会話
            case PANEL_MAP_TALK: 
                _mapTalkPanel.refresh();
                addChild(_mapTalkPanel);
                break;
            }
            
            MainController.$.view.battleMap.setTouchEvent(_nowPanelType);
        }
        
        /**戦闘予測セット*/
        public function setPrediction(list:Vector.<AttackListItem>):void
        {
            _predictionPanel.setPrediction(list);
        }
        
        override public function dispose():void
        {
            _systemPanel.dispose();
            _commandPanel.dispose();
            _movePanel.dispose();
            _selectTargetPanel.dispose();
            _predictionPanel.dispose();
            _weaponPanel.dispose();
            super.dispose();
        }
        
        public function get commandPanel():CommandPanel
        {
            return _commandPanel;
        }
        
        public function get movePanel():MovePanel
        {
            return _movePanel;
        }
        
        public function get weaponPanel():WeaponListPanel
        {
            return _weaponPanel;
        }
        
        public function get skillPanel():SkillListPanel
        {
            return _skillPanel;
        }
        
        public function set counterAttackRange(value:int):void
        {
            _counterAttackRange = value;
        }
        
        public function get nowPanelType():int
        {
            return _nowPanelType;
        }
        
        public function set nowPanelType(value:int):void
        {
            _nowPanelType = value;
        }
                
        public function get counterAttackRange():int
        {
            return _counterAttackRange;
        }
        
        public function setShowPos(x:int, y:int):void
        {
            _systemPanel.setPosText(x, y);
        
        }
    
    }

}