package scene.talk.message
{
    import database.user.FaceData;
    import main.MainController;
    import scene.talk.message.MessageWindow;
    import starling.display.Quad;
    import system.custom.customSprite.CImage;
    import system.custom.customSprite.CSprite;
    import system.custom.customSprite.ImageBoard;
    
    /**
     * ...
     * @author
     */
    public class FaceMessageWindow extends MessageWindow
    {
        
        /**表示顔画像*/
        private var _faceImg:ImageBoard = null;
        private var _faceBase:CSprite = null;
        private var _faceMask:Quad;
        
        public function FaceMessageWindow()
        {
            super();
            /*
               _nameTxt.x = 160;
               _nameTxt.y = 0;
               _textArea.x = 160;
               _textArea.y = 28;
             */
            _faceBase = new CSprite();
            _faceImg = new ImageBoard();
            _faceBase.addChild(_faceImg);
            _faceMask = new Quad(160, 160);
            addChild(_faceBase);
        }
        
        public function setImage(name:String, command:Array = null):void
        {
            if (name == "システム")
            {
                _nameTxt.text = "";
                _nameTxt.x = 16;
                _textArea.x = 8;
                _textArea.width = 560;
                _faceImg.imgClear();
                return;
            }
            
            _nameTxt.x = 168;
            _textArea.x = 160;
            _textArea.width = 402;
            var i:int = 0;
            var j:int = 0;
            var k:int = 0;
            _charaName = name;
            _faceImg.imgClear();
            var imgData:FaceData = MainController.$.model.getCharaImgDataFromName(name);
            switch (imgData.defaultType)
            {
            case "stand":
                
                _faceMask.dispose();
                _faceMask = null;
                _faceMask = new Quad(160, imgData.addPoint.y + 80)
                
                //_faceMask.height = imgData.addPoint.y + 80;
                _faceMask.x = 0;
                _faceMask.y = -(imgData.addPoint.y - (140 - 80));
                //_faceImg.x = (imgData.addPoint.x - 160) / 2;
                //_faceImg.y = (imgData.addPoint.y - 140);
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
            
            if (command != null && command.length >= 2)
            {
                for (j = 2; j < command.length; j++)
                {
                    var str:String = command[j];
                    if (str.indexOf(":") >= 0)
                    {
                        continue;
                    }
                    
                    for (k = 0; k < imgData.imgList.length; k++)
                    {
                        if (str === imgData.imgList[k].name)
                        {
                            showList[imgData.imgList[k].layer] = imgData.imgList[k].name;
                        }
                    }
                }
            }
            
            for (i = 0; i < showList.length; i++)
            {
                //var faceImg:CImage = new CImage(TextureManager.loadTexture(imgData.imgUrl, imgData.getFileName(showList[i]), TextureManager.TYPE_CHARA));
                var imgFileName:String = imgData.getFileName(showList[i]);
                var faceImg:CImage = new CImage(MainController.$.imgAsset.getTexture(imgFileName));
                _faceImg.addImage(faceImg, imgData.defaultType);
            }
            
            //_faceImg = MainController.$.model.getCharaBaseImg(name, MainModel.IMG_BOARD_FACE);
            _nameTxt.text = name;
        }
        
        override public function dispose():void
        {
            if (_faceImg != null)
            {
                _faceImg.dispose();
            }
            if (_faceBase != null)
            {
                _faceBase.dispose();
            }
            _faceImg = null;
            _faceBase = null;
            //_textArea.textViewPort.textField.filters = null;
            super.dispose();
        }
        
        public function deleteImage():void
        {
            _faceImg.imgClear();
        }
    
    }
}