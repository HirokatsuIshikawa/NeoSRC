package scene.base
{
    import database.master.MasterBaseData;
    import main.MainController;
    import starling.textures.Texture;
    import system.custom.customSprite.CImage;
    
    /**
     * ...
     * @author ...
     */
    public class BaseTip extends CImage
    {
        
        private var _masterData:MasterBaseData = null;
        private var _sideFrame:CImage = null;
        private var _sideNum:int = -1;
        private var _nowPoint:int = 0;
        
        private var _posX:int = 0;
        private var _posY:int = 0;
        
        private var _eventId:String = "";
        
        public function BaseTip(data:MasterBaseData, sideNum:int, eventId:String)
        {
            _masterData = data;
            _sideNum = sideNum;
            _eventId = eventId;
            var tex:Texture = MainController.$.imgAsset.getTexture(data.imgpath);
            
            if (tex == null)
            {
                tex = MainController.$.mapTipAsset.getTexture(data.imgpath);
            }
            
            if (tex == null)
            {
                tex = MainController.$.imgAsset.getTexture("tex_black");
                this.alpha = 0;
            }
            
            _nowPoint = 0;
            
            super(tex);
        }
        
         
        public function refreshSide(num:int):void
        {
            _sideNum = num;
            if (_sideFrame == null)
            {
                _sideFrame = new CImage(MainController.$.imgAsset.getTexture(MainController.$.map.sideState[num].flagImgPath));
                _sideFrame.x = this.x;
                _sideFrame.y = this.y;
                MainController.$.map.frameArea.addChildAt(_sideFrame, 0);
            }
            else
            {
                _sideFrame.texture = MainController.$.imgAsset.getTexture(MainController.$.map.sideState[num].flagImgPath);
            }
        }
        
        public function setPos(posX:int, posY:int):void
        {
            _posX = posX;
            _posY = posY;
            
            this.x = (posX - 1) * 32;
            this.y = (posY - 1) * 32;
        }
        
        public function get sideFrame():CImage
        {
            return _sideFrame;
        }
        
        public function get posX():int
        {
            return _posX;
        }
        
        public function get posY():int
        {
            return _posY;
        }
        
        public function get sideNum():int
        {
            return _sideNum;
        }
        
        public function set sideNum(value:int):void
        {
            _sideNum = value;
        }
        
        public function get masterData():MasterBaseData
        {
            return _masterData;
        }
        
        public function get nowPoint():int
        {
            return _nowPoint;
        }
        
        public function set nowPoint(value:int):void
        {
            _nowPoint = value;
        }
        
        public function get eventId():String 
        {
            return _eventId;
        }
        
        public function set sideFrame(value:CImage):void
        {
            _sideFrame = value;
        }
    }
}