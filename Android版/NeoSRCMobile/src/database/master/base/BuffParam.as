package database.master.base
{
	
	/**
	 * ...
	 * @author ...
	 */
	public class BuffParam
	{
		
		private var _alias:String = null;
		
		private var parcent:Boolean = false;
		
		/**パラメーターベース*/
		public var _param:BaseParam = null;
		
		public function BuffParam(data:Object)
		{
			
			_param = new BaseParam();
			
			var i:int = 0;
			var findFlg:Boolean = false;
			
			//パラメーター
			for (i = 0; i < BaseParam.STATUS_STR.length; i++)
			{
				if (data.hasOwnProperty(BaseParam.STATUS_STR[i]))
				{
					_param[BaseParam.STATUS_STR[i]] = getData(data[BaseParam.STATUS_STR[i]]);
					findFlg = true;
					
				}
			}
			//追加パラメーター
			for (i = 0; i < BaseParam.ADD_STR.length; i++)
			{
				if (data.hasOwnProperty(BaseParam.ADD_STR[i]))
				{
					_param[BaseParam.ADD_STR[i]] = getData(data[BaseParam.ADD_STR[i]]);
					findFlg = true;
				}
			}
		}
		
		public function getData(str:String):int
		{
			
			if (str.indexOf("%") >= 0)
			{
				str = str.replace("%", "");
				parcent = true;
			}
			else
			{
				parcent = false;
			}
			
			var num:int = int(str);
			
			return num;
		}
	
	}
}