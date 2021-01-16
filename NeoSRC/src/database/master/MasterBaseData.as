package database.master
{
    import common.CommonDef;
    import database.master.base.BaseParam;
    import database.master.base.BuffParam;
    
    /**
     * ...
     * @author ...
     */
    public class MasterBaseData
    {
        
        //拠点データ
        public static const BASE_INIT_TYPE:Array = [ //
        "income", "getpoint", //
        "heal", "supply", "bullet", //
        "producttype", "productlevel", //
        "imgpath"
        ];
        
        public static const BASE_INIT_VALUE:Array = [ //
        0, 0, //
        0, 0, 0, //
        "", 0 //
        ];
        
        /**識別用ID*/
        protected var _id:int = 0;
        
        public function get id():int  { return _id; }
        
        /**バフ名*/
        protected var _name:String = null;
        
        public function get imgpath():String 
        {
            return _imgpath;
        }
        
        public function get getpoint():int 
        {
            return _getpoint;
        }
        
        public function get name():String  { return _name; }
        
        protected var _income:int;
        protected var _getpoint:int;
        protected var _heal:int;
        protected var _supply:int;
        protected var _bullet:int;
        protected var _producttype:String;
        protected var _productlevel:int;
        protected var _imgpath:String;
        
        public function MasterBaseData(id:int, data:Object):void
        {
            _id = id;
            var i:int = 0;
            _name = data.name;
            
            //各種ステータス
            for (i = 0; i < BASE_INIT_TYPE.length; i++)
            {
                if (data.hasOwnProperty(BASE_INIT_TYPE[i]))
                {
                    this["_" + BASE_INIT_TYPE[i]] = data[BASE_INIT_TYPE[i]];
                }
                else
                {
                    this["_" + BASE_INIT_TYPE[i]] = BASE_INIT_VALUE[i];
                }
            }
        }
    }
}