package scene.base
{
    import common.CommonDef;
    import flash.geom.Rectangle;
    import main.MainController;
    import starling.events.Event;
    import starling.textures.Texture;
    import starling.textures.TextureSmoothing;
    import system.custom.customSprite.CButton;
    import system.custom.customSprite.CImage;
    import system.custom.customSprite.CImgButton;
    import system.custom.customSprite.CSprite;
    import system.custom.customSprite.CTextArea;
    import viewitem.parts.numbers.ImgNumber;
    import viewitem.status.list.listitem.ListItemBase;
    
    /**
     * ...
     * @author ...
     */
    public class BaseInfo extends CSprite
    {
        //背景暗幕
        private var _backImg:CImage = null;
        //画面背景
        protected var _listImg:CImage = null;
        // 名前
        private var _name:CTextArea = null;
        
        // 収入
        private var _incomeImg:CImage = null;
        private var _incomeValue:ImgNumber = null;
        
        // 制圧度
        private var _getPointImg:CImage = null;
        private var _getPointValue:ImgNumber = null;
        
        // 回復値
        private var _healImg:CImage = null;
        private var _healValue:ImgNumber = null;
        
        // 補給値
        private var _supplyImg:CImage = null;
        private var _supplyValue:ImgNumber = null;
        
        private var _productTypeText:CTextArea = null;
        //生産ボタン
        private var _productButton:CImgButton = null;
        private var _closeButton:CImgButton = null;
        
        private var _productCallBack:Function = null;
        private var _closeCallBack:Function = null;
        
        private var _data:BaseTip = null;
        
        public static const TOP_POSY:int = 46;
        public static const UNDER_POSY:int = 86;
        
        public function BaseInfo(data:BaseTip, sideName:String, productCallBack:Function, closeCallBack:Function)
        {
            super();
            _data = data;
            _productCallBack = productCallBack;
            _closeCallBack = closeCallBack;
            var tex:Texture = null;
            
            //暗幕設定
            _backImg = new CImage(MainController.$.imgAsset.getTexture("tex_black"));
            _backImg.alpha = 0.4;
            _backImg.width = CommonDef.WINDOW_W;
            _backImg.height = CommonDef.WINDOW_H;
            
            //背景
            _listImg = new CImage(MainController.$.imgAsset.getTexture("listitem"));
            _listImg.scale9Grid = new Rectangle(6, 6, 20, 20);
            
            _listImg.width = 640;
            _listImg.height = 140;
            _listImg.x = (CommonDef.WINDOW_W - 640) / 2;
            _listImg.y = (CommonDef.WINDOW_H - 140) / 2;
            _listImg.textureSmoothing = TextureSmoothing.NONE;
            
            //収入
            if (data.masterData.income > 0)
            {
                var income:int = (int)(data.masterData.income);
                _incomeImg = new CImage(MainController.$.imgAsset.getTexture("Skl_income"));
                _incomeImg.x = _listImg.x + 8;
                _incomeImg.y = _listImg.y + TOP_POSY;
                
                _incomeValue = new ImgNumber();
                if (data.masterData.income <= 0)
                {
                    _incomeValue.setNone(income);
                }
                else
                {
                    _incomeValue.setNumber(income);
                }
                _incomeValue.x = _incomeImg.x + _incomeImg.width + 32;
                _incomeValue.y = _incomeImg.y;
            }
            
            //制圧
            if (data.masterData.getpoint > 0)
            {
                var getpoint:int = (int)(data.masterData.getpoint);
                _getPointImg = new CImage(MainController.$.imgAsset.getTexture("Skl_getpoint"));
                _getPointImg.x = _listImg.x + 240;
                _getPointImg.y = _listImg.y + TOP_POSY;
                
                _getPointValue = new ImgNumber();
                if (data.masterData.getpoint <= 0)
                {
                    _getPointValue.setNone(getpoint);
                }
                else
                {
                    _getPointValue.setNumber(getpoint);
                }
                _getPointValue.x = _getPointImg.x + _getPointImg.width + 32;
                _getPointValue.y = _getPointImg.y;
            }
            
            //回復
            if (data.masterData.heal > 0)
            {
                var heal:int = (int)(data.masterData.heal);
                _healImg = new CImage(MainController.$.imgAsset.getTexture("Skl_heal"));
                _healImg.x = _listImg.x + 8;
                _healImg.y = _listImg.y + UNDER_POSY;
                
                _healValue = new ImgNumber();
                if (data.masterData.heal <= 0)
                {
                    _healValue.setNone(heal);
                }
                else
                {
                    _healValue.setNumber(heal);
                }
                _healValue.x = _healImg.x + _healImg.width + 32;
                _healValue.y = _healImg.y;
            }
            
            //補給
            if (data.masterData.supply > 0)
            {
                var supply:int = (int)(data.masterData.supply);
                _supplyImg = new CImage(MainController.$.imgAsset.getTexture("Skl_spl"));
                _supplyImg.x = _listImg.x + 240;
                _supplyImg.y = _listImg.y + UNDER_POSY;
                
                _supplyValue = new ImgNumber();
                if (data.masterData.supply <= 0)
                {
                    _supplyValue.setNone(supply);
                }
                else
                {
                    _supplyValue.setNumber(supply);
                }
                _supplyValue.x = _supplyImg.x + _supplyImg.width + 32;
                _supplyValue.y = _supplyImg.y;
            }
            
            //閉じるボタン
            tex = MainController.$.imgAsset.getTexture("btn_close");
            _closeButton = new CImgButton(tex);
            _closeButton.x = _listImg.x + 640 - tex.width;
            _closeButton.y = _listImg.y;
            _closeButton.addEventListener(Event.TRIGGERED, closeHandler);
            
            //生産ボタン・生産可能で味方の場合のみ表示
            if (_data.masterData.producttype.length > 0 && _data.sideNum == 0)
            {
                tex = MainController.$.imgAsset.getTexture("btn_product");
                //生産ボタン
                _productButton = new CImgButton(tex);
                _productButton.x = _listImg.x + 640 - tex.width;
                _productButton.y = _listImg.y + 140 - tex.height;
                
                _productButton.addEventListener(Event.TRIGGERED, productHandler);
            }
            
            //名称・所属
            _name = new CTextArea(24, 0xFFFFFF, 0x0);
            _name.width = 600;
            _name.x = _listImg.x + 20;
            _name.y = _listImg.y + 8;
            _name.height = 32;
            _name.text = data.masterData.name;
            if (sideName != null && sideName.length > 0)
            {
                _name.text += "-" + sideName;
            }
            
            addChild(_backImg);
            addChild(_listImg);
            
            if (_incomeImg != null)
            {
                addChild(_incomeImg);
                addChild(_incomeValue);
            }
            
            if (_getPointImg != null)
            {
                addChild(_getPointImg);
                addChild(_getPointValue);
            }
            
            if (_healImg != null)
            {
                addChild(_healImg);
                addChild(_healValue);
            }
            if (_supplyImg != null)
            {
                addChild(_supplyImg);
                addChild(_supplyValue);
            }
            
            addChild(_closeButton);
            if (_productButton != null)
            {
                addChild(_productButton);
            }
            addChild(_name);
        
        }
        
        public override function dispose():void
        {
            
            _closeButton.removeEventListener(Event.TRIGGERED, closeHandler);
            
            if (_productButton != null)
            {
                _productButton.removeEventListener(Event.TRIGGERED, productHandler);
            }
            
            CommonDef.disposeList([_backImg, _listImg, _closeButton, _productButton, _name]);
            
            super.dispose();
        }
        
        private function productHandler(e:Event):void
        {
            _productCallBack(_data);
        }
        
        private function closeHandler(e:Event):void
        {
            _closeCallBack();
        }
    }
}