package viewitem.status.list
{
    import common.CommonDef;
    import feathers.controls.Slider;
    import feathers.layout.Direction;
    import main.MainController;
    import starling.display.Quad;
    import starling.events.Event;
    import system.custom.customSprite.CImage;
    import system.custom.customSprite.CImgButton;
    import system.custom.customSprite.CSprite;
    import viewitem.status.list.listitem.StatusListItem;
    
    /**
     * ...
     * @author ishikawa
     */
    public class UnitListBase extends CSprite
    {
        /**暗幕画像*/
        private var _backImg:CImage = null;
        private var _itemList:Vector.<StatusListItem> = null;
        
        protected var _listArea:CSprite = null;
        protected var _listContena:CSprite = null;
        protected var _sliderBack:CImage = null;
        protected var _slider:Slider = null;
        
        public function UnitListBase()
        {
            super();
            
            //暗幕設定
            _backImg = new CImage(MainController.$.imgAsset.getTexture("tex_black"));
            _backImg.alpha = 0.8;
            _backImg.width = CommonDef.WINDOW_W;
            _backImg.height = CommonDef.WINDOW_H;
            addChild(_backImg);
            
            //リスト下地
            _listArea = new CSprite();
            _listArea.mask = new Quad(CommonDef.WINDOW_W - 96, CommonDef.WINDOW_H);
            _listArea.x = 0;
            _listArea.y = 0;
            addChild(_listArea);
            
            //リストのっけ
            _listContena = new CSprite();
            _listArea.addChild(_listContena);
            
            //スライダー背景
            _sliderBack = new CImage(MainController.$.imgAsset.getTexture("tex_black"));
            _sliderBack.x = 16;
            _sliderBack.y = 0;
            _sliderBack.width = 32;
            _sliderBack.height = CommonDef.WINDOW_H;
            _sliderBack.touchable = false;
            _sliderBack.visible = false;
            addChild(_sliderBack);
        
        }
        
        public function setSlider(count:int):void
        {
            
            //スライダー
            _slider = new Slider();
            //_slider.visible = false;
            _slider.direction = Direction.VERTICAL;
            _slider.width = 32;
            _slider.x = 16;
            _slider.y = 0;
            _slider.height = CommonDef.WINDOW_H;
            _slider.step = 0.1;
            _slider.page = 0.5;
            _slider.value = 0;
            _slider.addEventListener(Event.CHANGE, listAreaMove);
            _slider.visible = false;
            
            //リスト高
            var listHeight:int = Math.ceil(count / 3) * (StatusListItem.LIST_HEIGHT + 24) - 24;
            
            //スライダー表示
            if (listHeight > CommonDef.WINDOW_H)
            {
                
                _sliderBack.visible = true;
                _slider.visible = true;
                _slider.minimum = -(listHeight - CommonDef.WINDOW_H);
                _slider.maximum = 0;
                _slider.thumbFactory = function():CImgButton
                {
                    var button:CImgButton = new CImgButton(MainController.$.imgAsset.getTexture("tex_white"));
                    button.height = Math.max(CommonDef.WINDOW_H - (listHeight - CommonDef.WINDOW_H), 32);
                    button.width = 32;
                    return button;
                }
                addChild(_slider);
            }
        
        }
        
        /**スライダーイベント*/
        protected function listAreaMove(e:Event):void
        {
            var slid:Slider = e.target as Slider;
            _listContena.y = slid.value;
        }
        
        override public function dispose():void
        {
            _listContena.dispose();
            _listArea.dispose();
            
            _slider.removeEventListener(Event.CHANGE, listAreaMove);
            _slider.dispose();
            
            _listContena = null;
            _listArea = null;
            _slider = null;
            
            if (_sliderBack != null)
            {
                _sliderBack.dispose();
            }
            
            _sliderBack = null;
            super.dispose();
        }
    
    }

}