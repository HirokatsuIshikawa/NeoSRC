package scene.map
{
    import common.CommonDef;
    import flash.geom.Rectangle;
    import flash.text.TextFormatAlign;
    import main.MainController;
    import starling.events.Event;
    import starling.textures.TextureSmoothing;
    import system.custom.customSprite.CButton;
    import system.custom.customSprite.CImage;
    import system.custom.customSprite.CImgButton;
    import system.custom.customSprite.CSprite;
    import system.custom.customSprite.CTextArea;
    
    /**
     * ...
     * @author ...
     */
    public class ConditionWindow extends CSprite
    {
        protected var _backImg:CImage = null;
        
        protected var _victoryBaseImg:CImage = null;
        protected var _victoryTitleText:CTextArea = null;
        protected var _victoryText:CTextArea = null;
        
        protected var _defeatBaseImg:CImage = null;
        protected var _defeatTitleText:CTextArea = null;
        protected var _defeatText:CTextArea = null;
        
        protected var _closeBtn:CImgButton = null;
        
        public function ConditionWindow()
        {
            
            super();
            _backImg = new CImage(MainController.$.imgAsset.getTexture("tex_black"));
            _backImg.width = CommonDef.WINDOW_W;
            _backImg.height = CommonDef.WINDOW_H;
            _backImg.alpha = 0.7;
            addChild(_backImg);
            
            var i:int = 0;
            
            //勝利条件
            if (MainController.$.model.playerParam.victoryConditions != null)
            {
                
                _victoryBaseImg = new CImage(MainController.$.imgAsset.getTexture("listitem"));
                _victoryBaseImg.scale9Grid = new Rectangle(6, 6, 20, 20);
                _victoryBaseImg.x = 100;
                _victoryBaseImg.y = 40;
                _victoryBaseImg.width = CommonDef.WINDOW_W - 200;
                _victoryBaseImg.height = 200;
                _victoryBaseImg.textureSmoothing = TextureSmoothing.NONE;
                addChild(_victoryBaseImg);
                
                _victoryTitleText = new CTextArea(32, 0xFF4444, 0x0);
                _victoryTitleText.styleName = "noveltext";
                _victoryTitleText.width = CommonDef.WINDOW_W - 200;
                _victoryTitleText.height = 40;
                _victoryTitleText.x = _victoryBaseImg.x + 12;
                _victoryTitleText.y = _victoryBaseImg.y + 12;
                _victoryTitleText.text = "勝利条件";
                addChild(_victoryTitleText);
                
                _victoryText = new CTextArea(24, 0xFFFFFF, 0x0, TextFormatAlign.LEFT, false, true);
                _victoryText.styleName = "noveltext";
                _victoryText.width = CommonDef.WINDOW_W - 200;
                _victoryText.height = 160;
                _victoryText.x = _victoryBaseImg.x + 16;
                _victoryText.y = _victoryBaseImg.y + 54;
                _victoryText.text = "";
                
                var list:Array = MainController.$.model.playerParam.victoryConditions.split(",");
                
                for (i = 0; i < list.length; i++)
                {
                    if (i > 0)
                    {
                        _victoryText.text += "\n";
                    }
                    _victoryText.text += list[i];
                }
                addChild(_victoryText);
                
            }
            
            //敗北条件
            if (MainController.$.model.playerParam.victoryConditions != null)
            {
                
                _defeatBaseImg = new CImage(MainController.$.imgAsset.getTexture("listitem"));
                _defeatBaseImg.scale9Grid = new Rectangle(6, 6, 20, 20);
                _defeatBaseImg.x = 100;
                _defeatBaseImg.y = 280;
                _defeatBaseImg.width = CommonDef.WINDOW_W - 200;
                _defeatBaseImg.height = 200;
                _defeatBaseImg.textureSmoothing = TextureSmoothing.NONE;
                addChild(_defeatBaseImg);
                
                _defeatTitleText = new CTextArea(32, 0x4444FF, 0x0);
                _defeatTitleText.styleName = "noveltext";
                _defeatTitleText.width = CommonDef.WINDOW_W - 200;
                _defeatTitleText.height = 40;
                _defeatTitleText.x = _defeatBaseImg.x + 12;
                _defeatTitleText.y = _defeatBaseImg.y + 12;
                _defeatTitleText.text = "敗北条件";
                addChild(_defeatTitleText);
                
                _defeatText = new CTextArea(24, 0xFFFFFF, 0x0, TextFormatAlign.LEFT, false, true);
                _defeatText.styleName = "noveltext";
                _defeatText.width = CommonDef.WINDOW_W - 200;
                _defeatText.height = 160;
                _defeatText.x = _defeatBaseImg.x + 16;
                _defeatText.y = _defeatBaseImg.y + 54;
                _defeatText.text = "";
                
                var defeatList:Array = MainController.$.model.playerParam.defeatConditions.split(",");
                
                for (i = 0; i < defeatList.length; i++)
                {
                    if (i > 0)
                    {
                        _defeatText.text += "\n";
                    }
                    _defeatText.text += defeatList[i];
                }
                addChild(_defeatText);
            }
            
            _closeBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_Return"));
            _closeBtn.x = CommonDef.WINDOW_W - 96;
            _closeBtn.y = CommonDef.WINDOW_H - 64;
            _closeBtn.width = 96;
            _closeBtn.height = 64;
            _closeBtn.addEventListener(Event.TRIGGERED, MainController.$.view.battleMap.hideConditionWindow);
            addChild(_closeBtn);
        
        }
        
        //-------------------------------------------------------------
        //
        // 廃棄
        //
        //-------------------------------------------------------------
        public override function dispose():void
        {
            _closeBtn.removeEventListener(Event.TRIGGERED, MainController.$.view.battleMap.hideConditionWindow);
            
            CommonDef.disposeList([_backImg, _victoryBaseImg, _victoryTitleText, _victoryText, _defeatBaseImg, _defeatTitleText, _defeatText, _closeBtn]);
            
            super.dispose();
        }
    }
}