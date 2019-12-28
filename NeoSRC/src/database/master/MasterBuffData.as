package database.master
{
	import common.CommonDef;
	import database.master.base.BaseParam;
	import database.master.base.BuffParam;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MasterBuffData
	{
		/**識別用ID*/
		protected var _id:int = 0;
		
		public function get id():int  { return _id; }
		
		/**バフ名*/
		protected var _name:String = null;
		
		public function get name():String  { return _name; }
		
		public var buffParam:Vector.<BuffParam> = null;
		
		public function MasterBuffData()
		{
		
		}
		
		public function setData(id:int, data:Object):void
		{
			_id = id;
			var i:int = 0;
			buffParam = new Vector.<BuffParam>();
			_name = data.name;
			
			//個数取得、名前を外す
			var maxNum:int = CommonDef.objectLength(data) - 1;
			
			for (i = 0; i < maxNum; i++)
			{
				buffParam.push(new BuffParam(data[i]));
			}
		
		}
	
	}

}