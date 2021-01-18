package scene.map
{
    import a24.tween.Tween24;
    import bgm.SingleMusic;
    import common.CommonBattleMath;
    import common.CommonDef;
    import common.util.CharaDataUtil;
    import database.master.MasterBaseData;
    import database.master.MasterCommanderSkillData;
    import database.master.MasterSkillData;
    import database.master.MasterWeaponData;
    import database.user.CommanderData;
    import database.user.GenericUnitData;
    import database.user.UnitCharaData;
    import flash.geom.Point;
    import main.MainController;
    import scene.base.BaseInfo;
    import scene.base.BaseTip;
    import scene.battleanime.BattleActionPanel;
    import scene.map.BaseMap;
    import scene.map.MapPicture;
    import scene.map.battle.BattleResultmanager;
    import scene.map.customdata.EnemyMoveData;
    import scene.map.customdata.SideState;
    import scene.map.panel.BattleMapPanel;
    import scene.map.tip.TerrainData;
    import scene.talk.classdata.MapEventData;
    import scene.talk.message.FaceMessageWindow;
    import scene.unit.BattleUnit;
    import starling.display.DisplayObject;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;
    import starling.textures.TextureSmoothing;
    import system.custom.customSprite.CButton;
    import system.custom.customSprite.CImage;
    import system.custom.customSprite.CSprite;
    import viewitem.status.BattleMapStatus;
    import viewitem.status.ExpWindow;
    import viewitem.status.list.OrganizeList;
    import viewitem.status.list.ProductList;
    import viewitem.status.list.listitem.OrganizeSelectIcon;
    
    /**
     * ...
     * @author
     */
    public class BattleMap extends BaseMap
    {
        
        //-------------------------------------------------------------
        //
        // construction
        //
        //-------------------------------------------------------------
        public static const ACT_TYPE_ATK:int = 1;
        public static const ACT_TYPE_SKILL:int = 2;
        
        public static const FORMATION_NUM_POS:int = 24;
        public static const BATTLE_ANIME_MESSAGE_WINDOW_Y:int = 400;
        //-------------------------------------------------------------
        //
        // component
        //
        //-------------------------------------------------------------
        
        /** 移動領域画像リスト */
        private var _moveAreaImgList:Vector.<CImage> = null;
        /** 攻撃領域画像リスト */
        private var _attackAreaImgList:Vector.<CImage> = null;
        /** 移動ルート画像リスト */
        private var _rootImgList:Vector.<CImage>;
        
        /**マップ絵*/
        private var _mapPictureList:Vector.<MapPicture>;
        
        /**ターゲットユニット*/
        private var _targetUnit:BattleUnit = null;
        
        /**ステータス表示*/
        private var _statusWindow:BattleMapStatus = null;
        
        /**バトルマップコマンドパネル*/
        private var _battleMapPanel:BattleMapPanel = null;
        /**戦闘アニメパネル*/
        private var _battleActionPanel:BattleActionPanel = null;
        
        /**敵選択武器*/
        private var _selectEnemyWeapon:MasterWeaponData = null;
        
        /**戦闘結果マネージャー*/
        private var _battleResultManager:BattleResultmanager = null;
        
        /**移動リセットボタン*/
        private var _btnReset:CButton = null;
        
        /**経験値ゲージ*/
        private var _expGauge:ExpWindow = null;
        /**出撃リスト*/
        private var _organizeList:OrganizeList = null;
        /**コマンダースキル用メッセージウィンドウ*/
        private var _messageWindow:FaceMessageWindow = null;
        
        private var _selectCommanderSkill:MasterCommanderSkillData = null;
        
        /**拠点データパネル*/
        private var _baseInfo:BaseInfo = null;
        
        /**生産画面*/
        private var _productListPanel:ProductList = null;
        //-------------------------------------------------------------
        //
        // variable
        //
        //-------------------------------------------------------------
        
        /** 地形データリスト */
        private var _terrainDataList:Vector.<TerrainData> = null;
        /** 拠点データリスト */
        private var _baseDataList:Vector.<BaseTip> = null;
        /** 勢力ステータス */
        private var _sideState:Vector.<SideState> = null;
        /**拠点表示領域*/
        private var _baseArea:CSprite = null;
        /** ユニット表示領域 */
        private var _unitArea:CSprite = null;
        /** 枠エリア */
        private var _frameArea:CSprite = null;
        /** 効果エリア */
        private var _effectArea:CSprite = null;
        /** ユニット選択番号 */
        private var _selectUnit:int = 0;
        /**選択行動タイプ*/
        private var _selectActType:int = 0;
        /**選択行動ターゲットタイプ*/
        private var _selectActTargetType:int = 0;
        /** 陣営選択番号 */
        private var _selectSide:int = 0;
        /** 敵陣営番号 */
        private var _targetSide:int = 0;
        
        /** 選択中移動X軸 */
        private var _nowMovePosX:int = 0;
        /** 選択中移動Y軸 */
        private var _nowMovePosY:int = 0;
        
        private var _selectMoved:Boolean = false;
        //マップ会話フラグ
        private var _mapTalkFlg:Boolean = false;
        //-------------------------------------------------------------
        //
        // オプション
        //
        //-------------------------------------------------------------
        private var _skyFlg:Boolean = false;
        
        //-------------------------------------------------------------
        //
        // コンストラクタ
        //
        //-------------------------------------------------------------
        public function BattleMap()
        {
            super();
            _moveAreaImgList = new Vector.<CImage>;
            _attackAreaImgList = new Vector.<CImage>;
            _terrainDataList = new Vector.<TerrainData>();
            _baseDataList = new Vector.<scene.base.BaseTip>();
            _rootImgList = new Vector.<CImage>;
            _mapPictureList = new Vector.<MapPicture>;
            _sideState = new Vector.<SideState>;
            _statusWindow = new BattleMapStatus();
            _battleResultManager = new BattleResultmanager();
            _statusWindow.visible = false;
            
            _btnReset = new CButton();
            _btnReset.styleName = "bigBtn";
            _btnReset.alpha = 0;
            _btnReset.width = MAP_SIZE;
            _btnReset.height = MAP_SIZE;
            _btnReset.addEventListener(Event.TRIGGERED, resetMove);
        }
        
        //-------------------------------------------------------------
        //
        // 廃棄
        //
        //-------------------------------------------------------------
        public override function dispose():void
        {
            _btnReset.removeEventListener(Event.TRIGGERED, resetMove);
            removeEventListener(TouchEvent.TOUCH, mouseOperated);
            removeEventListener(TouchEvent.TOUCH, makeRootHandler);
            removeEventListener(TouchEvent.TOUCH, moveAreaHandler);
            removeEventListener(TouchEvent.TOUCH, startAttackHandler);
            removeEventListener(TouchEvent.TOUCH, startMapTalkHandler);
            removeEventListener(TouchEvent.TOUCH, startCommandSkillHandler);
            
            CommonDef.disposeList([_productListPanel, _baseInfo, _battleMapPanel, _baseDataList, _battleActionPanel, _unitArea, _baseArea, _frameArea, _effectArea, _btnReset, _moveAreaImgList, _attackAreaImgList, _rootImgList, _sideState, _mapPictureList, _messageWindow]);
            _btnReset = null;
            _attackAreaImgList = null;
            _terrainDataList = null;
            _moveAreaImgList = null;
            _rootImgList = null;
            _mapPictureList = null;
            super.dispose();
        }
        
        //-------------------------------------------------------------
        //
        // 軍師関連
        //
        //-------------------------------------------------------------
        public function setCommander(sideName:String, commander:CommanderData):void
        {
            // 味方に設定
            if (sideState.length <= 0 || _sideState[0] === null)
            {
                _sideState[0] = new SideState(MainController.$.model.playerParam.sideName);
            }
            
            var i:int = 0;
            var isNewSide:Boolean = true;
            var sideNum:int = 1;
            for (i = 0; i < _sideState.length; i++)
            {
                if (sideName === _sideState[i].name)
                {
                    _sideState[i].setCommander(commander);
                    isNewSide = false;
                    break;
                }
            }
            //新勢力追加
            if (sideNum >= 1 && isNewSide == true)
            {
                sideNum = _sideState.length;
                _sideState[sideNum] = new SideState(sideName);
                _sideState[sideNum].setCommander(commander);
            }
        }
        
        public function clearCommander(sideName:String):void
        {
            var i:int = 0;
            for (i = 0; i < _sideState.length; i++)
            {
                if (sideName === _sideState[i].name)
                {
                    _sideState[i].clearCommander();
                    break;
                }
            }
        }
        
        //-------------------------------------------------------------
        //
        // ユニット関連
        //
        //-------------------------------------------------------------
        
        /**進入地形対応チェック*/
        private function checkMoveEnable(unit:BattleUnit, terrain:TerrainData):Boolean
        {
            var flg:Boolean = true;
            
            //侵入不可地形
            if (terrain.Type == TerrainData.TYPE_NUM[TerrainData.TERRAIN_TYPE_NONE])
            {
                flg = false;
            }
            //空中移動できない場合
            else if (terrain.Type == TerrainData.TYPE_NUM[TerrainData.TERRAIN_TYPE_SKY] && !unit.isFly)
            {
                flg = false;
            }
            else
            {
                //移動コスト取得
                var properCost:int = unit.terrain[terrain.Type];
                //適応不可
                if (properCost == -1)
                {
                    flg = false;
                }
            }
            
            return flg;
        }
        
        /**移動コスト算出*/
        private function checkCost(point:int, cost:int, proper:Vector.<int>, terrain:TerrainData):int
        {
            var moveCost:int = cost;
            var restPoint:int = point;
            var properCost:int = proper[terrain.Type];
            var propCost:int = 0;
            
            //S適正の場合は移動コストは必ず１
            if (properCost == 0)
            {
                moveCost = 1;
            }
            //E適性の場合は1マスのみ
            else if (properCost == 99)
            {
                restPoint = 0;
            }
            //それ以外は適正値に対応
            else
            {
                moveCost += (properCost - 1);
            }
            
            restPoint -= moveCost;
            return restPoint;
        }
        
        /** 戦闘ユニット作成 */
        public function createUnit(name:String, side:String, posX:int, posY:int, level:int, strength:int, param:Object, callBack:Function, animeFlg:Boolean):void
        {
            var newSide:Boolean = true;
            var i:int = 0;
            var sideNum:int = 0;
            
            sideNum = makeNewSide(side);
            // 戦闘ユニット作成
            var battleUnit:BattleUnit;
            
            if (sideNum == 0)
            {
                var joinFlg:int = 1;
                if (param != null && param.hasOwnProperty("join"))
                {
                    joinFlg = param.join;
                }
                
                if (joinFlg)
                {
                    MainController.$.model.addPlayerUnitFromName(name, level, 0, strength, true);
                }
                // 戦闘ユニットデータの設定
                //battleUnit = new BattleUnit(CharaDataUtil.getPlayerCharaForName(name), getNewBattleID());
                
                var newUnitData:UnitCharaData = null;
                if (joinFlg)
                {
                    newUnitData = new UnitCharaData(MainController.$.model.PlayerUnitData.length, CharaDataUtil.getMasterCharaDataName(name), level)
                }
                else
                {
                    newUnitData = new UnitCharaData(1000 + _sideState[sideNum].battleUnit.length, CharaDataUtil.getMasterCharaDataName(name), level)
                }
                battleUnit = new BattleUnit(newUnitData, getNewBattleID(), 0);
                battleUnit.setStrength(strength);
                if (joinFlg == 0)
                {
                    battleUnit.joinFlg = false;
                }
                newUnitData.launched = true;
            }
            else
            {
                // 戦闘ユニットデータの設定
                battleUnit = new BattleUnit(new UnitCharaData(_sideState[sideNum].battleUnit.length, CharaDataUtil.getMasterCharaDataName(name), level), getNewBattleID(), sideNum);
                battleUnit.levelSet(level);
                battleUnit.setStrength(strength);
            }
            
            battleUnit.frameImg = new CImage(MainController.$.imgAsset.getTexture(_sideState[sideNum].frameImgPath));
            
            if (param != null && param.hasOwnProperty("id"))
            {
                battleUnit.nameId = param.id;
            }
            
            if (param != null && param.hasOwnProperty("label"))
            {
                battleUnit.talkLabel = param.label;
            }
            
            //ユニット数の設定
            if (battleUnit.maxFormationNum >= 2)
            {
                battleUnit.formationNumImg = new CImage(MainController.$.imgAsset.getTexture("unitnum_" + battleUnit.maxFormationNum));
            }
            
            battleUnit.commanderStatusSet(_sideState[sideNum].commander);
            // マップ位置をセットをセット
            unitSetMap(battleUnit, sideNum, posX, posY, animeFlg, callBack);
        }
        
        /** 味方ユニット出撃 */
        public function launchUnit(name:String, posX:int, posY:int, param:Object, callBack:Function, animeFlg:Boolean):void
        {
            var newSide:Boolean = true;
            var i:int = 0;
            var sideNum:int = 0;
            
            // 味方に設定
            if (sideState.length <= 0 || _sideState[0] === null)
            {
                _sideState[0] = new SideState(MainController.$.model.playerParam.sideName);
            }
            sideNum = 0;
            
            // 戦闘ユニット作成
            var battleUnit:BattleUnit;
            var charaData:UnitCharaData = CharaDataUtil.getPlayerCharaForName(name);
            charaData.launched = true;
            // 戦闘ユニットデータの設定
            battleUnit = new BattleUnit(charaData, getNewBattleID(), 0);
            battleUnit.frameImg = new CImage(MainController.$.imgAsset.getTexture(_sideState[0].frameImgPath));
            
            if (param.hasOwnProperty("id"))
            {
                battleUnit.nameId = param.id;
            }
            
            if (param.hasOwnProperty("label"))
            {
                battleUnit.talkLabel = param.label;
            }
            
            //ユニット数の設定
            if (battleUnit.maxFormationNum >= 2)
            {
                battleUnit.formationNumImg = new CImage(MainController.$.imgAsset.getTexture("unitnum_" + battleUnit.maxFormationNum));
            }
            
            battleUnit.commanderStatusSet(_sideState[sideNum].commander);
            // マップ位置をセットをセット
            unitSetMap(battleUnit, sideNum, posX, posY, animeFlg, callBack);
        }
        
        /**ユニット会話ラベル変更*/
        public function setUnitTalkLabel(name:String, id:String, label:String):void
        {
            var i:int = 0;
            var j:int = 0;
            var endFlg:Boolean;
            //IDで検索
            for (i = 0; i < _sideState.length; i++)
            {
                for (j = 0; j < _sideState[i].battleUnit.length; j++)
                {
                    if (id != null)
                    {
                        if (_sideState[i].battleUnit[j].nameId === id)
                        {
                            _sideState[i].battleUnit[j].talkLabel = label;
                            endFlg = true;
                            break;
                        }
                    }
                    else if (name != null)
                    {
                        if (_sideState[i].battleUnit[j].name === name)
                        {
                            _sideState[i].battleUnit[j].talkLabel = label;
                            endFlg = true;
                            break;
                        }
                    }
                }
                
                if (endFlg)
                {
                    break;
                }
            }
        }
        
        private function unitSetMap(battleUnit:BattleUnit, sideNum:int, posX:int, posY:int, anime:Boolean, callBack:Function):void
        {
            setLaunchCheck(battleUnit, posX, posY);
            posX = battleUnit.PosX;
            posY = battleUnit.PosY;
            
            // 画像とフレームの位置を追加
            battleUnit.unitImg.x = (posX - 1) * MAP_SIZE + (anime ? 32 : 0);
            battleUnit.unitImg.y = (posY - 1) * MAP_SIZE;
            battleUnit.unitImg.alpha = anime ? 0 : 1;
            battleUnit.frameImg.x = (posX - 1) * MAP_SIZE;
            battleUnit.frameImg.y = (posY - 1) * MAP_SIZE;
            battleUnit.frameImg.alpha = anime ? 0 : 1;
            if (battleUnit.formationNumImg != null)
            {
                battleUnit.formationNumImg.x = (posX - 1) * MAP_SIZE + FORMATION_NUM_POS;
                battleUnit.formationNumImg.y = (posY - 1) * MAP_SIZE + FORMATION_NUM_POS;
                battleUnit.frameImg.alpha = anime ? 0 : 1;
            }
            
            // 戦闘ユニットを勢力に追加
            _sideState[sideNum].addUnit(battleUnit);
            // ユニットエリアに画像追加
            _unitArea.addChildAt(battleUnit.unitImg, _unitArea.numChildren);
            // フレームエリアに沸く追加
            _frameArea.addChildAt(battleUnit.frameImg, _frameArea.numChildren);
            
            // フレームエリアに数字追加
            if (battleUnit.formationNumImg != null)
            {
                _effectArea.addChildAt(battleUnit.formationNumImg, _effectArea.numChildren);
            }
            
            if (anime)
            {
                // 一定時間かけて表示
                var tweenAry:Array = new Array();
                var tweenUnit:Tween24 = Tween24.tween(battleUnit.unitImg, 0.3).x((posX - 1) * MAP_SIZE).alpha(1);
                if (battleUnit.frameImg != null)
                {
                    var tweenFrame:Tween24 = Tween24.tween(battleUnit.frameImg, 0.3).alpha(1);
                }
                
                //tweenAry.push(launchParticle(posX, posY));
                tweenAry.push(tweenUnit);
                tweenAry.push(tweenFrame);
                
                if (battleUnit.formationNumImg != null)
                {
                    var tweenNum:Tween24 = Tween24.tween(battleUnit.formationNumImg, 0.3).alpha(1);
                    tweenAry.push(tweenNum);
                }
                _targetUnit = battleUnit;
                Tween24.parallel(tweenAry).onComplete(callBack).play();
            }
            else
            {
                callBack();
            }
        
        }
        
        /**出撃位置調整*/
        public function setLaunchCheck(unit:BattleUnit, posX:int, posY:int):void
        {
            if (judgeUnitLaunch(posX, posY))
            {
                unit.PosX = posX;
                unit.PosY = posY;
            }
            else
            {
                aroundLaunchCheck(unit, posX, posY, 1);
            }
        }
        
        /**周囲の出撃*/
        public function aroundLaunchCheck(unit:BattleUnit, posX:int, posY:int, count:int):void
        {
            var i:int = 0;
            var j:int = 0;
            var checkFlg:Boolean = true;
            
            if (count > _mapWidth && count >= _mapHeight)
            {
                MainController.$.view.errorMessageEve("ID:" + unit.id + "_" + unit.name + "は出撃出来ませんでした", 1);
                return;
            }
            
            for (i = -count; i <= count; i++)
            {
                for (j = -count; j <= count; j++)
                {
                    if (Math.abs(i + j) != count)
                    {
                        continue;
                    }
                    var setX:int = posX + j;
                    var setY:int = posY + i;
                    
                    //幅を超えていたら調査しない
                    if (setX < 0 || setX >= _mapWidth || setY < 0 || setY >= _mapHeight)
                    {
                        continue;
                    }
                    
                    //出撃位置の調査
                    if (judgeUnitLaunch(setX, setY))
                    {
                        unit.PosX = setX;
                        unit.PosY = setY;
                        checkFlg = false;
                        break;
                    }
                }
                if (!checkFlg)
                {
                    break;
                }
            }
            if (checkFlg)
            {
                count++;
                aroundLaunchCheck(unit, posX, posY, count);
            }
        }
        
        /**出撃可能チェック*/
        public function judgeUnitLaunch(posX:int, posY:int):Boolean
        {
            var i:int = 0;
            var j:int = 0;
            var posNum:int = posY * _mapWidth + posX;
            var moveList:TerrainData = _terrainDataList[posNum];
            
            //移動可能地形で無いのなら
            //if (!moveList.MoveEnable)
            if (false)
            {
                return false;
            }
            else
            {
                //全ユニットの位置を調査
                for (i = 0; i < _sideState.length; i++)
                {
                    for (j = 0; j < _sideState[i].battleUnit.length; j++)
                    {
                        //同一位置があると選択不可
                        if (_sideState[i].battleUnit[j].PosX == posX && _sideState[i].battleUnit[j].PosY == posY)
                        {
                            return false;
                        }
                    }
                }
            }
            return true;
        }
        
        /** 対象ユニット撤退 */
        public function escapeUnit(name:String, side:String, param:Object, callBack:Function):void
        {
            var newSide:Boolean = true;
            var i:int = 0;
            var sideNum:int = 0;
            
            // 味方は0に設置
            if (side === MainController.$.model.playerParam.sideName)
            {
                sideNum = 0;
            }
            else
            {
                for (i = 1; i < _sideState.length; i++)
                {
                    // 既存の勢力に追加
                    if (side === _sideState[i].name)
                    {
                        sideNum = i;
                        break;
                    }
                }
            }
            
            var targetUnit:BattleUnit = null;
            for (i = 0; i < _sideState[sideNum].battleUnit.length; i++)
            {
                
                if (_sideState[sideNum].battleUnit[i].name === name)
                {
                    targetUnit = _sideState[sideNum].battleUnit[i];
                    break;
                }
                
            }
            
            // 一定時間かけて表示
            var tweenAry:Array = new Array();
            var tweenUnit:Tween24 = Tween24.tween(targetUnit.unitImg, 0.3).fadeOut();
            var tweenFrame:Tween24 = Tween24.tween(targetUnit.frameImg, 0.3).fadeOut();
            tweenAry.push(tweenUnit);
            tweenAry.push(tweenFrame);
            if (targetUnit.formationNumImg != null)
            {
                var tweenNumImg:Tween24 = Tween24.tween(targetUnit.formationNumImg, 0.3).fadeOut();
                tweenAry.push(tweenNumImg);
            }
            //tweenAry.push(launchParticle(targetUnit.PosX, targetUnit.PosY));
            Tween24.parallel(tweenAry).onComplete(compEscape).play();
            
            function compEscape():void
            {
                // 戦闘ユニットを勢力に追加
                targetUnit.onMap = false;
                // ユニットエリアの画像排除
                _unitArea.removeChild(targetUnit.unitImg);
                // フレームエリアの枠排除
                _frameArea.removeChild(targetUnit.frameImg);
                if (targetUnit.formationNumImg != null)
                {
                    _effectArea.removeChild(targetUnit.formationNumImg);
                }
                
                targetUnit.dispose();
                callBack();
            }
        }
        
        /** 対象陣営撤退 */
        public function escapeSide(side:String, param:Object, callBack:Function):void
        {
            var newSide:Boolean = true;
            var i:int = 0;
            var sideNum:int = 0;
            
            // 味方は0に設置
            if (side === MainController.$.model.playerParam.sideName)
            {
                sideNum = 0;
            }
            else
            {
                for (i = 1; i < _sideState.length; i++)
                {
                    // 既存の勢力に追加
                    if (side === _sideState[i].name)
                    {
                        sideNum = i;
                        break;
                    }
                }
            }
            
            var tweenAry:Array = new Array();
            for (i = 0; i < _sideState[sideNum].battleUnit.length; i++)
            {
                var targetUnit:BattleUnit = _sideState[sideNum].battleUnit[i];
                
                // 一定時間かけて表示
                var tweenUnit:Tween24 = Tween24.tween(targetUnit.unitImg, 0.3).fadeOut();
                var tweenFrame:Tween24 = Tween24.tween(targetUnit.frameImg, 0.3).fadeOut();
                tweenAry.push(tweenUnit);
                tweenAry.push(tweenFrame);
                if (targetUnit.formationNumImg != null)
                {
                    var tweenNumImg:Tween24 = Tween24.tween(targetUnit.formationNumImg, 0.3).fadeOut();
                    tweenAry.push(tweenNumImg);
                }
                    //tweenAry.push(launchParticle(targetUnit.PosX, targetUnit.PosY));
                
            }
            
            Tween24.parallel(tweenAry).onComplete(compEscape).play();
            
            function compEscape():void
            {
                for (i = 0; i < _sideState[sideNum].battleUnit.length; i++)
                {
                    var targetUnit:BattleUnit = _sideState[sideNum].battleUnit[i];
                    // 戦闘ユニットを勢力に追加
                    targetUnit.onMap = false;
                    // ユニットエリアの画像排除
                    _unitArea.removeChild(targetUnit.unitImg);
                    // フレームエリアの枠排除
                    _frameArea.removeChild(targetUnit.frameImg);
                    if (targetUnit.formationNumImg != null)
                    {
                        _effectArea.removeChild(targetUnit.formationNumImg);
                    }
                    
                    targetUnit.dispose();
                }
                callBack();
            }
        }
        
        /**出撃リスト*/
        public function organizeUnit(count:int, posX:int, posY:int, width:int, height:int, type:String):void
        {
            if (_organizeList != null)
            {
                _organizeList.dispose();
                _organizeList = null;
            }
            
            _organizeList = new OrganizeList(MainController.$.model.PlayerUnitData, MainController.$.model.playerGenericUnitData, count, posX, posY, width, height, type);
            MainController.$.view.addChild(_organizeList);
        }
        
        /**出撃セット*/
        public function startOrganized(unitList:Vector.<OrganizeSelectIcon>):void
        {
            MainController.$.view.removeChild(_organizeList);
            var i:int = 0;
            var posX:int = 0;
            var posY:int = 0;
            var nowPosX:int = _organizeList.posX;
            var nowPosY:int = _organizeList.posY;
            var addPos:int = 0;
            var launchTweenArray:Array = new Array();
            var launchCount:int = 0;
            
            for (i = 0; i < unitList.length; i++)
            {
                // 戦闘ユニット作成
                var battleUnit:BattleUnit;
                var charaData:UnitCharaData;
                
                //ネームドユニット
                if (unitList[i].unitCharaData != null)
                {
                    charaData = unitList[i].unitCharaData;
                    // 戦闘ユニットデータの設定
                    battleUnit = new BattleUnit(charaData, getNewBattleID(), 0);
                }
                //汎用ユニット
                else if (unitList[i].genericUnitData != null)
                {
                    charaData = new UnitCharaData(1000 + _sideState[0].battleUnit.length, unitList[i].genericUnitData.data, unitList[i].genericUnitData.lv);
                    battleUnit = new BattleUnit(charaData, getNewBattleID(), 0);
                }
                
                charaData.launched = true;
                battleUnit.frameImg = new CImage(MainController.$.imgAsset.getTexture(_sideState[0].frameImgPath));
                
                //ユニット数の設定
                if (battleUnit.maxFormationNum >= 2)
                {
                    battleUnit.formationNumImg = new CImage(MainController.$.imgAsset.getTexture("unitnum_" + battleUnit.maxFormationNum));
                }
                
                // マップ位置をセットをセット
                setLaunchCheck(battleUnit, nowPosX, nowPosY);
                posX = battleUnit.PosX;
                posY = battleUnit.PosY;
                // 画像とフレームの位置を追加
                battleUnit.unitImg.x = (posX) * MAP_SIZE;
                battleUnit.unitImg.y = (posY - 1) * MAP_SIZE;
                battleUnit.unitImg.alpha = 0;
                battleUnit.frameImg.x = (posX - 1) * MAP_SIZE;
                battleUnit.frameImg.y = (posY - 1) * MAP_SIZE;
                battleUnit.frameImg.alpha = 0;
                if (battleUnit.formationNumImg != null)
                {
                    battleUnit.formationNumImg.x = (posX - 1) * MAP_SIZE + FORMATION_NUM_POS;
                    battleUnit.formationNumImg.y = (posY - 1) * MAP_SIZE + FORMATION_NUM_POS;
                    battleUnit.formationNumImg.alpha = 0;
                }
                
                // 戦闘ユニットを勢力に追加
                _sideState[0].addUnit(battleUnit);
                // ユニットエリアに画像追加
                _unitArea.addChildAt(battleUnit.unitImg, _unitArea.numChildren);
                // フレームエリアに枠追加
                _frameArea.addChildAt(battleUnit.frameImg, _frameArea.numChildren);
                if (battleUnit.formationNumImg != null)
                {
                    // フレームエリアに数字追加
                    _effectArea.addChildAt(battleUnit.formationNumImg, _effectArea.numChildren);
                }
                
                // 一定時間かけて表示
                var tweenAry:Array = new Array();
                var tweenUnit:Tween24 = Tween24.tween(battleUnit.unitImg, 0.3).x((posX - 1) * MAP_SIZE).alpha(1);
                var tweenFrame:Tween24 = Tween24.tween(battleUnit.frameImg, 0.3).alpha(1);
                tweenAry.push(tweenUnit);
                tweenAry.push(tweenFrame);
                
                if (battleUnit.formationNumImg != null)
                {
                    var tweenFormationNum:Tween24 = Tween24.tween(battleUnit.formationNumImg, 0.3).alpha(1);
                    tweenAry.push(tweenFormationNum);
                }
                
                //tweenAry.push(launchParticle(posX, posY));
                
                launchTweenArray.push(tweenAry);
                //Tween24.parallel(tweenAry).onComplete(callBack).play();
                //ライン整頓
                nowPosX += 2;
                if (nowPosX >= _organizeList.posX + _organizeList.uWidth)
                {
                    if (addPos == 0)
                    {
                        addPos = 1;
                        nowPosX = _organizeList.posX + addPos;
                    }
                    else
                    {
                        addPos = 0;
                        nowPosX = _organizeList.posX + addPos;
                    }
                    nowPosY += 1;
                }
                
                if (nowPosY > _organizeList.posY + _organizeList.uHeight)
                {
                    break;
                }
                
            }
            
            organizeLaunch();
            
            function organizeLaunch():void
            {
                if (launchCount < launchTweenArray.length)
                {
                    Tween24.parallel(launchTweenArray[launchCount]).onComplete(nextLaunch).play();
                }
                else
                {
                    compOrganized();
                }
            
            }
            
            function nextLaunch():void
            {
                
                launchCount++;
                organizeLaunch();
            }
        
        }
        
        /**出撃完了*/
        public function compOrganized():void
        {
            _organizeList.dispose()
            _organizeList = null;
            MainController.$.view.eveManager.compOrganized();
        
        }
        
        // 新規戦闘ユニットID取得
        public function getNewBattleID():int
        {
            var idCount:int = 0;
            var i:int = 0;
            
            // 戦闘ユニットIDを設定
            for (i = 0; i < _sideState.length; i++)
            {
                if (_sideState[i] != null)
                {
                    idCount += _sideState[i].battleUnit.length;
                }
            }
            return idCount;
        }
        
        /**ステータス画面表示*/
        private function showStatusWindow(unit:BattleUnit = null, customBgmFlg:Boolean = true):void
        {
            if (unit != null)
            {
                _statusWindow.setCharaData(unit, customBgmFlg);
            }
            //addChild(_statusWindow);
            _statusWindow.visible = true;
            MainController.$.view.addChild(_statusWindow);
        }
        
        /**軍師ステータス画面表示*/
        public function showCommanderStatusWindow(sideNumber:int):void
        {
            _statusWindow.setCommanderData(_sideState[sideNumber].commander);
            //addChild(_statusWindow);
            _statusWindow.visible = true;
            MainController.$.view.addChild(_statusWindow);
            
            if (_mapTalkFlg)
            {
                _battleMapPanel.showPanel(BattleMapPanel.PANEL_COMMANDER_DETAIL);
            }
            else
            {
                _battleMapPanel.showPanel(BattleMapPanel.PANEL_COMMANDER);
            }
            MainController.$.view.addChild(_battleMapPanel);
        }
        
        /**ステータス画面非表示*/
        private function hideStatusWindow():void
        {
            _statusWindow.visible = false;
            MainController.$.view.removeChild(_statusWindow);
        }
        
        //-------------------------------------------------------------
        //
        // ユニット移動関連
        //
        //-------------------------------------------------------------
        
        /**移動エリア設置*/
        public function moveAreaSet():void
        {
            addChild(_btnReset);
            var list:Vector.<String> = new Vector.<String>;
            setDrag(false);
            _battleMapPanel.showPanel(BattleMapPanel.PANEL_MOVE);
            MainController.$.view.addChild(_battleMapPanel);
        
            //remakeMoveArea(unit.PosX - 1, unit.PosY - 1, 5, list);
        }
        
        /** 移動パネル・戻る */
        public function backMove():void
        {
            _selectMoved = false;
            removeChild(_btnReset);
            
            deleteMoveImg();
            
            var unit:BattleUnit = _sideState[_selectSide].battleUnit[_selectUnit];
            unit.resetImgPos();
            
            var i:int = 0;
            _nowMovePosX = 0;
            _nowMovePosY = 0;
            terrainDataReset();
            if (_mapTalkFlg)
            {
                _battleMapPanel.showPanel(BattleMapPanel.PANEL_MAP_TALK);
            }
            else
            {
                _battleMapPanel.showPanel(BattleMapPanel.PANEL_SYSTEM);
            }
            MainController.$.view.addChild(_battleMapPanel);
        }
        
        /** 移動終了 */
        private function endMove(moveData:EnemyMoveData = null):void
        {
            var i:int = 0;
            
            var unit:BattleUnit = _sideState[_selectSide].battleUnit[_selectUnit];
            unit.PosX = _nowMovePosX + 1;
            unit.PosY = _nowMovePosY + 1;
            
            _nowMovePosX = 0;
            _nowMovePosY = 0;
            terrainDataReset();
            checkMoveAttack(moveData);
        }
        
        private function checkMoveAttack(moveData:EnemyMoveData):void
        {
            // 味方以外の時は攻撃選択
            if (_selectSide > 0)
            {
                enemyAttack(moveData);
            }
            // 攻撃フラグが立っているときは戦闘前イベント検索
            else if (_battleResultManager.attackFlg)
            {
                if (_selectSide == 0)
                {
                    SingleMusic.playBattleBGM(nowBattleUnit.customBgmHeadPath, 1, 1);
                }
                else if (_targetSide == 0)
                {
                    SingleMusic.playBattleBGM(_targetUnit.customBgmHeadPath, 1, 1);
                }
                else
                {
                    SingleMusic.playBattleBGM(nowBattleUnit.customBgmHeadPath, 1, 1);
                }
                //attackAction();
                MainController.$.view.eveManager.searchMapBattleEvent(nowBattleUnit, _targetUnit, _selectSide, _targetSide, attackAction, MapEventData.TYPE_BATTLE_BEFORE);
            }
            // 攻撃しない時はマップ進入イベント検索
            else
            {
                MainController.$.view.eveManager.searchMapMoveEvent(nowBattleUnit, _selectSide, ActionAllEnd, MapEventData.TYPE_MATH_IN);
            }
        }
        
        private function ActionAllEnd():void
        {
            if (_selectSide == 0)
            {
                _battleMapPanel.showPanel(BattleMapPanel.PANEL_SYSTEM);
            }
            else
            {
                _battleMapPanel.showPanel(BattleMapPanel.PANEL_NONE);
            }
            MainController.$.view.addChild(_battleMapPanel);
            //移動終了処理
            nowBattleUnit.moveEnd();
            //行動終了時のバフ残存判定
            nowBattleUnit.buffActionEnd();
            
            //軍師ステータス追加
            if (_sideState[nowBattleUnit.side].commander != null)
            {
                nowBattleUnit.commanderStatusSet(_sideState[nowBattleUnit.side].commander);
            }
            
            // 移動完了後の処理
            if (_selectSide == 0)
            {
                
            }
            else
            {
                enemyAct();
            }
        }
        
        /**ユニット移動実行処理*/
        private function moveUnit(moveData:EnemyMoveData = null):void
        {
            var i:int;
            
            if (moveTwn != null)
            {
                moveTwn.stop();
                moveTwn = null;
            }
            //Tween24.tween(_battleUnit[_selectSide][_selectUnit].unitImg, 0.3, Tween24.ease.QuadOut).xy(posX * MAP_SIZE, posY * MAP_SIZE).play();
            
            var posNum:int = _nowMovePosY * _mapWidth + _nowMovePosX;
            var unit:BattleUnit = _sideState[_selectSide].battleUnit[_selectUnit];
            var moveList:TerrainData = _terrainDataList[posNum];
            
            if (moveList.MoveDirrection == null)
            {
                return;
            }
            
            unit.unitImg.x = (unit.PosX - 1) * MAP_SIZE;
            unit.unitImg.y = (unit.PosY - 1) * MAP_SIZE;
            var count:int = 0;
            var countX:int = 0;
            var countY:int = 0;
            var moveTwn:Tween24;
            var twnlist:Array = new Array();
            // タイル移動
            function moveUnitTile():void
            {
                var moveX:int = 0;
                var moveY:int = 0;
                
                if (count < moveList.MoveDirrection.length)
                {
                    // １マスずつ移動
                    switch (moveList.MoveDirrection[count])
                    {
                    case "right": 
                        countX++;
                        break;
                    case "left": 
                        countX--;
                        break;
                    case "down": 
                        countY++;
                        break;
                    case "up": 
                        countY--;
                        break;
                    }
                    count++;
                    
                    twnlist[0] = Tween24.tween(unit.unitImg, 0.1, Tween24.ease.Linear);
                    twnlist[0].xy((unit.PosX + countX - 1) * MAP_SIZE, (unit.PosY + countY - 1) * MAP_SIZE);
                    twnlist[1] = Tween24.tween(unit.frameImg, 0.1, Tween24.ease.Linear);
                    twnlist[1].xy((unit.PosX + countX - 1) * MAP_SIZE, (unit.PosY + countY - 1) * MAP_SIZE);
                    if (unit.formationNumImg != null)
                    {
                        twnlist[2] = Tween24.tween(unit.formationNumImg, 0.1, Tween24.ease.Linear);
                        twnlist[2].xy((unit.PosX + countX - 1) * MAP_SIZE + FORMATION_NUM_POS, (unit.PosY + countY - 1) * MAP_SIZE + FORMATION_NUM_POS);
                    }
                    
                    moveTwn = Tween24.parallel(twnlist);
                    moveTwn.onComplete(moveUnitTile);
                    moveTwn.play();
                }
                else
                {
                    // 移動終了
                    twnlist[0] = Tween24.tween(unit.unitImg, 0.1, Tween24.ease.QuadOut);
                    twnlist[0].xy(_nowMovePosX * MAP_SIZE, _nowMovePosY * MAP_SIZE);
                    twnlist[1] = Tween24.tween(unit.frameImg, 0.1, Tween24.ease.QuadOut);
                    twnlist[1].xy(_nowMovePosX * MAP_SIZE, _nowMovePosY * MAP_SIZE);
                    
                    if (unit.formationNumImg != null)
                    {
                        twnlist[2] = Tween24.tween(unit.formationNumImg, 0.1, Tween24.ease.QuadOut);
                        twnlist[2].xy(_nowMovePosX * MAP_SIZE + FORMATION_NUM_POS, _nowMovePosY * MAP_SIZE + FORMATION_NUM_POS);
                    }
                    
                    moveTwn = Tween24.parallel(twnlist);
                    moveTwn.onComplete(endMove, moveData);
                    moveTwn.play();
                }
            
            }
            moveUnitTile();
        }
        
        /**ユニット移動可否フラグ*/
        public function moveEnable():Boolean
        {
            if (_sideState[0].battleUnit[_selectUnit].PosX == (_nowMovePosX + 1) && _sideState[0].battleUnit[_selectUnit].PosY == (_nowMovePosY + 1))
            {
                return false;
            }
            
            return true;
        }
        
        //-------------------------------------------------------------
        //
        // 武器リスト
        //
        //-------------------------------------------------------------
        
        /**武器リスト表示*/
        public function showWeaponList():void
        {
            removeChild(_btnReset);
            _battleMapPanel.showPanel(BattleMapPanel.PANEL_WEAPON);
            MainController.$.view.addChild(_battleMapPanel);
        }
        
        /**スキルリスト表示*/
        public function showSkillList():void
        {
            removeChild(_btnReset);
            _battleMapPanel.showPanel(BattleMapPanel.PANEL_SKILL);
            MainController.$.view.addChild(_battleMapPanel);
        }
        
        /**武器リスト戻る*/
        public function removeWeaponList():void
        {
            visibleMoveAreaImg(true);
            visibleRootAreaImg(true);
            _battleMapPanel.showPanel(BattleMapPanel.PANEL_MOVE);
            MainController.$.view.addChild(_battleMapPanel);
        }
        
        /**スキルリスト戻る*/
        public function removeSkillList():void
        {
            visibleMoveAreaImg(true);
            visibleRootAreaImg(true);
            _battleMapPanel.showPanel(BattleMapPanel.PANEL_MOVE);
            MainController.$.view.addChild(_battleMapPanel);
        }
        
        //-------------------------------------------------------------
        //
        // 軍師リスト
        //
        //-------------------------------------------------------------
        
        /**軍師スキルリスト表示*/
        public function showCommanderSkillList():void
        {
            _battleMapPanel.showPanel(BattleMapPanel.PANEL_COMMANDER_SKILL);
            MainController.$.view.addChild(_battleMapPanel);
        }
        
        /**軍師スキルリスト戻る*/
        public function removeCommanderSkillList():void
        {
            showCommanderStatusWindow(0);
            _battleMapPanel.showPanel(BattleMapPanel.PANEL_COMMANDER);
            MainController.$.view.addChild(_battleMapPanel);
        }
        
        /** 軍師パネル・戻る */
        public function backCommander():void
        {
            _selectMoved = false;
            removeChild(_btnReset);
            
            deleteMoveImg();
            
            var unit:BattleUnit = _sideState[_selectSide].battleUnit[_selectUnit];
            unit.resetImgPos();
            
            var i:int = 0;
            _nowMovePosX = 0;
            _nowMovePosY = 0;
            terrainDataReset();
            if (_mapTalkFlg)
            {
                _battleMapPanel.showPanel(BattleMapPanel.PANEL_MAP_TALK);
            }
            else
            {
                _battleMapPanel.showPanel(BattleMapPanel.PANEL_SYSTEM);
            }
            MainController.$.view.addChild(_battleMapPanel);
        }
        
        /**軍師スキルターゲット選択戻る*/
        public function backCommanderTarget():void
        {
            removeAttackAreaImg();
            _battleMapPanel.showPanel(BattleMapPanel.PANEL_COMMANDER_SKILL);
            MainController.$.view.addChild(_battleMapPanel);
        }
        
        /**軍師スキル範囲作成*/
        public function makeCommanderSkillArea(data:MasterCommanderSkillData, target:int = MasterSkillData.SKILL_TARGET_ALL):void
        {
            _battleMapPanel.commanderSkillTargetPanel.toAllTarget(data.toAll);
            _selectCommanderSkill = data;
            _selectActType = ACT_TYPE_SKILL;
            _selectActTargetType = target;
            visibleMoveAreaImg(false);
            visibleRootAreaImg(false);
            
            for (var i:int = 0; i < _sideState.length; i++)
            {
                //味方は飛ばす
                if (i == 0 && data.target === MasterCommanderSkillData.SKILL_TARGET_ENEMY)
                {
                    continue;
                }
                
                for (var j:int = 0; j < _sideState[i].battleUnit.length; j++)
                {
                    var unit:BattleUnit = _sideState[i].battleUnit[j];
                    var pos:int = unit.mathPosY * _mapWidth + unit.mathPosX;
                    var terrain:TerrainData = _terrainDataList[pos];
                    
                    //マップ上に居れば対象にする
                    if (unit.onMap)
                    {
                        terrain.isAttackSelect = true;
                    }
                }
                
                //味方以外は飛ばす
                if (i == 0 && data.target === MasterCommanderSkillData.SKILL_TARGET_ALLY)
                {
                    break;
                }
            }
            
            /** 攻撃範囲パネルセット */
            attackAreaPanelSet();
            _battleMapPanel.showPanel(BattleMapPanel.PANEL_COMMANDER_SKILL_TARGET);
            MainController.$.view.addChild(_battleMapPanel);
        }
        
        /** 軍師スキルターゲット選択判定 */
        private function startCommandSkillHandler(e:TouchEvent):void
        {
            if (_selectCommanderSkill.toAll == true)
            {
                return;
            }
            
            var i:int;
            var target:BattleMap = e.currentTarget as BattleMap;
            var pos:Point;
            
            var myTouch:Touch = e.getTouch(target, TouchPhase.BEGAN);
            if (myTouch)
            {
                pos = globalToLocal(new Point(myTouch.globalX, myTouch.globalY));
                commanderSkillStart(pos);
            }
        }
        
        /**攻撃開始*/
        private function commanderSkillStart(pos:Point):void
        {
            var endFlg:Boolean = false;
            var i:int = 0;
            var j:int = 0;
            var posX:int = pos.x / MAP_SIZE;
            var posY:int = pos.y / MAP_SIZE;
            
            // 攻撃選択可能位置でなければ選べない
            if (!_terrainDataList[posY * _mapWidth + posX].isAttackSelect)
            {
                return;
            }
            
            // マップ内から、対象ユニット位置を検索
            for (i = 0; i < _sideState.length; i++)
            {
                for (j = 0; j < _sideState[i].battleUnit.length; j++)
                {
                    if (_sideState[i].battleUnit[j].PosX == posX + 1 && _sideState[i].battleUnit[j].PosY == posY + 1 && _sideState[i].battleUnit[j].onMap)
                    {
                        // ターゲット陣営設定
                        _targetSide = i;
                        // ターゲット設定
                        _targetUnit = sideState[i].battleUnit[j];
                        SingleMusic.playBattleBGM(_sideState[_selectSide].commander.customBgmHeadPath, 1, 1);
                        
                        endFlg = true;
                        break;
                    }
                }
                if (endFlg)
                {
                    break;
                }
            }
            //軍師スキル実行・メッセージ開始
            startCommanderMessage();
        }
        
        public function executeToAllCommanderSkill():void
        {
            SingleMusic.playBattleBGM(_sideState[_selectSide].commander.customBgmHeadPath, 1, 1);
            startCommanderMessage();
        }
        
        //軍師メッセージ
        private function startCommanderMessage():void
        {
            _battleMapPanel.showPanel(BattleMapPanel.PANEL_NONE);
            
            _messageWindow = new FaceMessageWindow();
            _messageWindow.x = (CommonDef.WINDOW_W - _messageWindow.width) / 2;
            _messageWindow.y = BATTLE_ANIME_MESSAGE_WINDOW_Y;
            _messageWindow.deleteImage();
            _messageWindow.deleteText();
            MainController.$.view.addChild(_messageWindow);
            
            playMessage();
        }
        
        public var messageCount:int = 0;
        public var commanderCharaMessage:Boolean = false;
        
        /**メッセージセット*/
        private function playMessage():void
        {
            var charaName:String = _sideState[_selectSide].commander.name;
            var message:Vector.<String> = MainController.$.model.getRandamCommanderSkillMessage(_sideState[_selectSide].commander, _selectCommanderSkill, _targetUnit);
            
            _messageWindow.clearText();
            _messageWindow.alpha = 0;
            var strCount:int = message[0].length;
            
            var tweenAry:Array = new Array();
            var tween:Tween24 = Tween24.tween(this, strCount * 0.02, null, {messageCount: message[0].length}).onUpdate(msgUpdate, message);
            
            messageCount = 0;
            _messageWindow.clearText();
            if (commanderCharaMessage)
            {
                _messageWindow.setImage(_sideState[_selectSide].commander.name, null);
            }
            else
            {
                _messageWindow.setImage("システム", null);
            }
            tweenAry.push(Tween24.tween(_messageWindow, 0.3).fadeIn());
            tweenAry.push(tween);
            tweenAry.push(Tween24.wait(1));
            tweenAry.push(Tween24.tween(_messageWindow, 0.3).fadeOut());
            
            Tween24.serial(tweenAry).onComplete(setCommanderSkillEffect).play();
        }
        
        /**メッセージアップデート*/
        private function msgUpdate(message:Vector.<String>):void
        {
            _messageWindow.setText(message[0].substr(0, messageCount));
        }
        
        //軍師スキルエフェクト
        private function setCommanderSkillEffect():void
        {
            var i:int = 0, j:int = 0;
            //メッセージウィンドウ破棄
            _messageWindow.dispose();
            _messageWindow = null;
            
            //個別効果
            if (_selectCommanderSkill.toAll == 0)
            {
                CommonBattleMath.commanderSkillEffect(_targetUnit, _selectCommanderSkill);
            }
            //全体効果
            else
            {
                for (i = 0; i < _sideState.length; i++)
                {
                    //敵軍に効果があるスキルを、自軍で飛ばす
                    if (_selectSide == i && _selectCommanderSkill.target == MasterCommanderSkillData.SKILL_TARGET_ENEMY)
                    {
                        continue;
                    }
                    //自軍のみに効果があるスキルを、自軍以外で飛ばす
                    else if (_selectSide != i && _selectCommanderSkill.target == MasterCommanderSkillData.SKILL_TARGET_ALLY)
                    {
                        continue;
                    }
                    
                    for (j = 0; j < _sideState[i].battleUnit.length; j++)
                    {
                        CommonBattleMath.commanderSkillEffect(_sideState[i].battleUnit[j], _selectCommanderSkill);
                    }
                }
            }
            
            _sideState[_selectSide].commander.usePoint(_selectCommanderSkill.useSp);
            
            endCommanderSkill();
        }
        
        /**軍師スキル終了*/
        private function endCommanderSkill():void
        {
            terrainDataReset();
            removeAttackAreaImg();
            if (_mapTalkFlg)
            {
                _battleMapPanel.showPanel(BattleMapPanel.PANEL_MAP_TALK);
            }
            else
            {
                _battleMapPanel.showPanel(BattleMapPanel.PANEL_SYSTEM);
            }
            MainController.$.view.addChild(_battleMapPanel);
        }
        
        //-------------------------------------------------------------
        //
        // 範囲パネル関連
        //
        //-------------------------------------------------------------
        
        /** 移動範囲
         * @param x 横位置
         * @param y 縦位置
         * @param proper 地形適性
         * @param dirrection 向き
         * @param dirrectionList これまでの移動方向
         * */
        private function checkMoveArea(unit:BattleUnit, posX:int, posY:int, baseX:int, baseY:int, point:int, dirrection:String, dirrectionList:Vector.<String>, aiMove:Vector.<EnemyMoveData> = null):void
        {
            if (point <= 0) return;
            if (posX < 0) return;
            if (posY < 0) return;
            if (posX >= _mapWidth) return;
            if (posY >= _mapHeight) return;
            if (posX == baseX && posY == baseY)
            {
                return;
            }
            
            //移動先にユニットが居るか
            var sideOn:Boolean = false;
            
            var i:int = 0;
            var j:int = 0;
            //全軍検索
            for (i = 0; i < _sideState.length; i++)
            {
                //各軍のユニット検索
                for (j = 0; j < _sideState[i].battleUnit.length; j++)
                {
                    //移動先にユニットが居る
                    if (_sideState[i].battleUnit[j].PosX == posX + 1 && _sideState[i].battleUnit[j].PosY == posY + 1 && _sideState[i].battleUnit[j].onMap)
                    {
                        if (_selectSide == i)
                        {
                            sideOn = true;
                            break;
                        }
                        else
                        {
                            return;
                        }
                    }
                }
                
                if (sideOn)
                {
                    break;
                }
            }
            
            //位置取得
            var pos:int = posY * _mapWidth + posX;
            //地形データ取得
            var terrain:TerrainData = _terrainDataList[pos];
            //コスト取得
            var cost:int = terrain.Cost;
            //移動コスト計算
            if (checkMoveEnable(unit, terrain))
            {
                //地形に応じて移動ポイント計算
                point = checkCost(point, cost, unit.terrain, terrain);
            }
            else
            {
                //侵入不可の場合
                return;
            }
            
            //point -= cost;
            dirrectionList.push(dirrection);
            // 未選択であれば移動可能に
            if (!terrain.MoveChecked && !terrain.RootSelected && !sideOn)
            {
                var img:CImage = new CImage(CommonDef.MOVE_TIP_TEX);
                img.x = posX * MAP_SIZE;
                img.y = posY * MAP_SIZE;
                addChildAt(img, getChildIndex(_unitArea) - 1);
                _moveAreaImgList.push(img);
                terrain.MoveCount = point;
                terrain.MoveChecked = true;
                terrain.moveClone(dirrectionList);
                
                if (aiMove != null)
                {
                    var moveTarget:EnemyMoveData = new EnemyMoveData();
                    moveTarget.getPriority(posX, posY, nowBattleUnit, _sideState, _selectSide);
                    aiMove.push(moveTarget);
                }
            }
            // 移動可能時
            else
            {
                // もっと効率のいいポイントがあれば更新
                if (terrain.MoveCount < point)
                {
                    terrain.MoveCount = point;
                    terrain.moveClone(dirrectionList);
                }
                // 無ければ検索終了
                else
                {
                    return;
                }
            }
            
            // 次の移動ポイントを検索
            if (point > 0)
            {
                checkMoveArea(unit, posX + 1, posY, baseX, baseY, point, "right", cloneList(dirrectionList), aiMove);
                checkMoveArea(unit, posX - 1, posY, baseX, baseY, point, "left", cloneList(dirrectionList), aiMove);
                checkMoveArea(unit, posX, posY + 1, baseX, baseY, point, "down", cloneList(dirrectionList), aiMove);
                checkMoveArea(unit, posX, posY - 1, baseX, baseY, point, "up", cloneList(dirrectionList), aiMove);
            }
        }
        
        /**移動エリア配置*/
        private function makeMoveArea(pos:Point):void
        {
            var i:int = 0;
            var j:int = 0;
            var posX:int = pos.x / MAP_SIZE;
            var posY:int = pos.y / MAP_SIZE;
            hideStatusWindow();
            
            //ユニット検索
            for (i = 0; i < _sideState.length; i++)
            {
                for (j = 0; j < _sideState[i].battleUnit.length; j++)
                {
                    if (_sideState[i].battleUnit[j].PosX == posX + 1 && _sideState[i].battleUnit[j].PosY == posY + 1 && _sideState[i].battleUnit[j].onMap)
                    {
                        
                        _btnReset.x = posX * MAP_SIZE;
                        _btnReset.y = posY * MAP_SIZE;
                        
                        var unit:BattleUnit = _sideState[i].battleUnit[j];
                        var list:Vector.<String> = new Vector.<String>;
                        if (i == 0)
                        {
                            showStatusWindow(unit, true);
                        }
                        else
                        {
                            showStatusWindow(unit, false);
                        }
                        _selectSide = i;
                        _selectUnit = j;
                        setCenterPos(posX, posY);
                        remakeMoveArea(unit, unit.PosX - 1, unit.PosY - 1, unit.param.MOV, list, i);
                        var funcList:Vector.<Function> = new Vector.<Function>;
                        if (i == 0 && unit.moveEnable())
                        {
                            _battleMapPanel.showPanel(BattleMapPanel.PANEL_COMMAND);
                        }
                        else
                        {
                            _battleMapPanel.showPanel(BattleMapPanel.PANEL_COMMAND_ENEMY);
                        }
                        MainController.$.view.addChild(_battleMapPanel);
                        return;
                    }
                }
            }
            
            //拠点イベント検索
            var sideName:String = "";
            for (i = 0; i < _baseDataList.length; i++)
            {
                if (_baseDataList[i].posX == posX + 1 && _baseDataList[i].posY == posY + 1)
                {
                    var sideNum:int = _baseDataList[i].sideNum;
                    if (sideNum >= 0)
                    {
                        sideName = _sideState[sideNum].name;
                    }
                    _baseInfo = new BaseInfo(_baseDataList[i], sideName, callProductUnit, callCloseBaseInfo);
                    MainController.$.view.addChild(_baseInfo);
                    return;
                }
            }
        }
        
        private function callProductUnit(data:BaseTip):void
        {
            _productListPanel = new ProductList(MainController.$.model.playerGenericUnitData, data, productFunc, productClose);
            MainController.$.view.addChild(_productListPanel);
            
            if (_baseInfo != null)
            {
                
                MainController.$.view.removeChild(_baseInfo);
                _baseInfo.dispose();
                _baseInfo = null;
            }
        }
        
        private function productFunc(genericData:GenericUnitData, baseData:BaseTip):void
        {
            if (_productListPanel != null)
            {
                MainController.$.view.removeChild(_productListPanel);
                _productListPanel.dispose();
                _productListPanel = null;
            }
            
            setTouchEvent(BattleMapPanel.PANEL_NONE);
            
            _battleMapPanel.showPanel(BattleMapPanel.PANEL_NONE);
            createUnit(genericData.name, MainController.$.model.playerParam.sideName, baseData.posX, baseData.posY, genericData.lv, 0, null, productCreateComp, true);
        }
        
        private function productCreateComp():void
        {
            setTouchEvent(BattleMapPanel.PANEL_SYSTEM);
            _battleMapPanel.showPanel(BattleMapPanel.PANEL_SYSTEM);
            _targetUnit.moveZero();
        }
        
        private function productClose():void
        {
            if (_productListPanel != null)
            {
                MainController.$.view.removeChild(_productListPanel);
                _productListPanel.dispose();
                _productListPanel = null;
            }
        }
        
        private function callCloseBaseInfo():void
        {
            if (_baseInfo != null)
            {
                MainController.$.view.removeChild(_baseInfo);
                _baseInfo.dispose();
                _baseInfo = null;
            }
        }
        
        /**移動エリア再作成*/
        private function remakeMoveArea(unit:BattleUnit, posX:int, posY:int, move:int, movelist:Vector.<String>, side:int = 0, aiMove:Vector.<EnemyMoveData> = null):void
        {
            var i:int = 0;
            _nowMovePosX = posX;
            _nowMovePosY = posY;
            
            //setCenterPos(posX, posY);
            checkMoveArea(unit, posX + 1, posY, posX, posY, move, "right", cloneList(movelist), aiMove);
            checkMoveArea(unit, posX - 1, posY, posX, posY, move, "left", cloneList(movelist), aiMove);
            checkMoveArea(unit, posX, posY + 1, posX, posY, move, "down", cloneList(movelist), aiMove);
            checkMoveArea(unit, posX, posY - 1, posX, posY, move, "up", cloneList(movelist), aiMove);
        }
        
        /**移動ルート作成*/
        private function makeRootArea(point_x:int, point_y:int, phase:String):void
        {
            var i:int;
            var posX:int = point_x / MAP_SIZE;
            var posY:int = point_y / MAP_SIZE;
            var posNum:int = posY * _mapWidth + posX;
            
            if (_terrainDataList[posNum].MoveChecked)
            {
                _selectMoved = true;
                var unit:BattleUnit = _sideState[_selectSide].battleUnit[_selectUnit];
                
                var moveList:TerrainData = _terrainDataList[posNum];
                
                var countX:int = 0;
                var countY:int = 0;
                
                removeRootImg();
                
                for (i = 0; i < moveList.MoveDirrection.length; i++)
                {
                    // １マスずつ移動
                    switch (moveList.MoveDirrection[i])
                    {
                    case "right": 
                        countX++;
                        break;
                    case "left": 
                        countX--;
                        break;
                    case "down": 
                        countY++;
                        break;
                    case "up": 
                        countY--;
                        break;
                    }
                    var terrainPos:int = (unit.PosX + countX - 1) + (unit.PosY + countY - 1) * _mapWidth;
                    var img:CImage = new CImage(CommonDef.ROOT_TIP_TEX);
                    img.x = (unit.PosX + countX - 1) * MAP_SIZE;
                    img.y = (unit.PosY + countY - 1) * MAP_SIZE;
                    addChildAt(img, getChildIndex(_unitArea) - 1);
                    _terrainDataList[terrainPos].RootSelected = true;
                    _rootImgList.push(img);
                }
                // 移動範囲初期化
                removeMoveAreaImg();
                
                // 移動不可設定
                for (i = 0; i < _terrainDataList.length; i++)
                {
                    _terrainDataList[i].MoveChecked = false;
                }
                
                remakeMoveArea(unit, unit.PosX + countX - 1, unit.PosY + countY - 1, _terrainDataList[posNum].MoveCount, moveList.MoveDirrection);
            }
            else if (_terrainDataList[posNum].RootSelected && phase === TouchPhase.BEGAN)
            {
                setCenterPos(posX, posY);
            }
        }
        
        //-------------------------------------------------------------
        //
        // 攻撃範囲
        //
        //-------------------------------------------------------------
        /**攻撃範囲作成*/
        public function makeAttackArea(data:MasterWeaponData):void
        {
            _selectActType = ACT_TYPE_ATK;
            visibleMoveAreaImg(false);
            visibleRootAreaImg(false);
            
            var pos:int = _nowMovePosY * _mapWidth + _nowMovePosX;
            var terrain:TerrainData = _terrainDataList[pos];
            
            checkAttackArea(_nowMovePosX + 1, _nowMovePosY, _nowMovePosX, _nowMovePosY, data.minRange, data.maxRange);
            checkAttackArea(_nowMovePosX - 1, _nowMovePosY, _nowMovePosX, _nowMovePosY, data.minRange, data.maxRange);
            checkAttackArea(_nowMovePosX, _nowMovePosY + 1, _nowMovePosX, _nowMovePosY, data.minRange, data.maxRange);
            checkAttackArea(_nowMovePosX, _nowMovePosY - 1, _nowMovePosX, _nowMovePosY, data.minRange, data.maxRange);
            /** 攻撃範囲パネルセット */
            attackAreaPanelSet();
            _battleMapPanel.showPanel(BattleMapPanel.PANEL_SELECT_TARGET);
            MainController.$.view.addChild(_battleMapPanel);
        }
        
        /**スキル範囲作成*/
        public function makeSkillArea(data:MasterSkillData, target:int = MasterSkillData.SKILL_TARGET_ALL):void
        {
            _selectActType = ACT_TYPE_SKILL;
            _selectActTargetType = target;
            visibleMoveAreaImg(false);
            visibleRootAreaImg(false);
            
            var pos:int = _nowMovePosY * _mapWidth + _nowMovePosX;
            var terrain:TerrainData = _terrainDataList[pos];
            
            if (data.minRange == 0)
            {
                checkZeroArea(_nowMovePosX, _nowMovePosY);
            }
            
            checkAttackArea(_nowMovePosX + 1, _nowMovePosY, _nowMovePosX, _nowMovePosY, data.minRange, data.maxRange);
            checkAttackArea(_nowMovePosX - 1, _nowMovePosY, _nowMovePosX, _nowMovePosY, data.minRange, data.maxRange);
            checkAttackArea(_nowMovePosX, _nowMovePosY + 1, _nowMovePosX, _nowMovePosY, data.minRange, data.maxRange);
            checkAttackArea(_nowMovePosX, _nowMovePosY - 1, _nowMovePosX, _nowMovePosY, data.minRange, data.maxRange);
            /** 攻撃範囲パネルセット */
            attackAreaPanelSet();
            _battleMapPanel.showPanel(BattleMapPanel.PANEL_SELECT_SKILL_TARGET);
            MainController.$.view.addChild(_battleMapPanel);
        }
        
        /**攻撃範囲ボタンから戻る*/
        public function backAttackArea():void
        {
            if (_selectSide == 0)
            {
                removeAttackAreaImg();
                if (_selectActType == ACT_TYPE_ATK)
                {
                    _battleMapPanel.showPanel(BattleMapPanel.PANEL_WEAPON);
                }
                else if (_selectActType == ACT_TYPE_SKILL)
                {
                    _battleMapPanel.showPanel(BattleMapPanel.PANEL_SKILL);
                }
                _battleResultManager.initAttack();
                MainController.$.view.addChild(_battleMapPanel);
            }
            else
            {
                _battleResultManager.popAttack();
                // 戦闘予測画面に切り替え
                _battleMapPanel.showPanel(BattleMapPanel.PANEL_COUNTER_WEAPON);
            }
        }
        
        /** 攻撃範囲パネルセット */
        private function attackAreaPanelSet():void
        {
            var i:int = 0;
            for (i = 0; i < _terrainDataList.length; i++)
            {
                if (_terrainDataList[i].isAttackSelect)
                {
                    var posX:int = i % _mapWidth;
                    var posY:int = i / _mapWidth;
                    
                    var img:CImage = new CImage(CommonDef.ROOT_TIP_TEX);
                    img.x = posX * MAP_SIZE;
                    img.y = posY * MAP_SIZE;
                    addChildAt(img, getChildIndex(_unitArea) - 1);
                    _attackAreaImgList.push(img);
                }
            }
        }
        
        /**ゼロ位置選択セット*/
        private function checkZeroArea(posX:int, posY:int):void
        {
            var pos:int = posY * _mapWidth + posX;
            var terrain:TerrainData = _terrainDataList[pos];
            terrain.isAttackSelect = true;
        }
        
        /** 攻撃範囲設定
         * @param posX 現在地の横位置
         * @param posY 現在地の縦位置
         * @param baseY 原点横位置
         * @param baseY 原点縦位置
         * @param minrange 最低射程
         * @param point 残り範囲
         * */
        private function checkAttackArea(posX:int, posY:int, baseX:int, baseY:int, minRange:int, point:int):void
        {
            if (point <= 0) return;
            if (posX < 0) return;
            if (posY < 0) return;
            if (posX >= _mapWidth) return;
            if (posY >= _mapHeight) return;
            if (posX == baseX && posY == baseY)
            {
                return;
            }
            
            var pos:int = posY * _mapWidth + posX;
            var terrain:TerrainData = _terrainDataList[pos];
            // 範囲消費コスト
            var cost:int = 1;
            point -= cost;
            minRange -= cost;
            
            // 近い射程の場合
            if (point >= terrain.AttackRangePoint)
            {
                terrain.AttackRangePoint = point;
                // 最低射程以上ならば設置
                if (minRange <= 0)
                {
                    terrain.isAttackSelect = true;
                }
                // そうでなければ設置しない
                else
                {
                    terrain.isAttackSelect = false;
                }
            }
            
            // 次の移動ポイントを検索
            if (point > 0)
            {
                checkAttackArea(posX + 1, posY, baseX, baseY, minRange, point);
                checkAttackArea(posX - 1, posY, baseX, baseY, minRange, point);
                checkAttackArea(posX, posY + 1, baseX, baseY, minRange, point);
                checkAttackArea(posX, posY - 1, baseX, baseY, minRange, point);
            }
        }
        
        //-------------------------------------------------------------
        //
        // 攻撃処理
        //
        //-------------------------------------------------------------
        
        /**攻撃開始*/
        private function attackStart(pos:Point):void
        {
            var endFlg:Boolean = false;
            var i:int = 0;
            var j:int = 0;
            var posX:int = pos.x / MAP_SIZE;
            var posY:int = pos.y / MAP_SIZE;
            
            // 攻撃選択可能位置でなければ選べない
            if (!_terrainDataList[posY * _mapWidth + posX].isAttackSelect)
            {
                return;
            }
            
            // マップ内から、対象ユニット位置を検索
            for (i = 0; i < _sideState.length; i++)
            {
                if (i == 0 && _selectActType == ACT_TYPE_ATK)
                {
                    continue;
                }
                
                for (j = 0; j < _sideState[i].battleUnit.length; j++)
                {
                    
                    if (_sideState[i].battleUnit[j].PosX == posX + 1 && _sideState[i].battleUnit[j].PosY == posY + 1 && _sideState[i].battleUnit[j].onMap)
                    {
                        
                        /**スキル選択時、対象タイプが一致してなければ選べない*/
                        if (_selectActType == ACT_TYPE_SKILL)
                        {
                            if (i == 0 && _battleMapPanel.skillPanel.selectSkill.target == MasterSkillData.SKILL_TARGET_ENEMY)
                            {
                                endFlg = true;
                                break;
                            }
                            
                            if (i != 0 && _battleMapPanel.skillPanel.selectSkill.target == MasterSkillData.SKILL_TARGET_ALLY)
                            {
                                endFlg = true;
                                break;
                            }
                        }
                        // ターゲット陣営設定
                        _targetSide = i;
                        // ターゲット設定
                        _targetUnit = sideState[i].battleUnit[j];
                        // 移動先の位置をセット
                        _battleResultManager.setMovePos(_nowMovePosX, _nowMovePosY);
                        //戦闘選択
                        if (_selectActType == ACT_TYPE_ATK)
                        {
                            // 反撃武器を選択
                            var targetWeapon:MasterWeaponData = _battleResultManager.counterAutoSelect(nowBattleUnit, _targetUnit, true);
                            // 攻撃棋譜を追加
                            _battleResultManager.addAttack(nowBattleUnit, _selectSide, _battleMapPanel.weaponPanel.selectWeapon, _targetUnit, targetWeapon);
                            // 反撃棋譜を追加
                            _battleResultManager.addCounterAttack(_targetUnit, i, targetWeapon, nowBattleUnit, _battleMapPanel.weaponPanel.selectWeapon);
                            
                            // 戦闘予測画面に切り替え
                            _battleMapPanel.showPanel(BattleMapPanel.PANEL_PREDICTION);
                            // 攻撃データをセット
                            _battleMapPanel.setPrediction(_battleResultManager.attackWeaponList);
                            MainController.$.view.addChild(_battleMapPanel);
                                // 以降攻撃選択後にしたい
                                //_battleResultManager.attackFlg = true;
                                //startMove();
                        }
                        //スキル選択
                        else if (_selectActType == ACT_TYPE_SKILL)
                        {
                            var flg:Boolean = false;
                            //満タン時使用不可
                            if (_battleMapPanel.skillPanel.selectSkill.heal > 0 && _targetUnit.nowHp < _targetUnit.param.HP)
                            {
                                flg = true;
                            }
                            if (_battleMapPanel.skillPanel.selectSkill.supply > 0 && _targetUnit.nowFp < _targetUnit.param.FP)
                            {
                                flg = true;
                            }
                            
                            //スキル
                            if (_battleMapPanel.skillPanel.selectSkill.buff != null)
                            {
                                flg = true;
                            }
                            
                            //終了フラグ
                            if (!flg)
                            {
                                endFlg = true;
                                break;
                            }
                            
                            _battleResultManager.addSkill(nowBattleUnit, _selectSide, _battleMapPanel.skillPanel.selectSkill, _targetUnit);
                            // 戦闘予測画面に切り替え
                            _battleMapPanel.showPanel(BattleMapPanel.PANEL_PREDICTION);
                            // 攻撃データをセット
                            _battleMapPanel.setPrediction(_battleResultManager.attackWeaponList);
                            MainController.$.view.addChild(_battleMapPanel);
                        }
                        
                        if (_selectSide == 0)
                        {
                            SingleMusic.playBattleBGM(nowBattleUnit.customBgmHeadPath, 1, 1);
                        }
                        else if (_targetSide == 0)
                        {
                            SingleMusic.playBattleBGM(_targetUnit.customBgmHeadPath, 1, 1);
                        }
                        else
                        {
                            SingleMusic.playBattleBGM(nowBattleUnit.customBgmHeadPath, 1, 1);
                        }
                        
                        endFlg = true;
                        break;
                    }
                }
                if (endFlg)
                {
                    break;
                }
                
            }
        }
        
        /**攻撃開始呼び出し*/
        public function callAttackStart():void
        {
            _battleResultManager.attackFlg = true;
            if (_selectSide == 0)
            {
                startMove();
            }
            else
            {
                enemyAttackStart();
            }
        }
        
        /**攻撃*/
        private function attackAction():void
        {
            var weapon:MasterWeaponData = _battleMapPanel.weaponPanel.selectWeapon;
            
            // 戦闘計算開始
            _battleResultManager.makeRecord();
            
            if (_battleActionPanel == null)
            {
                _battleActionPanel = new BattleActionPanel();
            }
            deleteMoveImg();
            _battleMapPanel.showPanel(BattleMapPanel.PANEL_NONE);
            
            _battleActionPanel.alpha = 0;
            _battleActionPanel.visible = true;
            //_battleActionPanel.setUnit(nowBattleUnit, _targetUnit);
            _battleActionPanel.startBattleAnime(_battleResultManager.attackRecord, endBattleAnime);
            MainController.$.view.addChild(_battleActionPanel);
        
        }
        
        /**スキル使用*/
        private function skillAction():void
        {
            //スキル使用
            //_battleResultManager.useSkill(skillParticleEff, endSkillAction);
        }
        
        private function skillParticleEff(posX:int, posY:int):void
        {
            // 一定時間かけて表示
            var tweenAry:Array = new Array();
            //tweenAry.push(launchParticle(posX, posY));
            Tween24.parallel(tweenAry).play();
        }
        
        private function endSkillAction():void
        {
            refreshBattleRecord();
            removeMoveAreaImg();
            removeAttackAreaImg();
            _battleMapPanel.showPanel(BattleMapPanel.PANEL_NONE);
            Tween24.wait(0.5).onComplete(nextEndAct).play();
            
            function nextEndAct():void
            {
                //removeDeadChara();
                getExp();
            }
        }
        
        /**移動画像消去*/
        private function deleteMoveImg():void
        {
            
            removeRootImg();
            removeMoveAreaImg();
            removeAttackAreaImg();
        }
        
        /**攻撃アニメ終了*/
        private function endBattleAnime():void
        {
            refreshBattleRecord();
            
            Tween24.tween(_battleActionPanel, 0.4).fadeOut().onComplete(elaseBattleAnime).play();
            
            function elaseBattleAnime():void
            {
                _battleActionPanel.alpha = 0;
                _battleActionPanel.visible = false;
                MainController.$.view.removeChild(_battleActionPanel);
                //プレイヤー側の攻撃バフ消し
                nowBattleUnit.buffActionEnd();
                //相手側の単発バフ消し
                _targetUnit.buffActionEnd();
                
                //軍師ステータス追加
                if (_sideState[nowBattleUnit.side].commander != null)
                {
                    nowBattleUnit.commanderStatusSet(_sideState[nowBattleUnit.side].commander);
                }
                
                //軍師ステータス追加
                if (_sideState[_targetUnit.side].commander != null)
                {
                    _targetUnit.commanderStatusSet(_sideState[_targetUnit.side].commander);
                }
                
                removeDeadChara();
            }
        }
        
        /** 撃破キャラ削除 */
        private function removeDeadChara():void
        {
            var unit:BattleUnit = null;
            var i:int = 0;
            var j:int = 0;
            for (i = 0; i < _sideState.length; i++)
            {
                for (j = 0; j < _sideState[i].battleUnit.length; j++)
                {
                    // 撃破ユニット設定
                    unit = _sideState[i].battleUnit[j];
                    // 撃破されたらイベント検索
                    if (unit.nowHp <= 0 && unit.onMap)
                    {
                        _unitArea.removeChild(unit.unitImg);
                        _frameArea.removeChild(unit.frameImg);
                        _effectArea.removeChild(unit.formationNumImg);
                    }
                }
            }
            getExp();
        }
        
        private function searchDefeatEvent():void
        {
            var unit:BattleUnit = null;
            var eventFlg:Boolean = false;
            var side:int = 0;
            var i:int = 0;
            var j:int = 0;
            for (i = 0; i < _sideState.length; i++)
            {
                for (j = 0; j < _sideState[i].battleUnit.length; j++)
                {
                    // 撃破ユニット設定
                    unit = _sideState[i].battleUnit[j];
                    // 撃破されたらイベント検索
                    if (unit.nowHp <= 0 && unit.onMap)
                    {
                        unit.alive = false;
                        unit.onMap = false;
                        side = i;
                        eventFlg = true;
                        break;
                    }
                }
                if (eventFlg)
                {
                    break;
                }
            }
            
            if (eventFlg)
            {
                MainController.$.view.eveManager.searchDefeatEvent(unit, _sideState[i].name, searchDefeatEvent, MapEventData.TYPE_DEFEAT);
            }
            else
            {
                checkExtinction();
            }
        }
        
        /**経験値取得*/
        private function getExp():void
        {
            MainController.$.model.playerParam.money += _battleResultManager.getMoney;
            //経験値取得時
            if (_battleResultManager.getExp > 0)
            {
                var expTarget:BattleUnit = null;
                
                for (var i:int = 0; i < _sideState[0].battleUnit.length; i++)
                {
                    if (_sideState[0].battleUnit[i].battleId == _battleResultManager.expId)
                    {
                        expTarget = _sideState[0].battleUnit[i];
                        break;
                    }
                }
                
                if (expTarget.nowLv < expTarget.masterData.MaxLv)
                {
                    _expGauge = new ExpWindow();
                    _expGauge.setNowPoint(expTarget.exp);
                    _expGauge.setText(expTarget.masterData.nickName, _battleResultManager.getExp, _battleResultManager.getMoney);
                    _expGauge.x = (CommonDef.WINDOW_W - _expGauge.width) / 2;
                    _expGauge.y = (CommonDef.WINDOW_H - _expGauge.height) / 2;
                    MainController.$.view.addChild(_expGauge);
                    _expGauge.addPoint(_battleResultManager.getExp, lvUpCheck);
                }
                else
                {
                    searchDefeatEvent();
                }
            }
            else
            {
                searchDefeatEvent();
            }
            
            function lvUpCheck():void
            {
                var lvCount:int = _expGauge.getLvUp();
                expTarget.setExp(_expGauge.getExp());
                
                //レベルアップ処理
                if (lvCount > 0)
                {
                    MainController.$.view.removeChild(_expGauge);
                    _expGauge.dispose();
                    _expGauge = null;
                    showLvUpWindow(expTarget, lvCount);
                }
                else
                {
                    MainController.$.view.removeChild(_expGauge);
                    _expGauge.dispose();
                    _expGauge = null;
                    searchDefeatEvent();
                }
            }
        }
        
        /**レベルアップウィンドウ表示*/
        private function showLvUpWindow(unit:BattleUnit, lvUp:int, sideNum:int = 0):void
        {
            var img:CImage = null;
            showStatusWindow(unit, false);
            _statusWindow.visible = true;
            
            //ホワイトインアウト用
            img = new CImage(MainController.$.imgAsset.getTexture("tex_white"));
            img.textureSmoothing = TextureSmoothing.NONE;
            img.width = CommonDef.WINDOW_W;
            img.height = CommonDef.WINDOW_H;
            img.alpha = 0;
            MainController.$.view.addChild(img);
            
            Tween24.serial(Tween24.wait(1.0), Tween24.tween(img, 0.3).fadeIn().onComplete(lvUpUnit), Tween24.tween(img, 0.3).fadeOut(), Tween24.wait(1.5)).onComplete(lvUpEnd).play();
            
            function lvUpUnit():void
            {
                unit.levelUp(lvUp);
                unit.commanderStatusSet(_sideState[sideNum].commander);
                _statusWindow.setCharaData(unit, false);
            }
            
            function lvUpEnd():void
            {
                MainController.$.view.removeChild(img);
                img.dispose();
                img = null;
                hideStatusWindow();
                searchDefeatEvent();
            }
        
        }
        
        /**全滅判定*/
        private function checkExtinction():void
        {
            var i:int = 0;
            var j:int = 0;
            var liveCount:int = 0;
            var checkSide:String = null;
            
            for (i = 0; i < _sideState.length; i++)
            {
                liveCount = 0;
                if (_sideState[i].state == SideState.STATE_DEAD)
                {
                    continue;
                }
                for (j = 0; j < _sideState[i].battleUnit.length; j++)
                {
                    if (_sideState[i].battleUnit[j].onMap)
                    {
                        liveCount++;
                    }
                }
                
                if (liveCount == 0)
                {
                    _sideState[i].state = SideState.STATE_DEAD;
                    checkSide = _sideState[i].name;
                    break;
                }
            }
            
            if (checkSide != null)
            {
                MainController.$.view.eveManager.searchExtinctionEvent(checkSide, checkExtinction, MapEventData.TYPE_EXTINCTION);
            }
            else
            {
                endBattle();
            }
        }
        
        /***/
        private function endBattle():void
        {
            terrainDataReset();
            _battleResultManager.attackFlg = false;
            MainController.$.view.eveManager.searchMapMoveEvent(nowBattleUnit, _selectSide, ActionAllEnd, MapEventData.TYPE_MATH_IN);
        }
        
        /**棋譜初期化*/
        private function refreshBattleRecord():void
        {
            var i:int = 0;
            if (_battleResultManager.attackRecord != null)
            {
                _battleResultManager.initRecord();
            }
        }
        
        //-------------------------------------------------------------
        //
        // タッチイベント eventHandler
        //
        //-------------------------------------------------------------
        
        /** パネル用タッチイベント設定 */
        public function setTouchEvent(type:int):void
        {
            removeEventListener(TouchEvent.TOUCH, mouseOperated);
            removeEventListener(TouchEvent.TOUCH, makeRootHandler);
            removeEventListener(TouchEvent.TOUCH, moveAreaHandler);
            removeEventListener(TouchEvent.TOUCH, startAttackHandler);
            removeEventListener(TouchEvent.TOUCH, startMapTalkHandler);
            removeEventListener(TouchEvent.TOUCH, startCommandSkillHandler);
            switch (type)
            {
            //システムパネル
            case BattleMapPanel.PANEL_SYSTEM: 
                hideStatusWindow();
                addEventListener(TouchEvent.TOUCH, mouseOperated);
                addEventListener(TouchEvent.TOUCH, moveAreaHandler);
                break;
            //コマンドパネル
            case BattleMapPanel.PANEL_COMMAND: 
                //addEventListener(TouchEvent.TOUCH, mouseOperated);
                //addEventListener(TouchEvent.TOUCH, moveAreaHandler);
                break;
            //移動パネル
            case BattleMapPanel.PANEL_MOVE: 
                hideStatusWindow();
                _selectMoved = false;
                addEventListener(TouchEvent.TOUCH, makeRootHandler);
                break;
            //攻撃対象選択
            case BattleMapPanel.PANEL_SELECT_TARGET: 
                addEventListener(TouchEvent.TOUCH, mouseOperated);
                addEventListener(TouchEvent.TOUCH, startAttackHandler);
                break;
            //スキル対象選択
            case BattleMapPanel.PANEL_SELECT_SKILL_TARGET: 
                addEventListener(TouchEvent.TOUCH, mouseOperated);
                addEventListener(TouchEvent.TOUCH, startAttackHandler);
                break;
            //マップ会話
            case BattleMapPanel.PANEL_MAP_TALK: 
                hideStatusWindow();
                addEventListener(TouchEvent.TOUCH, mouseOperated);
                addEventListener(TouchEvent.TOUCH, startMapTalkHandler);
                break;
            //軍師スキルリスト
            case BattleMapPanel.PANEL_COMMANDER:
                
                break;
            case BattleMapPanel.PANEL_COMMANDER_SKILL:
                
                hideStatusWindow();
                break;
            case BattleMapPanel.PANEL_COMMANDER_SKILL_TARGET: 
                addEventListener(TouchEvent.TOUCH, mouseOperated);
                addEventListener(TouchEvent.TOUCH, startCommandSkillHandler);
                break;
            }
        }
        
        /**マップ位置表示*/
        override protected function mouseOperated(eventObject:TouchEvent):void
        {
            var target:DisplayObject = eventObject.currentTarget as DisplayObject;
            var myTouch:Touch = eventObject.getTouch(target, TouchPhase.HOVER);
            if (myTouch)
            {
                var i:int = 0;
                var pos:Point = globalToLocal(new Point(myTouch.globalX, myTouch.globalY));
                var posX:int = Math.floor(pos.x / MAP_SIZE) + 1;
                var posY:int = Math.floor(pos.y / MAP_SIZE) + 1;
                _battleMapPanel.setShowPos(posX, posY);
            }
            super.mouseOperated(eventObject);
        }
        
        /** 移動エリア作成 */
        private function moveAreaHandler(e:TouchEvent):void
        {
            var i:int;
            var target:BattleMap = e.currentTarget as BattleMap;
            var pos:Point;
            
            var myTouch:Touch = e.getTouch(target, TouchPhase.BEGAN);
            if (myTouch)
            {
                pos = globalToLocal(new Point(myTouch.globalX, myTouch.globalY));
                makeMoveArea(pos);
            }
        }
        
        /** 移動ルート作成 */
        private function makeRootHandler(e:TouchEvent):void
        {
            var target:BattleMap = e.currentTarget as BattleMap;
            var pos:Point;
            
            var myTouch:Touch = e.getTouch(target);
            if (myTouch && (myTouch.phase == TouchPhase.BEGAN || myTouch.phase == TouchPhase.MOVED))
            {
                pos = globalToLocal(new Point(myTouch.globalX, myTouch.globalY));
                makeRootArea(pos.x, pos.y, myTouch.phase);
            }
        }
        
        /** 攻撃ターゲット選択判定 */
        private function startAttackHandler(e:TouchEvent):void
        {
            var i:int;
            var target:BattleMap = e.currentTarget as BattleMap;
            var pos:Point;
            
            var myTouch:Touch = e.getTouch(target, TouchPhase.BEGAN);
            if (myTouch)
            {
                pos = globalToLocal(new Point(myTouch.globalX, myTouch.globalY));
                attackStart(pos);
            }
        }
        
        /** 会話ターゲット選択判定 */
        private function startMapTalkHandler(e:TouchEvent):void
        {
            var i:int;
            var target:BattleMap = e.currentTarget as BattleMap;
            var pos:Point;
            
            var myTouch:Touch = e.getTouch(target, TouchPhase.BEGAN);
            if (myTouch)
            {
                pos = globalToLocal(new Point(myTouch.globalX, myTouch.globalY));
                mapTalkStart(pos);
            }
        }
        
        //-------------------------------------------------------------
        //
        // 各種パネル
        //
        //-------------------------------------------------------------
        
        /** 移動パネル・初期化 */
        public function resetMove():void
        {
            _selectMoved = false;
            deleteMoveImg();
            backMove();
            
            addChild(_btnReset);
            _battleMapPanel.showPanel(BattleMapPanel.PANEL_MOVE);
            MainController.$.view.addChild(_battleMapPanel);
            var list:Vector.<String> = new Vector.<String>;
            var unit:BattleUnit = _sideState[_selectSide].battleUnit[_selectUnit];
            unit.resetImgPos();
            remakeMoveArea(unit, unit.PosX - 1, unit.PosY - 1, unit.param.MOV, list);
            setCenterPos(unit.PosX - 1, unit.PosY - 1);
        }
        
        /** 移動パネル・移動 */
        public function startMove():void
        {
            if (moveEnable())
            {
                _battleMapPanel.showPanel(BattleMapPanel.PANEL_NONE);
                MainController.$.view.addChild(_battleMapPanel);
                removeChild(_btnReset);
                
                deleteMoveImg();
                moveUnit();
            }
            else
            {
                if (_battleResultManager.attackFlg)
                {
                    _battleMapPanel.showPanel(BattleMapPanel.PANEL_NONE);
                    MainController.$.view.addChild(_battleMapPanel);
                    removeChild(_btnReset);
                    
                    deleteMoveImg();
                    //attackAction();
                    MainController.$.view.eveManager.searchMapBattleEvent(nowBattleUnit, _targetUnit, _selectSide, _targetSide, attackAction, MapEventData.TYPE_BATTLE_BEFORE);
                }
            }
        }
        
        /** 画面上から移動範囲を消去 */
        private function removeMoveAreaImg():void
        {
            for (var i:int = 0; i < _moveAreaImgList.length; )
            {
                removeChild(_moveAreaImgList[i]);
                _moveAreaImgList[i].dispose();
                _moveAreaImgList[i] = null;
                _moveAreaImgList.shift();
            }
        }
        
        /** 画面上から攻撃範囲を消去*/
        private function removeAttackAreaImg():void
        {
            for (var i:int = 0; i < _attackAreaImgList.length; )
            {
                removeChild(_attackAreaImgList[i]);
                _attackAreaImgList[i].dispose();
                _attackAreaImgList[i] = null;
                _attackAreaImgList.shift();
            }
            terrainDataAttackReset();
        }
        
        /** 画面上からルートを消去 */
        private function removeRootImg():void
        {
            for (var i:int = 0; i < _rootImgList.length; )
            {
                removeChild(_rootImgList[i]);
                _rootImgList[i].dispose();
                _rootImgList[i] = null;
                _rootImgList.shift();
            }
        }
        
        /** 移動範囲の表示非表示 */
        private function visibleMoveAreaImg(flg:Boolean):void
        {
            for (var i:int = 0; i < _moveAreaImgList.length; i++)
            {
                _moveAreaImgList[i].visible = flg;
            }
        }
        
        /** 攻撃範囲の表示非表示 */
        private function visibleAttackAreaImg(flg:Boolean):void
        {
            for (var i:int = 0; i < _attackAreaImgList.length; i++)
            {
                _attackAreaImgList[i].visible = flg;
            }
        }
        
        /** 移動ルートの表示非表示 */
        private function visibleRootAreaImg(flg:Boolean):void
        {
            for (var i:int = 0; i < _rootImgList.length; i++)
            {
                _rootImgList[i].visible = flg;
            }
        }
        
        //-------------------------------------------------------------
        //
        // マップ関連
        //
        //-------------------------------------------------------------
        /**地形データセット*/
        public override function setTipArea(wid:int, hgt:int):void
        {
            var i:int = 0;
            var j:int = 0;
            
            super.setTipArea(wid, hgt);
            
            if (_terrainDataList != null)
            {
                for (i = 0; i < _terrainDataList.length; )
                {
                    _terrainDataList[0] = null;
                    _terrainDataList.shift();
                }
            }
            
            // 地形データ
            for (i = 0; i < _mapHeight; i++)
            {
                for (j = 0; j < _mapWidth; j++)
                {
                    var terrain:TerrainData = new TerrainData();
                    _terrainDataList.push(terrain);
                }
            }
            _baseArea = new CSprite();
            _unitArea = new CSprite();
            _frameArea = new CSprite();
            _effectArea = new CSprite();
            addChild(_baseArea);
            addChild(_frameArea);
            addChild(_unitArea);
            addChild(_effectArea);
        }
        
        /**ユニット情報取得*/
        public function getUnitInfo(name:String):BattleUnit
        {
            var data:BattleUnit = null;
            var i:int = 0;
            var j:int = 0;
            var posX:int = 0;
            var posY:int = 0;
            var flg:Boolean = false;
            for (i = 0; i < _sideState.length; i++)
            {
                for (j = 0; j < _sideState[i].battleUnit.length; j++)
                {
                    if (_sideState[i].battleUnit[j].name === name || _sideState[i].battleUnit[j].masterData.nickName === name)
                    {
                        data = _sideState[i].battleUnit[j];
                        flg = true;
                        break;
                    }
                    
                }
                
                if (flg)
                {
                    break;
                }
            }
            return data;
        }
        
        /**ユニット移動*/
        public function moveMapUnit(name:String, posX:int, posY:int, callBack:Function = null):void
        {
            var unitData:BattleUnit = getUnitInfo(name);
            
            if (unitData != null)
            {
                setLaunchCheck(unitData, posX, posY);
                
                var tweenAry:Array = new Array();
                var tweenUnit:Tween24 = Tween24.tween(unitData.unitImg, 0.3).xy((unitData.PosX - 1) * MAP_SIZE, (unitData.PosY - 1) * MAP_SIZE);
                var tweenFrame:Tween24 = Tween24.tween(unitData.frameImg, 0.3).xy((unitData.PosX - 1) * MAP_SIZE, (unitData.PosY - 1) * MAP_SIZE);
                tweenAry.push(tweenUnit);
                tweenAry.push(tweenFrame);
                
                if (unitData.formationNumImg != null)
                {
                    var tweenNumImg:Tween24 = Tween24.tween(unitData.formationNumImg, 0.3).xy((unitData.PosX - 1) * MAP_SIZE + FORMATION_NUM_POS, (unitData.PosY - 1) * MAP_SIZE + FORMATION_NUM_POS);
                    tweenAry.push(tweenNumImg);
                }
                
                Tween24.parallel(tweenAry).onComplete(callBack).play();
            }
            else
            {
                callBack();
            }
        }
        
        /**ユニット中央位置スクロール*/
        
        public function setCenterPosUnit(name:String, callBack:Function = null):void
        {
            
            var unitData:BattleUnit = getUnitInfo(name);
            
            if (callBack != null)
            {
                if (unitData)
                {
                    setCenterPos(unitData.PosX, unitData.PosY, callBack);
                }
                else
                {
                    callBack();
                }
            }
        
        }
        
        /** マップ中央位置設定 */
        public function setCenterPos(posX:int, posY:int, callBack:Function = null):void
        {
            var moveX:Number = CommonDef.WINDOW_W / 2 - posX * 32 - MAP_SIZE / 2 + pivotX;
            var moveY:Number = CommonDef.WINDOW_H / 2 - posY * 32 - MAP_SIZE / 2 + pivotY;
            
            var leftLimit:Number = -(this.width - CommonDef.WINDOW_W) + 64 + pivotX;
            var rightLimit:Number = 64 + pivotX;
            var upLimit:Number = -(this.height - CommonDef.WINDOW_H) + 64 + pivotY;
            var downLimit:Number = 64 + pivotY;
            
            // 横位置修正
            if (moveX < leftLimit)
            {
                moveX = leftLimit;
            }
            else if (moveX > rightLimit)
            {
                moveX = rightLimit;
            }
            
            // 縦位置修正
            if (moveY < upLimit)
            {
                moveY = upLimit;
            }
            else if (moveY > downLimit)
            {
                moveY = downLimit;
            }
            
            if (moveX != this.x || moveY != this.y)
            {
                if (callBack != null)
                {
                    Tween24.tween(this, 0.6, Tween24.ease.QuadOut).xy(moveX, moveY).onUpdate(floorPos).onComplete(callBack).play();
                }
                else
                {
                    Tween24.tween(this, 0.6, Tween24.ease.QuadOut).xy(moveX, moveY).onUpdate(floorPos).play();
                }
            }
            else
            {
                if (callBack != null)
                {
                    Tween24.wait(0.6).onComplete(callBack).play();
                }
            }
        }
        
        /**地形データ移動関連リセット*/
        private function terrainDataReset():void
        {
            var i:int = 0;
            for (i = 0; i < _terrainDataList.length; i++)
            {
                _terrainDataList[i].reset();
            }
        }
        
        /**地形データ攻撃関連リセット*/
        private function terrainDataAttackReset():void
        {
            var i:int = 0;
            for (i = 0; i < _terrainDataList.length; i++)
            {
                _terrainDataList[i].attackReset();
            }
        }
        
        /** 戦闘開始・マップパネル設置 */
        public function setBattleMapPanel():void
        {
            if (_battleMapPanel == null)
            {
                _battleMapPanel = new BattleMapPanel();
            }
            addChild(_battleMapPanel);
            
            _battleMapPanel.showPanel(BattleMapPanel.PANEL_SYSTEM);
            MainController.$.view.addChild(_battleMapPanel);
        }
        
        //-------------------------------------------------------------
        //
        // フェーズ関連
        //
        //-------------------------------------------------------------
        
        /** フェーズ変更 */
        public function changePhase(e:Event = null):void
        {
            _selectMoved = false;
            var i:int = 0;
            var j:int = 0;
            for (i = 0; i < _sideState.length; i++)
            {
                for (j = 0; j < _sideState[i].battleUnit.length; j++)
                {
                    if (_sideState[i].battleUnit[j].onMap)
                    {
                        _sideState[i].battleUnit[j].refreshMoveCount();
                    }
                }
            }
            
            // 陣営変化
            _selectSide++;
            
            // 全部回ったら最初に戻る
            if (_selectSide >= _sideState.length)
            {
                _selectSide = 0;
            }
            
            //ターン開始時の回復 コマンダー（居れば）
            if (_sideState[_selectSide].commander != null)
            {
                _sideState[_selectSide].commander.turnGetPoint();
            }
            //各ユニットのステータスセット
            for (i = 0; i < _sideState[_selectSide].battleUnit.length; i++)
            {
                if (_sideState[_selectSide].battleUnit[i].onMap)
                {
                    //ターン開始時にバフ計算
                    _sideState[_selectSide].battleUnit[i].buffTurnCount();
                    //ステータスリフレッシュ
                    _sideState[_selectSide].battleUnit[i].refreshState();
                    
                    _sideState[_selectSide].battleUnit[i].commanderStatusSet(_sideState[_selectSide].commander);
                }
            }
            //味方ターンのみ
            if (_selectSide == 0)
            {
                _battleMapPanel.showPanel(BattleMapPanel.PANEL_SYSTEM);
            }
            else
            {
                _battleMapPanel.showPanel(BattleMapPanel.PANEL_ENEMY_TURN);
                enemyAct();
            }
        }
        
        /** 敵行動 */
        public function enemyAct():void
        {
            // 移動範囲初期化
            removeMoveAreaImg();
            var selectFlg:Boolean = false;
            var i:int = 0;
            var unit:BattleUnit = null;
            
            for (i = 0; i < _sideState[_selectSide].battleUnit.length; i++)
            {
                unit = _sideState[_selectSide].battleUnit[i];
                if (unit.moveEnable())
                {
                    _selectUnit = i;
                    setCenterPos(unit.PosX, unit.PosY, returnEnemyMove(unit));
                    selectFlg = true;
                    break;
                }
            }
            
            // 該当がなかったらフェーズチェンジ
            if (!selectFlg)
            {
                changePhase();
            }
        
        }
        
        private function returnEnemyMove(unit:BattleUnit):Function
        {
            return function():void
            {
                enemyMove(unit);
            }
        }
        
        /** 敵移動 */
        public function enemyMove(unit:BattleUnit):void
        {
            _selectMoved = false;
            var i:int = 0;
            // 待機命令の時は移動しない（現在地のみでのアクションを行う)
            if (unit.commandType == BattleUnit.COMMAND_WAIT)
            {
                unit.moveEnd();
                //enemyAct();
                MainController.$.view.eveManager.searchMapMoveEvent(nowBattleUnit, _selectSide, enemyAct, MapEventData.TYPE_MATH_IN);
            }
            else
            {
                var list:Vector.<String> = new Vector.<String>;
                // 移動ターゲット位置取得
                var aiMove:Vector.<EnemyMoveData> = new Vector.<EnemyMoveData>();
                var targetNum:int = -1;
                var targetPos:int = 0;
                remakeMoveArea(unit, unit.PosX - 1, unit.PosY - 1, unit.param.MOV, list, _selectSide, aiMove);
                
                // 最優先行動ポイントをゲット
                for (i = 0; i < aiMove.length; i++)
                {
                    if (targetNum < 0 || targetNum < aiMove[i].priority)
                    {
                        targetNum = aiMove[i].priority;
                        targetPos = i;
                    }
                }
                
                // 移動可能位置があれば移動
                if (targetNum >= 0)
                {
                    _nowMovePosX = aiMove[targetPos].movePosX;
                    _nowMovePosY = aiMove[targetPos].movePosY;
                    if (nowBattleUnit.PosX != _nowMovePosX || nowBattleUnit.PosY != _nowMovePosY)
                    {
                        _selectMoved = true;
                        
                    }
                    
                    //_targetUnit = _battleUnit[aiMove[targetPos].targetSide][aiMove[targetPos].targetNum];
                    moveUnit(aiMove[targetPos]);
                }
                else
                {
                    var moveTarget:EnemyMoveData = new EnemyMoveData();
                    moveTarget.getPriority(unit.PosX - 1, unit.PosY - 1, nowBattleUnit, _sideState, _selectSide);
                    if (moveTarget.selectWeapon != null)
                    {
                        checkMoveAttack(moveTarget);
                    }
                    else
                    {
                        unit.moveEnd();
                        //enemyAct();
                        MainController.$.view.eveManager.searchMapMoveEvent(nowBattleUnit, _selectSide, enemyAct, MapEventData.TYPE_MATH_IN);
                    }
                }
            }
        
        }
        
        /** 敵攻撃アクション */
        private function enemyAttack(moveData:EnemyMoveData):void
        {
            _targetSide = moveData.targetSide;
            // ターゲット設定
            _targetUnit = _sideState[moveData.targetSide].battleUnit[moveData.targetNum];
            //戦闘可能ならば戦闘イベント
            if (moveData.selectWeapon != null)
            {
                if (_selectSide == 0)
                {
                    SingleMusic.playBattleBGM(nowBattleUnit.customBgmHeadPath, 1, 1);
                }
                else if (_targetSide == 0)
                {
                    SingleMusic.playBattleBGM(_targetUnit.customBgmHeadPath, 1, 1);
                }
                else
                {
                    SingleMusic.playBattleBGM(nowBattleUnit.customBgmHeadPath, 1, 1);
                }
                MainController.$.view.eveManager.searchMapBattleEvent(nowBattleUnit, _targetUnit, _selectSide, _targetSide, enemyAttackAction, MapEventData.TYPE_BATTLE_BEFORE);
            }
            // 戦闘できなかったら移動終了後、進入イベント
            else
            {
                nowBattleUnit.moveEnd();
                MainController.$.view.eveManager.searchMapMoveEvent(nowBattleUnit, _selectSide, enemyAct, MapEventData.TYPE_MATH_IN);
            }
            
            function enemyAttackAction():void
            {
                // 移動先の位置をセット
                _battleResultManager.setMovePos(_nowMovePosX, _nowMovePosY);
                _selectEnemyWeapon = moveData.selectWeapon;
                // 戦闘予測画面に切り替え
                _battleMapPanel.counterAttackRange = moveData.distance;
                _battleMapPanel.showPanel(BattleMapPanel.PANEL_COUNTER_WEAPON);
            }
        }
        
        // 反撃武器選択後
        public function selectCounterWeapon(selectWeapon:MasterWeaponData):void
        {
            //////////////////////////////////////////////////////////////////////////////////////////////////////////
            // 反撃棋譜を追加
            //_battleResultManager.addCounterAttack(_targetUnit, _selectSide, nowBattleUnit);
            
            _battleResultManager.initAttack();
            
            // 攻撃棋譜を追加
            _battleResultManager.addAttack(nowBattleUnit, _selectSide, _selectEnemyWeapon, _targetUnit, selectWeapon);
            _battleResultManager.addAttack(_targetUnit, 0, selectWeapon, nowBattleUnit, _selectEnemyWeapon);
            
            // 戦闘予測画面に切り替え
            _battleMapPanel.showPanel(BattleMapPanel.PANEL_PREDICTION);
            // 攻撃データをセット
            _battleMapPanel.setPrediction(_battleResultManager.attackWeaponList);
            MainController.$.view.addChild(_battleMapPanel);
        }
        
        // 敵攻撃開始
        public function enemyAttackStart():void
        {
            // 戦闘計算開始
            _battleResultManager.makeRecord();
            deleteMoveImg();
            if (_battleActionPanel == null)
            {
                _battleActionPanel = new BattleActionPanel();
            }
            _battleMapPanel.showPanel(BattleMapPanel.PANEL_NONE);
            _battleActionPanel.startBattleAnime(_battleResultManager.attackRecord, endBattleAnime);
            MainController.$.view.addChild(_battleActionPanel);
        }
        
        //-------------------------------------------------------------
        //
        // AI関連
        //
        //-------------------------------------------------------------
        
        //-------------------------------------------------------------
        //
        // ゲッター
        //
        //-------------------------------------------------------------
        public function get terrain():Vector.<TerrainData>
        {
            return _terrainDataList;
        }
        
        public function get nowBattleUnit():BattleUnit
        {
            return _sideState[_selectSide].battleUnit[_selectUnit];
        }
        
        public function get mapPanel():BattleMapPanel
        {
            return _battleMapPanel;
        }
        
        public function get targetUnit():BattleUnit
        {
            return _targetUnit;
        }
        
        public function get selectSide():int
        {
            return _selectSide;
        }
        
        public function get sideState():Vector.<SideState>
        {
            return _sideState;
        }
        
        public function get skyFlg():Boolean
        {
            return _skyFlg;
        }
        
        public function set skyFlg(value:Boolean):void
        {
            _skyFlg = value;
        }
        
        public function get organizeList():OrganizeList
        {
            return _organizeList;
        }
        
        public function get unitArea():CSprite
        {
            return _unitArea;
        }
        
        public function get frameArea():CSprite
        {
            return _frameArea;
        }
        
        public function get selectMoved():Boolean
        {
            return _selectMoved;
        }
        
        public function get mapPictureList():Vector.<MapPicture>
        {
            return _mapPictureList;
        }
        
        public function set mapPictureList(value:Vector.<MapPicture>):void
        {
            _mapPictureList = value;
        }
        
        public function get battleMapPanel():BattleMapPanel
        {
            return _battleMapPanel;
        }
        
        public function get mapTalkFlg():Boolean
        {
            return _mapTalkFlg;
        }
        
        public function get statusWindow():BattleMapStatus
        {
            return _statusWindow;
        }
        
        public function get effectArea():CSprite
        {
            return _effectArea;
        }
        
        public function get baseDataList():Vector.<BaseTip> 
        {
            return _baseDataList;
        }
        
        public function get baseArea():CSprite 
        {
            return _baseArea;
        }
        
        public function set mapTalkFlg(value:Boolean):void
        {
            _mapTalkFlg = value;
        }
        
        //-------------------------------------------------------------
        //
        // 拠点
        //
        //-------------------------------------------------------------
        
        private function makeNewSide(side:String):int
        {
            var i:int = 0;
            var sideNum:int = -1;
            if (sideState.length <= 0 || _sideState[0] === null)
            {
                // 初期勢力追加
                _sideState[0] = new SideState(MainController.$.model.playerParam.sideName);
            }
            
            if (side === MainController.$.model.playerParam.sideName)
            {
                sideNum = 0;
            }
            else
            {
                var newSideFlg:Boolean = true;
                for (i = 0; i < _sideState.length; i++)
                {
                    //陣営名があった場合統一
                    if (side === _sideState[i].name)
                    {
                        newSideFlg = false;
                        sideNum = i;
                        break;
                    }
                }
                
                if (newSideFlg)
                {
                    _sideState[i] = new SideState(side);
                    sideNum = i;
                }
            }
            return sideNum;
        }
        
        public function setMapBase(name:String, param:Object):void
        {
            var i:int = 0;
            var baseMasterData:MasterBaseData = MainController.$.model.getMasterBaseDataFromName(name);
            var sideNum:int = -1;
            var tex:Texture = null;
            var alpha:int = 1;
            
            MainController.$.view.waitDark(true);
            if (param.hasOwnProperty("side"))
            {
                sideNum = makeNewSide(param.side);
            }
            
            if (param.hasOwnProperty("eventno"))
            {
                for (i = 0; i < _terrainDataList.length; i++)
                {
                    if (_terrainDataList[i].EventNo == param.eventno)
                    {
                        var evBaseData:BaseTip = new BaseTip(baseMasterData, sideNum);
                        evBaseData.setPos(i % _mapWidth + 1, i / _mapWidth + 1);
                        _baseDataList.push(evBaseData);
                        _baseArea.addChild(evBaseData);
                        if (sideNum >= 0)
                        {
                            evBaseData.sideFrame = new CImage(MainController.$.imgAsset.getTexture(_sideState[sideNum].frameImgPath));
                            evBaseData.sideFrame.x = evBaseData.x;
                            evBaseData.sideFrame.y = evBaseData.y;
                            _frameArea.addChildAt(evBaseData.sideFrame, 0);
                        }
                    }
                }
            }
            else if (param.hasOwnProperty("x") && param.hasOwnProperty("y"))
            {
                var baseData:BaseTip = new BaseTip(baseMasterData, sideNum);
                baseData.setPos(param.x, param.y);
                _baseDataList.push(baseData);
                _baseArea.addChild(baseData);
                if (sideNum >= 0)
                {
                    baseData.sideFrame = new CImage(MainController.$.imgAsset.getTexture(_sideState[sideNum].frameImgPath));
                    baseData.sideFrame.x = baseData.x;
                    baseData.sideFrame.y = baseData.y;
                    _frameArea.addChildAt(baseData.sideFrame, 0);
                }
            }
            
            MainController.$.view.waitDark(false);
        }
        
        /**陣営のコスト設定*/
        public function setSideCost(side:String, cost:int):void
        {
            var i:int = 0;
            var sideNum:int = makeNewSide(side);
            _sideState[sideNum].cost = cost;
        }
        
        /**陣営のコスト設定*/
        public function addSideCost(side:String, cost:int):void
        {
            var i:int = 0;
            var sideNum:int = makeNewSide(side);
            _sideState[sideNum].cost += cost;
        }
        
        //-------------------------------------------------------------
        //
        // その他
        //
        //-------------------------------------------------------------
        
        /**マップ上にイベント画像追加*/
        public function setMapPicture(textureName:String, name:String, param:Object):void
        {
            var label:String = null;
            
            if (param.hasOwnProperty("label"))
            {
                label = param.label;
            }
            
            var mapPict:MapPicture = new MapPicture(textureName, name, label);
            
            if (param.hasOwnProperty("posx"))
            {
                mapPict.x = (param.posx - 1) * 32;
            }
            else if (param.hasOwnProperty("x"))
            {
                mapPict.x = param.x;
            }
            
            if (param.hasOwnProperty("posy"))
            {
                mapPict.y = (param.posy - 1) * 32;
            }
            else if (param.hasOwnProperty("y"))
            {
                mapPict.y = param.y;
            }
            
            if (param.hasOwnProperty("width"))
            {
                mapPict.width = width;
            }
            if (param.hasOwnProperty("height"))
            {
                mapPict.width = height;
            }
            
            _mapPictureList.push(mapPict);
            _unitArea.addChild(mapPict);
        }
        
        /**マップ上のイベント画像削除*/
        public function setMapPictureLabel(name:String, label:String):void
        {
            for (var i:int = 0; i < _mapPictureList.length; i++)
            {
                if (_mapPictureList[i].pictName === name)
                {
                    _mapPictureList[i].eventLabel = label;
                    break;
                }
            }
        }
        
        /**マップ上のイベント画像削除*/
        public function deleteMapPicture(name:String):void
        {
            for (var i:int = 0; i < _mapPictureList.length; i++)
            {
                if (_mapPictureList[i].pictName === name)
                {
                    _mapPictureList[i].removeFromParent();
                    _mapPictureList[i].dispose();
                    _mapPictureList[i] = null;
                    _mapPictureList.splice(i, 1);
                    break;
                }
            }
        }
        
        /**マップ上イベントの全削除*/
        public function deleteAllMapPicture():void
        {
            for (var i:int = 0; 0 < _mapPictureList.length; )
            {
                _mapPictureList[i].removeFromParent();
                _mapPictureList[i].dispose();
                _mapPictureList[i] = null;
                _mapPictureList.splice(i, 1);
            }
        }
        
        /**マップ会話開始*/
        private function mapTalkStart(pos:Point):void
        {
            var endFlg:Boolean = false;
            var i:int = 0;
            var j:int = 0;
            var posX:int = pos.x / MAP_SIZE;
            var posY:int = pos.y / MAP_SIZE;
            
            // マップ内から、対象ユニット位置を検索
            for (i = 0; i < _sideState.length; i++)
            {
                for (j = 0; j < _sideState[i].battleUnit.length; j++)
                {
                    if (_sideState[i].battleUnit[j].PosX == posX + 1 && _sideState[i].battleUnit[j].PosY == posY + 1 && _sideState[i].battleUnit[j].onMap)
                    {
                        if (_sideState[i].battleUnit[j].talkLabel != null)
                        {
                            
                            MainController.$.view.battleMap.mapPanel.showPanel(BattleMapPanel.PANEL_NONE);
                            MainController.$.view.eveManager.talkEventStart(_sideState[i].battleUnit[j].talkLabel);
                        }
                        return;
                    }
                }
            }
            
            /**マップピクチャ上でイベント検索*/
            for (i = 0; i < _mapPictureList.length; i++)
            {
                //ラベルが無い場合は飛ばす
                if (_mapPictureList[i].eventLabel == null || _mapPictureList[i].eventLabel.length <= 0)
                {
                    continue;
                }
                
                if (pos.x >= _mapPictureList[i].x && pos.x <= _mapPictureList[i].x + _mapPictureList[i].width && pos.y >= _mapPictureList[i].y && pos.y <= _mapPictureList[i].y + _mapPictureList[i].height)
                {
                    MainController.$.view.battleMap.mapPanel.showPanel(BattleMapPanel.PANEL_NONE);
                    MainController.$.view.eveManager.talkEventStart(_mapPictureList[i].eventLabel);
                    return;
                }
            }
        }
    }
}