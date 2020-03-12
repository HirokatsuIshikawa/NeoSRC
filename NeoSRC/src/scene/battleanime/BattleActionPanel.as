package scene.battleanime
{
    import a24.tween.Tween24;
    import common.CommonDef;
    import common.CommonSystem;
    import converter.parse.MessageDataParse;
    import flash.geom.Rectangle;
    import scene.battleanime.battleback.BattleBack;
    import scene.talk.message.FaceMessageWindow;
    import scene.unit.BattleUnit;
    import starling.animation.Tween;
    import system.custom.customSprite.CImage;
    import system.custom.customSprite.CSprite;
    import database.user.UnitCharaData;
    import starling.textures.Texture;
    import starling.textures.TextureSmoothing;
    import scene.battleanime.data.BattleAnimeRecord;
    import scene.main.MainController;
    import viewitem.parts.numbers.ImgNumber;
    
    /**
     * ...
     * @author ishikawa
     */
    public class BattleActionPanel extends CSprite
    {
        public static const BATTLE_ANIME_MESSAGE_WINDOW_Y:int = 400;
        /** ユニット */
        private var _leftUnitImg:Vector.<CImage> = null;
        private var _rightUnitImg:Vector.<CImage> = null;
        /**背景*/
        private var _backImg:CImage = null;
        private var _tex:Texture = null;
        
        /**ループ背景*/
        private var _battleBack:Vector.<BattleBack> = null;
        
        /**メッセージウィンドウ*/
        private var _messageWindow:FaceMessageWindow = null;
        
        /**ユニットデータ*/
        private var _leftUnitData:BattleUnit = null;
        private var _rightUnitData:BattleUnit = null;
        
        private var _tween:Tween24 = null;
        /**アニメ再生カウント*/
        private var _animeCount:int = 0;
        /**アニメ棋譜*/
        private var _recordAnime:Vector.<BattleAnimeRecord> = null;
        /**終了コールバック*/
        private var _endCallBack:Function = null;
        
        /**ダメージ値*/
        private var _damageNum:ImgNumber = null;
        
        private var _attackMessage:Vector.<String>;
        private var _targetMessage:Vector.<String>;
        private var _talkAttackChara:String;
        private var _talkTargetChara:String;
        public var messageCount:int = 0;
        
        /**コンストラクタ*/
        public function BattleActionPanel()
        {
            super();
            _leftUnitImg = new Vector.<CImage>();
            _rightUnitImg = new Vector.<CImage>();
            
            //暗幕
            _tex = MainController.$.imgAsset.getTexture("tex_black");
            _backImg = new CImage(_tex);
            _backImg.width = CommonDef.WINDOW_W;
            _backImg.height = CommonDef.WINDOW_H;
            _backImg.textureSmoothing = TextureSmoothing.NONE;
            addChild(_backImg);
            //移動背景
            _battleBack = new Vector.<BattleBack>();
            
            for (var i:int = 0; i < 2; i++)
            {
                var battleBack:BattleBack;
                var scrollSide:int = i % 2 == 1 ? 1 : -1;
                
                battleBack = new BattleBack("battleback_default", "battleback_default", scrollSide);
                
                battleBack.x = (i % 2) * (CommonDef.WINDOW_W / 2 + 4);
                battleBack.y = 0;
                addChild(battleBack);
                _battleBack.push(battleBack);
            }
            
            //メッセージウィンドウ
            _messageWindow = new FaceMessageWindow();
            _messageWindow.x = (CommonDef.WINDOW_W - _messageWindow.width) / 2;
            _messageWindow.y = BATTLE_ANIME_MESSAGE_WINDOW_Y;
            addChild(_messageWindow);
            //透明に
            this.alpha = 0;
            _damageNum = new ImgNumber();
        }
        
        /**廃棄*/
        override public function dispose():void
        {
            
            CommonDef.disposeList([_leftUnitImg, _rightUnitImg]);
            if (_backImg != null)
            {
                _backImg.dispose();
                _backImg = null;
            }
            
            if (_tex != null)
            {
                _tex.dispose();
                _tex = null;
            }
            
            _rightUnitImg = null;
            _leftUnitImg = null;
            
            super.dispose();
        }
        
        /**ユニットセット*/
        public function setUnit(attakerUnitData:BattleUnit, targetUnitData:BattleUnit):void
        {
            CommonDef.disposeList([_leftUnitImg, _rightUnitImg]);
            _rightUnitImg = null;
            _leftUnitImg = null;
            _leftUnitImg = new Vector.<CImage>();
            _rightUnitImg = new Vector.<CImage>();
            
            var leftBeforeUnitNum:int;
            var rightBeforeUnitNum:int;
            
            if (attakerUnitData.side <= targetUnitData.side)
            {
                _leftUnitData = targetUnitData;
                _rightUnitData = attakerUnitData;
                leftBeforeUnitNum = targetUnitData.mathFormationNum(_recordAnime[_animeCount].tgtBeforeHP);
                rightBeforeUnitNum = attakerUnitData.mathFormationNum(_recordAnime[_animeCount].atkBeforeHP);
                
            }
            else
            {
                _leftUnitData = attakerUnitData;
                _rightUnitData = targetUnitData;
                leftBeforeUnitNum = attakerUnitData.mathFormationNum(_recordAnime[_animeCount].atkBeforeHP);
                rightBeforeUnitNum = targetUnitData.mathFormationNum(_recordAnime[_animeCount].tgtBeforeHP);
            }
            
            //_leftUnitImg = new CImage(TextureManager.loadTexture(_leftUnitData.masterData.unitImgUrl, _leftUnitData.masterData.unitImgName, TextureManager.TYPE_UNIT));
            //_rightUnitImg = new CImage(TextureManager.loadTexture(_rightUnitData.masterData.unitImgUrl, _rightUnitData.masterData.unitImgName, TextureManager.TYPE_UNIT));
            var i:int = 0;
            //左エネミーセット
            for (i = 0; i < leftBeforeUnitNum; i++)
            {
                if (i > 0 && _leftUnitData.masterData.subUnitImgName != null)
                {
                    _leftUnitImg[i] = new CImage(MainController.$.imgAsset.getTexture(_leftUnitData.masterData.subUnitImgName));
                }
                else
                {
                    _leftUnitImg[i] = new CImage(MainController.$.imgAsset.getTexture(_leftUnitData.masterData.unitsImgName));
                }
                setUnitImage(_leftUnitImg[i], 0, i);
            }
            
            //右ユニットセット
            for (i = 0; i < rightBeforeUnitNum; i++)
            {
                if (i > 0 && _rightUnitData.masterData.subUnitImgName != null)
                {
                    _rightUnitImg[i] = new CImage(MainController.$.imgAsset.getTexture(_rightUnitData.masterData.subUnitImgName));
                }
                else
                {
                    _rightUnitImg[i] = new CImage(MainController.$.imgAsset.getTexture(_rightUnitData.masterData.unitsImgName));
                }
                setUnitImage(_rightUnitImg[i], 1, i);
            }
        }
        
        public const posListY:Array = [0, -40, 40, -40, 40];
        public const posListL:Array = [0, 80, 80, -80, -80];
        public const posListR:Array = [0, -80, -80, 80, 80];
        
        /**ユニット画像セット*/
        public function setUnitImage(img:CImage, side:int, pos:int):void
        {
            
            img.width = 128;
            img.height = 128;
            if (side == 0)
            {
                img.scaleX = -4;
                img.x = 128 + 128 + posListL[pos];
            }
            else
            {
                img.x = CommonDef.WINDOW_W - 256 + posListR[pos];
            }
            img.textureSmoothing = TextureSmoothing.NONE;
            
            img.y = 160 + posListY[pos];
            addChild(img);
        }
        
        /**アニメ開始*/
        public function startBattleAnime(data:Vector.<BattleAnimeRecord>, callBack:Function):void
        {
            _endCallBack = callBack;
            _recordAnime = data;
            _animeCount = 0;
            _messageWindow.deleteImage();
            _messageWindow.deleteText();
            setUnit(data[_animeCount].attacker, data[_animeCount].target);
            Tween24.tween(this, 0.4).fadeIn().onComplete(readyFunc).play();
            function readyFunc():void
            {
                readyAction();
            }
        }
        
        /**メッセージセット*/
        private function playMessage(charaName:String, message:Vector.<String>, callBack:Function = null):Tween24
        {
            _messageWindow.clearText();
            messageCount = 0;
            var strCount:int = message[0].length;
            var tween:Tween24 = Tween24.tween(this, strCount * 0.02, null, {messageCount: strCount}).onPlay(initMessageWindow, charaName, message).onUpdate(msgUpdate, message);
            
            if (callBack != null)
            {
                tween.onComplete(callBack);
            }
            return tween;
        }
        
        /**メッセージアップデート*/
        private function msgUpdate(message:Vector.<String>):void
        {
            _messageWindow.setText(message[0].substr(0, messageCount));
        }
        
        private function initMessageWindow(name:String, message:Vector.<String>):void
        {
            _messageWindow.clearText();
            _messageWindow.setImage(name, null);
            messageCount = 0;
        }
        
        private function readyAction():void
        {
            if (_animeCount == _recordAnime.length)
            {
                disposeRecord();
                _endCallBack();
            }
            else
            {
                startAction(_recordAnime[_animeCount]);
                _animeCount++;
            }
        }
        
        public function disposeRecord():void
        {
            var i:int = 0;
            if (_recordAnime != null)
            {
                for (i = 0; i < _recordAnime.length; )
                {
                    _recordAnime[0] = null;
                    _recordAnime.shift();
                }
                _recordAnime = null;
            }
        }
        
        /**アクション開始*/
        private function startAction(data:BattleAnimeRecord):void
        {
            var attackState:String = MessageDataParse.STATE_LIST[3];
            var targetState:String = MessageDataParse.STATE_LIST[1];
            _talkAttackChara = MainController.$.model.isEnableMessageName(data.attacker.name) ? data.attacker.name : "システム";
            _attackMessage = MainController.$.model.getRandamBattleMessage(data.attacker.name, attackState, data.attacker, data.target, data.weapon, data.damage);
            switch (data.effect)
            {
            
            case BattleAnimeRecord.EFFECT_NO_HIT: 
                targetState = MessageDataParse.STATE_LIST[1];
                break;
            case BattleAnimeRecord.EFFECT_DAMAGE: 
                if (data.target.alive)
                {
                    targetState = MessageDataParse.STATE_LIST[2];
                }
                else
                {
                    targetState = MessageDataParse.STATE_LIST[4];
                }
                break;
                
            }
            _talkTargetChara = MainController.$.model.isEnableMessageName(data.target.name) ? data.target.name : "システム";
            _targetMessage = MainController.$.model.getRandamBattleMessage(data.target.name, targetState, data.attacker, data.target, data.weapon, data.damage);
            
            // アクション作成
            _tween = makeAction(data)
            // 終了時アクション
            _tween.onComplete(readyAction);
            //メッセージ開始
            playMessage(_talkAttackChara, _attackMessage, _tween.play).play();
        }
        
        /** アクション作成 */
        private function makeAction(data:BattleAnimeRecord):Tween24
        {
            var act:Array = new Array();
            var atkImg:Vector.<CImage> = new Vector.<CImage>;
            var defImg:Vector.<CImage> = new Vector.<CImage>;
            
            switch (data.side)
            {
            case BattleAnimeRecord.SIDE_LEFT: 
                atkImg = _leftUnitImg;
                defImg = _rightUnitImg;
                break;
            case BattleAnimeRecord.SIDE_RIGHT:
                
                atkImg = _rightUnitImg;
                defImg = _leftUnitImg;
                break;
            }
            
            waitAction(act, 0.2);
            setAttackEffect(act, data, atkImg, defImg);
            waitAction(act, 0.6);
            resetPosition(act, atkImg, defImg, 0.3);
            waitAction(act, 0.3);
            
            var tween:Tween24 = Tween24.serial(act);
            
            return tween;
        }
        
        /**アニメエフェクト設定*/
        private function setAttackEffect(act:Array, data:BattleAnimeRecord, atkImg:Vector.<CImage>, defImg:Vector.<CImage>):void
        {
            switch (data.effect)
            {
            case BattleAnimeRecord.EFFECT_DAMAGE: 
                normalAttack(act, data, atkImg, defImg);
                break;
            case BattleAnimeRecord.EFFECT_NO_HIT: 
                attackMiss(act, data, atkImg, defImg);
                break;
            }
        }
        
        /** 通常攻撃アクション */
        private function normalAttack(act:Array, data:BattleAnimeRecord, atkImg:Vector.<CImage>, defImg:Vector.<CImage>):void
        {
            var atkAry:Array = new Array();
            var defAry:Array = new Array();
            
            for (var i:int = 0; i < atkImg.length; i++)
            {
                atkAry.push(Tween24.tween(atkImg[i], 0.3).$x(100 * data.side));
            }
            
            var beforeNum:int = data.target.mathFormationNum(data.tgtBeforeHP);
            var afterNum:int = data.target.formationNum;
            
            for (i = 0; i < defImg.length; i++)
            {
                //複数ユニットの場合やられモーションを入れる
                if ((beforeNum - afterNum) >= i)
                {
                    if (i == 0)
                    {
                        defAry.push(Tween24.parallel(Tween24.tween(defImg[i], 0.3, Tween24.ease.BackIn).onComplete(endAttackAnime, atkImg, defImg).$x(120 * data.side).y(CommonDef.WINDOW_H + 128).onPlay(showDamage, data.damage, 0xFF0000, data.side), playMessage(_talkTargetChara, _targetMessage)));
                    }
                    else
                    {
                        defAry.push(Tween24.tween(defImg[i], 0.3, Tween24.ease.BackIn).$x(120 * data.side).y(CommonDef.WINDOW_H + 128));
                    }
                }
                else
                {
                    //ダメージモーション
                    if (i == 0)
                    {
                        defAry.push(Tween24.parallel(Tween24.tween(defImg[i], 0.3).onComplete(endAttackAnime,atkImg, defImg).$x(20 * data.side).onPlay(showDamage, data.damage, 0xFF0000, data.side), playMessage(_talkTargetChara, _targetMessage)));
                    }
                    else
                    {
                        defAry.push(Tween24.tween(defImg[i], 0.3).$x(20 * data.side));
                    }
                }
            }
            var atkTween:Tween24 = Tween24.parallel(atkAry);
            var defTween:Tween24 = Tween24.parallel(defAry);
            act.push(atkTween);
            act.push(defTween);
        
        }
        
        private function endAttackAnime(atkImg:Vector.<CImage>, defImg:Vector.<CImage>):void
        {
            var i:int = 0;
            var atkNum:int = _recordAnime[_animeCount - 1].attacker.formationNum;
            var defNum:int = _recordAnime[_animeCount - 1].target.formationNum;
            for (i = 0; i < atkImg.length; i++)
            {
                if (atkNum <= i)
                {
                    atkImg[i].dispose();
                    atkImg[i] = null;
                    atkImg.splice(i, 1);
                    i--;
                }
            }
            for (i = 0; i < defImg.length; i++)
            {
                if (defNum <= i)
                {
                    defImg[i].dispose();
                    defImg[i] = null;
                    defImg.splice(i, 1);
                    i--;
                }
            }
        }
        
        /** 回避アクション */
        private function attackMiss(act:Array, data:BattleAnimeRecord, atkImg:Vector.<CImage>, defImg:Vector.<CImage>):void
        {
            
            var atkAry:Array = new Array();
            var defAry:Array = new Array();
            for (var i:int = 0; i < atkImg.length; i++)
            {
                atkAry.push(Tween24.tween(atkImg[i], 0.3).$x(100 * data.side));
            }
            for (i = 0; i < defImg.length; i++)
            {
                if (i == 0)
                {
                    defAry.push(Tween24.parallel(Tween24.tween(defImg[i], 0.3).$xy(20 * data.side, -60), playMessage(_talkTargetChara, _targetMessage)));
                }
                else
                {
                    defAry.push(Tween24.tween(defImg[i], 0.3).$xy(20 * data.side, -60));
                }
            }
            var atkTween:Tween24 = Tween24.parallel(atkAry);
            var defTween:Tween24 = Tween24.parallel(defAry);
            act.push(atkTween);
            act.push(defTween);
        }
        
        /**ウェイト作成*/
        private function waitAction(act:Array, time:Number):void
        {
            act.push(Tween24.wait(time));
        }
        
        /**ポジション初期化*/
        private function resetPosition(act:Array, atkImg:Vector.<CImage>, defImg:Vector.<CImage>, time:Number):void
        {
            var ary:Array = new Array();
            var i:int = 0;
            
            for (i = 0; i < atkImg.length; i++)
            {
                ary.push(Tween24.tween(atkImg[i], time).$xy(0, 0));
            }
            for (i = 0; i < defImg.length; i++)
            {
                ary.push(Tween24.tween(defImg[i], time).$xy(0, 0));
            }
            
            //var tween:Tween24 = Tween24.parallel(Tween24.tween(atkImg, time).$xy(0, 0), Tween24.tween(defImg, time).$xy(0, 0));
            var tween:Tween24 = Tween24.parallel(ary);
            act.push(tween);
        }
        
        /** ダメージ表示 */
        private function showDamage(value:int, color:uint, side:int):void
        {
            _damageNum.setNumber(value, "", color);
            _damageNum.alpha = 0;
            _damageNum.visible = true;
            addChild(_damageNum);
            if (side == BattleAnimeRecord.SIDE_LEFT)
            {
                _damageNum.x = _rightUnitImg[0].x;
                _damageNum.y = _rightUnitImg[0].y;
            }
            else if (side == BattleAnimeRecord.SIDE_RIGHT)
            {
                _damageNum.x = _leftUnitImg[0].x;
                _damageNum.y = _leftUnitImg[0].y;
            }
            
            Tween24.serial(Tween24.tween(_damageNum, 0.3).fadeIn().$xy(0, -60), //
            Tween24.tween(_damageNum, 0.3).$xy(0, 0), //
            Tween24.tween(_damageNum, 0.3).fadeOut() //
            ).play();
        
        }
    }

}