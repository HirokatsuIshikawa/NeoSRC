package database.master.base
{
    
    /**
     * ...
     * @author ...
     * 最大最小ステータス
     */
    public class MasterParamData
    {
        public var minParam:BaseParam = null;
        public var maxParam:BaseParam = null;
        
        public function MasterParamData()
        {
            minParam = new BaseParam();
            maxParam = new BaseParam();
        }
        
        /**地形適正*/
        protected var _terrain:Vector.<int> = null;
        
        public function get terrain():Vector.<int>
        {
            return _terrain;
        }
    
    }

}