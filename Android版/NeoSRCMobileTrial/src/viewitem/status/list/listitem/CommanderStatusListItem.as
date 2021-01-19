package viewitem.status.list.listitem
{
    import common.util.CharaDataUtil;
    import database.master.MasterCommanderData;
    import database.user.CommanderData;
    import database.user.FaceData;
    import feathers.controls.TextArea;
    import main.MainController;
    import starling.display.Quad;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import system.custom.customSprite.CImage;
    import system.custom.customSprite.CSprite;
    import system.custom.customSprite.ImageBoard;
    import viewitem.status.list.listitem.ListItemBase;
    
    /**
     * ...
     * @author ishikawa
     */
    public class CommanderStatusListItem extends ListItemBase
    {
        public static const LIST_WIDTH:int = 240;
        public static const LIST_HEIGHT:int = 104;
        public static const ICON_SIZE:int = 160;
        
        /**ユニットデータ*/
        private var _data:CommanderData = null;
        /**軍師画像*/
        private var _faceImg:ImageBoard = null;
        /**名前エリア*/
        private var _nameTxt:TextArea = null;
        
        private var _faceBase:CSprite = null;
        //画像マスク
        private var _faceMask:Quad = null;
        
        private var _isSelected:Boolean = false;
        
        public function CommanderStatusListItem(data:CommanderData)
        {
            super(LIST_WIDTH, LIST_HEIGHT);
            var i:int = 0;
            _data = data;
            
            //マスターキャラデータ取得
            var charaData:MasterCommanderData = CharaDataUtil.getMasterCommanderDataName(data.name);
            
            _faceBase = new CSprite();
            
            _nameTxt = new TextArea();
            _nameTxt.styleName = "list_text";
            _nameTxt.x = 112;
            _nameTxt.y = 40;
            _nameTxt.width = 120;
            _nameTxt.text = charaData.name;
            
            _faceImg = new ImageBoard();
            setImage(data.name);
            
            _faceBase.addChild(_faceImg);
            _faceBase.width = ICON_SIZE;
            _faceBase.height = ICON_SIZE;
            _faceBase.x = 20;
            _faceBase.y = 40;
            
            addChild(_faceBase);
            addChild(_nameTxt);
            
            this.addEventListener(TouchEvent.TOUCH, clickHandler);
        }
        
        override public function dispose():void
        {
            
            removeChild(_faceImg);
            _faceImg.dispose();
            _faceImg = null;
            
            removeChild(_nameTxt);
            _nameTxt.dispose();
            _nameTxt = null;
            
            if (_faceBase != null)
            {
                _faceBase.dispose();
            }
            _faceBase = null;
            
            this.removeEventListener(TouchEvent.TOUCH, clickHandler);
            super.dispose();
        }
        
        private function setImage(name:String):void
        {
            var i:int = 0, j:int = 0;
            ;
            //フェイスデータ
            var imgData:FaceData = MainController.$.model.getCharaImgDataFromName(name);
            
            switch (imgData.defaultType)
            {
            case "stand": 
                _faceMask = new Quad(160, imgData.addPoint.y + 80)
                _faceMask.x = 0;
                _faceMask.y = -(imgData.addPoint.y - (140 - 80));
                _faceBase.mask = _faceMask;
                break;
            case "icon": 
                break;
            }
            
            //画像セット
            _faceImg.setAdd(imgData.addPoint.x, imgData.addPoint.y);
            
            var showList:Vector.<String> = new Vector.<String>;
            
            for (i = 0; i < imgData.basicList.length; i++)
            {
                showList[i] = imgData.basicList[i];
            }
            
            for (i = 0; i < showList.length; i++)
            {
                //var faceImg:CImage = new CImage(TextureManager.loadTexture(imgData.imgUrl, imgData.getFileName(showList[i]), TextureManager.TYPE_CHARA));
                var imgFileName:String = imgData.getFileName(showList[i]);
                var faceImg:CImage = new CImage(MainController.$.imgAsset.getTexture(imgFileName));
                _faceImg.addImage(faceImg, imgData.defaultType);
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
                    _listImg.color = _isSelected ? 0xFF4444 : 0xFFFFFF;
                    MainController.$.view.interMission.callCommanderStatusWindow(_data);
                    break;
                //マウスオーバー
                case TouchPhase.HOVER: 
                    _listImg.color = 0x4444FF;
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
                _listImg.color = _isSelected ? 0xFF4444 : 0xFFFFFF;
            }
        }
        
        public function judgeSelect(name:String):void
        {
            _isSelected = (name === _data.name);
            _listImg.color = _isSelected ? 0xFF4444 : 0xFFFFFF;
        }
    }

}