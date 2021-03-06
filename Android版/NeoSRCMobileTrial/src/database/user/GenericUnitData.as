package database.user 
{
	import database.master.MasterCharaData;
	/**
	 * ...
	 * @author ...
	 */
	public class GenericUnitData 
	{
		private var _data:MasterCharaData;
		private var _lv:int;
		private var _cost:int;
		
		private var _customBgm:String = "";
		
		public function get cost():int 
		{
			return _cost;
		}
		
		public function get lv():int 
		{
			return _lv;
		}
		
		public function GenericUnitData(data:MasterCharaData, lv:int, cost:int) 
		{
			_data = data;
			_lv = lv;
			_cost = cost;
		}
		
		public function refreshData(lv:int, cost:int):void
		{
			_lv = lv;
			_cost = cost;
		}
		
		public function get name():String
		{
			return _data.name;
		}
        
        public function get data():MasterCharaData 
        {
            return _data;
        }
        
		public function get nickName():String
		{
			return _data.nickName;
		}
        
        public function get customBgm():String 
        {
            return _customBgm;
        }
        
        public function set customBgm(value:String):void 
        {
            _customBgm = value;
        }
		
		public function compareName(name:String):Boolean
		{
			return _data.nickName === name || _data.name === name;
		}
		
	}
}