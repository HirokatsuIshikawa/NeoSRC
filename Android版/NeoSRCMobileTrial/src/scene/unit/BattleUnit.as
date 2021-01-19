package scene.unit
{
    import database.master.MasterWeaponData;
    import database.master.base.BaseParam;
    import database.master.base.LearnLevelData;
    import database.user.CommanderData;
    import database.user.UnitCharaData;
    import database.user.buff.SkillBuffData;
    import main.MainController;
    import scene.map.BaseMap;
    import scene.map.tip.TerrainData;
    import starling.display.DisplayObject;
    import starling.utils.Color;
    import starling.utils.MathUtil;
    import system.custom.customSprite.CImage;
    
    /**
     * ...
     * @author ishikawa
     */
    public class BattleUnit extends UnitCharaData
    {
        
        public static const COMMAND_NORMAL:int = 0;
        public static const COMMAND_WAIT:int = 1;
        
        //パッシブスキル
        protected var _buffList:Vector.<SkillBuffData> = null;
        
        public function BattleUnit(unitData:UnitCharaData, battleId:int, side:int)
        {
            super(unitData.id, unitData.masterData, unitData.nowLv);
            _battleId = battleId;
            _strengthPoint = unitData.strengthPoint;
            
            _buffList = new Vector.<SkillBuffData>();
            levelSet(unitData.nowLv);
            
            _customBgmPath = unitData.customBgmPath;
            _nowHp = param.HP;
            _nowFp = param.FP;
            _nowTp = 100;
            _side = side;
            //_unitImg = new CImage(TextureManager.loadTexture(masterData.unitImgUrl, masterData.unitImgName, TextureManager.TYPE_UNIT));
            //_unitImg = new CImage(TextureManager.loadUnitNameTexture(masterData.unitsImgName, TextureManager.TYPE_UNIT));
            _unitImg = new CImage(MainController.$.imgAsset.getTexture(masterData.unitsImgName));
            
            _alive = true;
            _onMap = true;
            _moveCount++;
            _commandType = COMMAND_NORMAL;
            setMoveColor();
        }
        
        public function dispose():void
        {
            if (_unitImg != null)
            {
                _unitImg.dispose();
            }
            if (_frameImg != null)
            {
                _frameImg.dispose();
            }
            if (_formationNumImg != null)
            {
                _formationNumImg.dispose();
            }
            _formationNumImg = null;
            _unitImg = null;
            _frameImg = null;
        }
        
        private var _battleId:int = 0;
        public var nameId:String = null;
        private var _side:int = 0;
        private const MAX_TP:int = 999;
        private const LIMIT_TP:int = 300;
        
        /** 現在HP */
        private var _nowHp:int = 0;
        /** 現在FP */
        private var _nowFp:int = 0;
        /** 気力 */
        private var _nowTp:int = 0;
        
        /** 横位置 */
        public var PosX:int = 0;
        /** 縦位置 */
        public var PosY:int = 0;
        /** 生存 */
        private var _alive:Boolean = false;
        
        private var _onMap:Boolean = false;
        /** 移動回数 */
        private var _moveCount:int = 0;
        /** ユニット画像 */
        private var _unitImg:DisplayObject = null;
        /** 枠画像 */
        private var _frameImg:CImage = null;
        /**編成数画像*/
        private var _formationNumImg:CImage = null;
        
        /**空中*/
        private var _isFly:Boolean = false;
        /** 現在の命令タイプ */
        private var _commandType:int = 0;
        /**加入フラグ*/
        private var _joinFlg:Boolean = true;
        /**会話ラベル*/
        public var talkLabel:String = null;
        
        public function get unitImg():DisplayObject
        {
            return _unitImg;
        }
        
        public function get nowHp():int
        {
            return _nowHp;
        }
        
        public function get nowFp():int
        {
            return _nowFp;
        }
        
        public function get nowTp():int
        {
            return _nowTp;
        }
        
        public function get alive():Boolean
        {
            return _alive;
        }
        
        public function set alive(value:Boolean):void
        {
            _alive = value;
        }
        
        public function get frameImg():CImage
        {
            return _frameImg;
        }
        
        public function set frameImg(value:CImage):void
        {
            _frameImg = value;
        }
        
        public function get commandType():int
        {
            return _commandType;
        }
        
        public function set commandType(value:int):void
        {
            _commandType = value;
        }
        
        public function get battleId():int
        {
            return _battleId;
        }
        
        public function get weaponList():Vector.<MasterWeaponData>
        {
            return masterData.weaponDataList;
        }
        
        public function resetImgPos():void
        {
            _unitImg.x = (PosX - 1) * BaseMap.MAP_SIZE;
            _unitImg.y = (PosY - 1) * BaseMap.MAP_SIZE;
        }
        
        public function get mathPosX():int
        {
            return PosX - 1;
        }
        
        public function get mathPosY():int
        {
            return PosY - 1;
        }
        
        public function get onMap():Boolean
        {
            return _onMap;
        }
        
        public function set onMap(value:Boolean):void
        {
            _onMap = value;
        }
        
        public function get side():int
        {
            return _side;
        }
        
        public function get joinFlg():Boolean
        {
            return _joinFlg;
        }
        
        public function set joinFlg(value:Boolean):void
        {
            _joinFlg = value;
        }
        
        public function get moveCount():int
        {
            return _moveCount;
        }
        
        public function get buffList():Vector.<SkillBuffData>
        {
            return _buffList;
        }
        
        public function set buffList(value:Vector.<SkillBuffData>):void
        {
            _buffList = value;
        }
        
        public function get isFly():Boolean
        {
            return _isFly;
        }
        
        public function set moveCount(value:int):void
        {
            _moveCount = value;
        }
        
        /**ダメージ計算・ダメ―ジセット*/
        public function damageSet(damage:int):void
        {
            _nowHp -= damage;
            if (_nowHp <= 0)
            {
                _alive = false;
            }
            else
            {
                setFormationNumImg();
            }
        }
        
        //移動可能状態取得
        public function moveEnable():Boolean
        {
            if (_moveCount > 0 && _alive && _onMap)
            {
                return true;
            }
            return false;
        }
        
        //移動カウント減少
        public function moveEnd():void
        {
            _moveCount--;
            setMoveColor();
        }
        
        
        //移動カウントゼロ
        public function moveZero():void
        {
            _moveCount = 0;
            setMoveColor();
        }
        
        
        //移動後・移動前ユニットカラー変更
        public function setMoveColor():void
        {
            if (!_onMap)
            {
                return;
            }
            
            if (moveEnable())
            {
                if (_unitImg.hasOwnProperty("color"))
                {
                    _unitImg["color"] = 0xFFFFFF;
                }
            }
            else
            {
                if (_unitImg.hasOwnProperty("color"))
                {
                    _unitImg["color"] = Color.GRAY;
                }
            }
        }
        
        public function refreshState():void
        {
            //FP回復
            _nowFp += (int)(MathUtil.min(1, param.CAP / 4.0));
            
            if (_nowFp > param.FP)
            {
                _nowFp = param.FP
            }
        }
        
        public function setNowPoint(setHp:int, setFp:int, setTp:int):void
        {
            _nowHp = setHp;
            _nowFp = setFp;
            _nowTp = setTp;
        }
        
        public function refreshMoveCount():void
        {
            _moveCount = 1;
            setMoveColor();
        }
        
        /**編成数*/
        public function get formationNumImg():CImage
        {
            return _formationNumImg;
        }
        
        public function set formationNumImg(value:CImage):void
        {
            _formationNumImg = value;
        }
        
        public function get formationNum():int
        {
            return mathFormationNum(_nowHp);
        }
        
        /**HPから編成数計算*/
        public function mathFormationNum(value:int):int
        {
            var num:int = Math.ceil(maxFormationNum * (value / HP));
            
            if (num < 0)
            {
                num = 0;
            }
            if (num > maxFormationNum)
            {
                num = maxFormationNum;
            }
            return num;
        }
        
        /** 自動武器選択 */
        public function autoSelectWeapon(lendge:int, terrainAtk:TerrainData, terrainDef:TerrainData, deffender:BattleUnit):MasterWeaponData
        {
            var weaponList:Vector.<MasterWeaponData> = this.masterData.weaponDataList;
            var weaponData:MasterWeaponData = null;
            var i:int = 0;
            for (i = 0; i < weaponList.length; i++)
            {
                if (weaponList[i].minRange <= lendge && lendge <= weaponList[i].maxRange)
                {
                    if (weaponData == null)
                    {
                        weaponData = weaponList[i];
                    }
                    else if (weaponData.value < weaponList[i].value)
                    {
                        weaponData = weaponList[i];
                    }
                }
            }
            
            // 適合する武器を返す
            return weaponData;
        }
        
        /**レベルアップ*/
        override public function levelUp(lv:int):void
        {
            battleLevelSet(nowLv + lv);
        }
        
        /**レベルセット*/
        public function battleLevelSet(lv:int):void
        {
            super.levelSet(lv);
            var i:int = 0;
            
            if (_joinFlg)
            {
                if (_side == 0)
                {
                    for (i = 0; i < MainController.$.model.PlayerUnitData.length; i++)
                    {
                        if (MainController.$.model.PlayerUnitData[i].id == id)
                        {
                            MainController.$.model.PlayerUnitData[i].levelSet(lv);
                            break;
                        }
                    }
                }
            }
        }
        
        /**経験値セット*/
        public function setExp(setExp:int):void
        {
            exp = setExp;
            var i:int = 0;
            if (_joinFlg)
            {
                if (_side == 0)
                {
                    for (i = 0; i < MainController.$.model.PlayerUnitData.length; i++)
                    {
                        if (MainController.$.model.PlayerUnitData[i].id == id)
                        {
                            MainController.$.model.PlayerUnitData[i].exp = setExp;
                            break;
                        }
                    }
                }
            }
        }
        
        public function healHP(num:int):void
        {
            _nowHp += num;
            if (_nowHp > param.HP)
            {
                _nowHp = param.HP;
            }
            setFormationNumImg();
        }
        
        public function supplyFP(num:int):void
        {
            _nowFp += num;
            if (_nowFp > param.FP)
            {
                _nowFp = param.FP;
            }
        }
        
        /**FP消費*/
        public function useFP(num:int):void
        {
            _nowFp -= num;
        }
        
        /**レベルセット*/
        override public function levelSet(lv:int):void
        {
            var i:int = 0;
            super.levelSet(lv);
            for (i = 0; i < BaseParam.STATUS_STR.length; i++)
            {
                switch (BaseParam.STATUS_STR[i])
                {
                case "HP": 
                case "FP": 
                    this.param[BaseParam.STATUS_STR[i]] += _strengthPoint * 3;
                    break;
                case "MOV": 
                    break;
                default: 
                    this.param[BaseParam.STATUS_STR[i]] += _strengthPoint;
                    break;
                }
            }
            
            buffStatusSet();
        }
        
        /**バフ追加*/
        public function buffAdd(data:SkillBuffData):void
        {
            var i:int = 0;
            var findFlg:Boolean = false;
            //同じ名前のバフがあった場合は効果上書き
            for (i = 0; i < _buffList.length; i++)
            {
                if (_buffList[i].name === data.name)
                {
                    
                    _buffList[i] = null;
                    _buffList[i] = data;
                    
                    findFlg = true;
                    break;
                }
                
            }
            
            //同名のモノが見つからなかった場合は追加
            if (!findFlg)
            {
                _buffList.push(data);
            }
            
            levelSet(_nowLv);
        }
        
        public function levelStatusReset():void
        {
            levelSet(_nowLv);
        }
        
        /**ターン開始時*/
        public function buffTurnCount():void
        {
            var i:int = 0;
            
            for (i = 0; i < _buffList.length; i++)
            {
                //マイナス設定されている者は永続
                if (_buffList[i].turn <= -1)
                {
                    continue;
                }
                
                //ターン開始時、残りターン数を減らす
                _buffList[i].turn--;
                
                //0以下になったものを削除
                if (_buffList[i].turn <= 0)
                {
                    _buffList[i] = null;
                    _buffList.splice(i, 1);
                    i--;
                }
            }
            
            levelSet(_nowLv);
            buffHeal();
        }
        
        /**アクション終了時、残りターン0（1回使用）以下のモノを削除*/
        public function buffActionEnd():void
        {
            var i:int = 0;
            
            for (i = 0; i < _buffList.length; i++)
            {
                //マイナス設定されている者は永続
                if (_buffList[i].turn <= -1)
                {
                    continue;
                }
                
                //0以下になったものを削除
                if (_buffList[i].turn <= 0)
                {
                    _buffList[i] = null;
                    _buffList.splice(i, 1);
                    i--;
                }
            }
            
            levelSet(_nowLv);
        }
        
        /**バフ回復*/
        public function buffHeal():void
        {
            var i:int = 0;
            var learnLv:int = 0;
            
            //パッシブ
            for (i = 0; i < _passiveList.length; i++)
            {
                learnLv = getLearnLevel(_passiveList[i]._levelList);
                if (learnLv > 0)
                {
                    _nowHp += _passiveList[i].buffParam[learnLv]._param.HealHP
                    _nowFp += _passiveList[i].buffParam[learnLv]._param.HealFP
                }
            }
            //バフ
            for (i = 0; i < _buffList.length; i++)
            {
                if (learnLv > 0)
                {
                    var skillLv:int = _buffList[i].skillLv;
                    _nowHp += _buffList[i].buffParam[skillLv]._param.HealHP
                    _nowFp += _buffList[i].buffParam[skillLv]._param.HealFP
                }
            }
            
            //最大値に戻す
            if (_nowFp > param.HP)
            {
                _nowFp = param.HP
            }
            if (_nowFp > param.FP)
            {
                _nowFp = param.FP
            }
        }
        
        /**拾得レベル取得*/
        public function getLearnLevel(data:Vector.<LearnLevelData>):int
        {
            var lv:int = 0;
            var i:int = 0;
            
            for (i = 0; i < data.length; i++)
            {
                if (data[i].learnLevel > _nowLv)
                {
                    lv = data[i].skillLevel;
                    break;
                }
                
            }
            
            return lv;
        }
        
        /**バフステータスセット*/
        public function buffStatusSet():void
        {
            var i:int = 0;
            var j:int = 0;
            var learnLv:int = 0;
            //パッシブ
            for (i = 0; i < _passiveList.length; i++)
            {
                learnLv = getLearnLevel(_passiveList[i]._levelList);
                if (learnLv > 0)
                {
                    for (j = 0; j < BaseParam.STATUS_STR.length; j++)
                    {
                        this.param[BaseParam.STATUS_STR[j]] += _passiveList[i].buffParam[learnLv]._param[BaseParam.STATUS_STR[j]];
                    }                    
                    for (j = 0; j < BaseParam.ADD_STR.length; j++ )
                    {
                        this.param[BaseParam.ADD_STR[j]] += _passiveList[i].buffParam[skillLv]._param[BaseParam.ADD_STR[j]];
                    }
                }
            }
            //バフ
            if (_buffList != null)
            {
                for (i = 0; i < _buffList.length; i++)
                {
                    var skillLv:int = _buffList[i].skillLv;
                    for (j = 0; j < BaseParam.STATUS_STR.length; j++)
                    {
                        this.param[BaseParam.STATUS_STR[j]] += _buffList[i].buffParam[skillLv]._param[BaseParam.STATUS_STR[j]];
                    }
                    
                    for (j = 0; j < BaseParam.ADD_STR.length; j++ )
                    {
                        this.param[BaseParam.ADD_STR[j]] += _buffList[i].buffParam[skillLv]._param[BaseParam.ADD_STR[j]];
                    }
                    
                }
                
            }
        }
        
        /**軍師ステータスセット*/
        public function commanderStatusSet(commander:CommanderData):void
        {
            /**軍師なしの場合戻る*/
            if (commander == null)
            {
                return;
            }
            var i:int = 0;
            for (i = 0; i < BaseParam.STATUS_STR.length; i++)
            {
                this.param[BaseParam.STATUS_STR[i]] += commander.param[BaseParam.STATUS_STR[i]];
            }
        }
        
        //強化ポイント追加
        override public function addStrength(num:int = 1):void
        {
            super.addStrength(num);
            levelSet(_nowLv);
        }
        
        //強化ポイントセット
        override public function setStrength(num:int):void
        {
            super.setStrength(num);
            levelSet(_nowLv);
            _nowHp = param.HP;
            _nowFp = param.FP;
        }
        
        /**編成数*/
        public function setFormationNumImg():void
        {
            if (maxFormationNum <= 1) return;
            var num:int = formationNum;
            if (num <= 0) return;
            var path:String = "unitnum_" + num;
            if (_formationNumImg != null)
            {
                _formationNumImg.texture = MainController.$.imgAsset.getTexture(path);
            }
        }
    
    }

}