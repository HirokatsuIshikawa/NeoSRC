package common
{
    
    /**
     * ...
     * @author ishikawa
     */
    public class SystemController
    {
        /**インスタンス*/
        private static var _instance:SystemController;
        
        /**イベントシーンスプライト*/
        private var _view:NeoSRC = null;
        
        public function SystemController(_v:NeoSRC)
        {
            
            if (!_view)
            {
                _view = _v;
            }
            
            init();
        }
        
        /**初期化*/
        private function init():void
        {
            //インスタンス設定
            _instance = this;
            _view.start();
        }
        
        public function get view():NeoSRC
        {
            return _view;
        }
        
        static public function get $():SystemController
        {
            return _instance;
        }
    }

}