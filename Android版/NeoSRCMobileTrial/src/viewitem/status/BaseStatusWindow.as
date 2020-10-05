package viewitem.status
{
    import common.CommonDef;
    import common.CommonSystem;
    import common.util.CharaDataUtil;
    import database.master.MasterCommanderData;
    import database.user.CommanderData;
    import system.custom.customSprite.CImage;
    import system.custom.customSprite.CTextArea;
    import system.custom.customSprite.ImageBoard;
    import database.master.MasterCharaData;
    import database.master.base.BaseParam;
    import database.user.FaceData;
    import database.user.UnitCharaData;
    import feathers.controls.TextArea;
    import flash.text.TextFormatAlign;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.utils.Color;
    import viewitem.base.WindowItemBase;
    import scene.main.MainController;
    import scene.unit.BattleUnit;
    import viewitem.parts.numbers.ImgNumber;
    
    /**
     * ...
     * @author ishikawa
     */
    public class BaseStatusWindow extends WindowItemBase
    {
        public static const COMMAND_IMG_LIST:Array = ["_atkImg","_defImg","_tecImg","_spdImg","_mndImg","_capImg","_movImg","_hitImg","_evaImg","_healImg", "_supplyImg"];
        private var _data:UnitCharaData = null;
        /**画像板*/
        private var _faceImgBoard:ImageBoard = null;
        /**名前エリア*/
        private var _nameTxt:TextArea = null;
        /**コールバック*/
        private var _callBack:Function = null;
        
        private var _lvImg:ImgNumber = null;
        private var _hpImg:ImgNumber = null;
        private var _fpImg:ImgNumber = null;
        private var _tpImg:ImgNumber = null;
        private var _atkImg:ImgNumber = null;
        private var _defImg:ImgNumber = null;
        private var _tecImg:ImgNumber = null;
        private var _spdImg:ImgNumber = null;
        private var _mndImg:ImgNumber = null;
        private var _capImg:ImgNumber = null;
        private var _movImg:ImgNumber = null;
        private var _hitImg:ImgNumber = null;
        private var _evaImg:ImgNumber = null;
        private var _spImg:ImgNumber = null;
        private var _healImg:ImgNumber = null;
        private var _supplyImg:ImgNumber = null;
        
        private const ST_LEFT_X:int = 8;
        private const ST_RIGHT_X:int = 156;
        private const ST_BASE_Y:int = 160;
        private const ST_BETWEEN_Y:int = 32;
        
        public function BaseStatusWindow(callBack:Function = null)
        {
            var i:int = 0;
            _callBack = callBack;
            
            super(320, 500);
            
            _windowImg.alpha = 0.8
            
            _faceImgBoard = new ImageBoard();
            _faceImgBoard.touchable = false;
            
            _nameTxt = new CTextArea(18, 0x0, 0x0, TextFormatAlign.CENTER);
            _nameTxt.styleName = "custom_text";
            _nameTxt.x = 8;
            _nameTxt.y = 8;
            _nameTxt.width = 304;
            
            _lvImg = new ImgNumber();
            _hpImg = new ImgNumber();
            _fpImg = new ImgNumber();
            _tpImg = new ImgNumber();
            _atkImg = new ImgNumber();
            _defImg = new ImgNumber();
            _tecImg = new ImgNumber();
            _spdImg = new ImgNumber();
            _mndImg = new ImgNumber();
            _capImg = new ImgNumber();
            _movImg = new ImgNumber();
            _spImg = new ImgNumber();
            _healImg = new ImgNumber();
            _supplyImg = new ImgNumber();
            _hitImg = new ImgNumber();
            _evaImg = new ImgNumber();
        }
        
        override public function dispose():void
        {
            
            _data = null;
            /**画像板*/
            if (_faceImgBoard != null)
            {
                _faceImgBoard.dispose();
            }
            _faceImgBoard = null;
            /**名前エリア*/
            _nameTxt.dispose();
            _nameTxt = null;
            /**コールバック*/
            _callBack = null;
            
            _lvImg.dispose();
            _hpImg.dispose();
            _fpImg.dispose();
            _tpImg.dispose();
            _atkImg.dispose();
            _defImg.dispose();
            _tecImg.dispose();
            _spdImg.dispose();
            _mndImg.dispose();
            _capImg.dispose();
            _movImg.dispose();
            _hitImg.dispose();
            _evaImg.dispose();
            _spImg.dispose();
            _healImg.dispose();
            _supplyImg.dispose();
            
            _lvImg = null;
            _hpImg = null;
            _fpImg = null;
            _tpImg = null;
            _atkImg = null;
            _defImg = null;
            _tecImg = null;
            _spdImg = null;
            _mndImg = null;
            _capImg = null;
            _movImg = null;
            _hitImg = null;
            _evaImg = null;
            _spImg = null;
            _healImg = null;
            _supplyImg = null;
            super.dispose();
        }
        
        /**キャラデータセット*/
        public function setCharaData(data:BattleUnit):void
        {
            //マスターキャラデータ取得
            _data = data;
            var charaData:MasterCharaData = CharaDataUtil.getMasterCharaDataName(data.masterData.name);
            setPosCharaParam();
            imgSet(charaData.charaImgName);
            
            _nameTxt.text = charaData.nickName;
            //_lvTxt.text = "Lv:" + data.nowLv;
            addChild(_windowImg);
            addChild(_faceImgBoard);
            addChild(_nameTxt);
            
            var i:int = 0;
            var j:int = 0;
            
            var paramColor:Vector.<uint> = new Vector.<uint>();
            var addParam:BaseParam = new BaseParam();
            
            // ステータスレシオ
            var ratio:Number;
            if (data.masterData.MaxLv == 0)
            {
                ratio = 1;
            }
            else
            {
                ratio = (data.nowLv - 1.0) / (data.masterData.MaxLv - 1.0);
            }
            
            //基本ステータスゲット
            for (i = 0; i < MasterCharaData.DATA_TYPE.length; i++)
            {
                var str:String = MasterCharaData.DATA_TYPE[i];
                var addPoint:int = Math.floor((data.masterData.maxParam[str] - data.masterData.minParam[str]) * ratio);
                
                var point:int = data.masterData.minParam[str] + addPoint;
                addParam[BaseParam.STATUS_STR[i]] = point;
                
                //強化ポイント
                for (j = 0; j < BaseParam.STATUS_STR.length; j++)
                {
                    switch (BaseParam.STATUS_STR[j])
                    {
                    case "HP": 
                    case "FP": 
                        addParam[BaseParam.STATUS_STR[j]] += data.strengthPoint * 3;
                        break;
                    case "MOV": 
                        break;
                    default: 
                        addParam[BaseParam.STATUS_STR[j]] += data.strengthPoint;
                        break;
                    }
                }
                
                if (data.param[BaseParam.STATUS_STR[i]] > addParam[BaseParam.STATUS_STR[i]])
                {
                    paramColor[i] = 0x44FF44;
                }
                else if (data.param[BaseParam.STATUS_STR[i]] < addParam[BaseParam.STATUS_STR[i]])
                {
                    paramColor[i] = 0xFF4444;
                }
                else
                {
                    paramColor[i] = 0xFFFFFF;
                }
                
            }
            
            _lvImg.setNumber(data.showLv, ImgNumber.TYPE_STATE_Lv);
            addChild(_lvImg);
            _hpImg.setMaxNumber(data.nowHp, data.param.HP, ImgNumber.TYPE_STATE_HP, paramColor[0]);
            addChild(_hpImg);
            _fpImg.setMaxNumber(data.nowFp, data.param.FP, ImgNumber.TYPE_STATE_FP, paramColor[1]);
            addChild(_fpImg);
            _tpImg.setMaxNumber(data.nowTp, 100, ImgNumber.TYPE_STATE_TP);
            addChild(_tpImg);
            _atkImg.setNumber(data.param.ATK, ImgNumber.TYPE_STATE_ATK, paramColor[2]);
            addChild(_atkImg);
            _defImg.setNumber(data.param.DEF, ImgNumber.TYPE_STATE_DEF, paramColor[3]);
            addChild(_defImg);
            _tecImg.setNumber(data.param.TEC, ImgNumber.TYPE_STATE_TEC, paramColor[4]);
            addChild(_tecImg);
            _spdImg.setNumber(data.param.SPD, ImgNumber.TYPE_STATE_SPD, paramColor[5]);
            addChild(_spdImg);
            _capImg.setNumber(data.param.CAP, ImgNumber.TYPE_STATE_CAP, paramColor[6]);
            addChild(_capImg);
            _mndImg.setNumber(data.param.MND, ImgNumber.TYPE_STATE_MND, paramColor[7]);
            addChild(_mndImg);
            _movImg.setNumber(data.param.MOV, ImgNumber.TYPE_STATE_MOV, paramColor[8]);
            addChild(_movImg);
            
            if (data.param.HIT > 0)
            {
                _hitImg.setNumber(data.param.HIT, ImgNumber.TYPE_STATE_HIT, 0x44FF44);
                _hitImg.visible = true;
                addChild(_hitImg);
            }
            else
            {
                _hitImg.visible = false;
                removeChild(_hitImg);
            }            
            //回避
            if (data.param.EVA > 0)
            {
                _evaImg.setNumber(data.param.EVA, ImgNumber.TYPE_STATE_EVA, 0x44FF44);
                _evaImg.visible = true;
                addChild(_evaImg);
            }
            else
            {
                _evaImg.visible = false;
                removeChild(_evaImg);
            }
            //this.addEventListener(TouchEvent.TOUCH, clickHandler);
        }
        
        /**キャラデータセット*/
        public function setCommanderData(data:CommanderData):void
        {
            var charaData:MasterCommanderData = CharaDataUtil.getMasterCommanderDataName(data.masterData.name);
            setPosCommanderParam(data);
            imgSet(charaData.charaImgName);
            
            _nameTxt.text = charaData.nickName;
            //_lvTxt.text = "Lv:" + data.nowLv;
            addChild(_windowImg);
            addChild(_faceImgBoard);
            addChild(_nameTxt);
            
            var i:int = 0;
            var j:int = 0;
            
            var addParam:BaseParam = new BaseParam();
            
            // ステータスレシオ
            var ratio:Number;
            if (data.masterData.MaxLv == 0)
            {
                ratio = 1;
            }
            else
            {
                ratio = (data.nowLv - 1.0) / (data.masterData.MaxLv - 1.0);
            }
            
            //基本ステータスゲット
            for (i = 0; i < MasterCommanderData.DATA_TYPE.length; i++)
            {
                var str:String = MasterCommanderData.DATA_TYPE[i];
                var addPoint:int = Math.floor((data.masterData.maxParam[str] - data.masterData.minParam[str]) * ratio);
                
                var point:int = data.masterData.minParam[str] + addPoint;
                addParam[BaseParam.STATUS_STR[i]] = point;
            }
            
            _lvImg.setNumber(data.nowLv, ImgNumber.TYPE_STATE_Lv);
            addChild(_lvImg);
            
            _spImg.setMaxNumber(data.nowPoint, data.Point, ImgNumber.TYPE_STATE_SP);
            addChild(_spImg);
            _atkImg.setNumber(data.param.ATK, ImgNumber.TYPE_STATE_ATK);
            addChild(_atkImg);
            _defImg.setNumber(data.param.DEF, ImgNumber.TYPE_STATE_DEF);
            addChild(_defImg);
            _tecImg.setNumber(data.param.TEC, ImgNumber.TYPE_STATE_TEC);
            addChild(_tecImg);
            _spdImg.setNumber(data.param.SPD, ImgNumber.TYPE_STATE_SPD);
            addChild(_spdImg);
            _mndImg.setNumber(data.param.MND, ImgNumber.TYPE_STATE_MND);
            addChild(_mndImg);
            _capImg.setNumber(data.param.CAP, ImgNumber.TYPE_STATE_CAP);
            addChild(_capImg);
            _movImg.setNumber(data.param.MOV, ImgNumber.TYPE_STATE_MOV);
            addChild(_movImg);
            _hitImg.setNumber(data.param.HIT, ImgNumber.TYPE_STATE_HIT);
            addChild(_hitImg);
            _evaImg.setNumber(data.param.EVA, ImgNumber.TYPE_STATE_EVA);
            addChild(_evaImg);
            _healImg.setNumber(data.Heal, ImgNumber.TYPE_STATE_HEAL);
            addChild(_healImg);
            _supplyImg.setNumber(data.Supply, ImgNumber.TYPE_STATE_SUPPLY);
            addChild(_supplyImg);
        
            //this.addEventListener(TouchEvent.TOUCH, clickHandler);
        }
        
        /**画像セット*/
        private function imgSet(charaImgName:String):void
        {
            var i:int = 0;
            var imgData:FaceData = MainController.$.model.getCharaImgDataFromName(charaImgName);
            
            _faceImgBoard.imgClear();
            
            for (i = 0; i < imgData.basicList.length; i++)
            {
                var faceImg:CImage = new CImage(MainController.$.imgAsset.getTexture(imgData.getFileName(imgData.basicList[i])));
                _faceImgBoard.addImage(faceImg, imgData.defaultType);
            }
            
            switch (imgData.defaultType)
            {
            case "stand": 
                _faceImgBoard.x = 570 - _faceImgBoard.width / 2;
                if (_faceImgBoard.height < CommonDef.WINDOW_H)
                {
                    _faceImgBoard.y = CommonDef.WINDOW_H - _faceImgBoard.height + _faceImgBoard.zeroPos;
                }
                else
                {
                    _faceImgBoard.y = _faceImgBoard.zeroPos;
                }
                break;
            case "icon": 
                break;
            }
        }
        
        private function clickHandler(event:TouchEvent):void
        {
            var touch:Touch = event.getTouch(this);
            //タッチしているか
            //var pos:Point;
            if (touch)
            {
                //pos = _unitImage.globalToLocal(new Point(touch.globalX, touch.globalY));
                //クリック上げた時
                switch (touch.phase)
                {
                //ボタン離す
                case TouchPhase.ENDED: 
                    if (_callBack != null)
                    {
                        _callBack(_data.name);
                    }
                    break;
                //マウスオーバー
                case TouchPhase.HOVER: 
                    _windowImg.color = 0x4444FF;
                    break;
                case TouchPhase.STATIONARY: 
                    break;
                //ドラッグ
                case TouchPhase.MOVED: 
                    break;
                //押した瞬間
                case TouchPhase.BEGAN: 
                    break;
                }
            }
            else
            {
                _windowImg.color = 0xFFFFFF;
            }
        }
        
        /**ステータス位置セット*/
        private function setPosCommanderParam(data:CommanderData):void
        {
            _lvImg.visible = true;
            _spImg.visible = true;
            _hpImg.visible = false;
            _fpImg.visible = false;
            _tpImg.visible = false;
            _atkImg.visible = data.param.ATK > 0 ? true : false;
            _defImg.visible = data.param.DEF > 0 ? true : false;
            _tecImg.visible = data.param.TEC > 0 ? true : false;
            _spdImg.visible = data.param.SPD > 0 ? true : false;
            _mndImg.visible = data.param.MND > 0 ? true : false;
            _capImg.visible = data.param.CAP > 0 ? true : false;
            _movImg.visible = data.param.MOV > 0 ? true : false;
            _hitImg.visible = data.HIT > 0 ? true : false;
            _evaImg.visible = data.EVA > 0 ? true : false;
            _supplyImg.visible = data.Supply > 0 ? true : false;
            _healImg.visible = data.Heal > 0 ? true : false;
            
            _lvImg.x = 8;
            _lvImg.y = 32;
            
            _spImg.x = 8;
            _spImg.y = 64;
            
            var posYCount:int = 0;
            
            for (var i:int = 0; i < COMMAND_IMG_LIST.length; i++  )
            {
                if (this[COMMAND_IMG_LIST[i]].visible == true)
                {
                    this[COMMAND_IMG_LIST[i]].x = ST_LEFT_X;
                    this[COMMAND_IMG_LIST[i]].y = 104 + ST_BETWEEN_Y * posYCount;
                    posYCount++;
                }
            }
        }
        
        /**ステータス位置セット*/
        private function setPosCharaParam():void
        {
            _lvImg.visible = true;
            _hpImg.visible = true;
            _fpImg.visible = true;
            _tpImg.visible = true;
            _atkImg.visible = true;
            _defImg.visible = true;
            _tecImg.visible = true;
            _spdImg.visible = true;
            _mndImg.visible = true;
            _capImg.visible = true;
            _movImg.visible = true;
            _hitImg.visible = false;
            _evaImg.visible = false;
            _spImg.visible = false;
            _healImg.visible = false;
            _supplyImg.visible = false;
            _lvImg.x = 8;
            _lvImg.y = 32;
            _hpImg.x = 8;
            _hpImg.y = 64;
            _fpImg.x = 8;
            _fpImg.y = 96;
            _tpImg.x = 8;
            _tpImg.y = 128;
            _atkImg.x = ST_LEFT_X;
            _atkImg.y = ST_BASE_Y + ST_BETWEEN_Y * 0;
            _defImg.x = ST_RIGHT_X;
            _defImg.y = ST_BASE_Y + ST_BETWEEN_Y * 0;
            _tecImg.x = ST_LEFT_X;
            _tecImg.y = ST_BASE_Y + ST_BETWEEN_Y * 1;
            _spdImg.x = ST_RIGHT_X;
            _spdImg.y = ST_BASE_Y + ST_BETWEEN_Y * 1;
            _mndImg.x = ST_LEFT_X;
            _mndImg.y = ST_BASE_Y + ST_BETWEEN_Y * 2;
            _capImg.x = ST_RIGHT_X;
            _capImg.y = ST_BASE_Y + ST_BETWEEN_Y * 2;
            _movImg.x = ST_LEFT_X;
            _movImg.y = ST_BASE_Y + ST_BETWEEN_Y * 3;
            _hitImg.x = ST_LEFT_X;
            _hitImg.y = ST_BASE_Y + ST_BETWEEN_Y * 4;
            _evaImg.x = ST_RIGHT_X;
            _evaImg.y = ST_BASE_Y + ST_BETWEEN_Y * 4;
        }
    
    }

}