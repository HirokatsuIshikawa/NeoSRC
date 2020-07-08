package scene.intermission.customdata
{
	import system.custom.customData.CData;
	import scene.talk.classdata.SelectCommandData;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class PlayerVariable extends CData
	{
		
		public static const TYPE_NONE:String = "無し";
		public static const TYPE_NUM:String = "数値";
		public static const TYPE_STRING:String = "文字列";
		public static const TYPE_SELECT:String = "選択肢";
		public static const TYPE_LIST:String = "配列";
		
		protected var _name:String = null;
		protected var _type:String = "";
		protected var _global:Boolean = false;
		
		protected var _number:int = 0;
		protected var _str:String = null;
		protected var _selectList:Vector.<SelectCommandData> = null;
		protected var _list:Vector.<PlayerVariable> = null;
		
		public function PlayerVariable(setName:String = "")
		{
			_name = setName;
		}
		
		public function setValue(value:Object):void
		{
			if (isNaN(Number(value as String)))
			{
				_type = TYPE_STRING;
				_str = value + "";
			}
			else
			{
				_type = TYPE_NUM;
				_number = int(value);
				
			}
		}
		
		public function setNumber(num:int):void
		{
			_type = TYPE_NUM;
			_number = num;
		}
		
		public function setString(value:String):void
		{
			_type = TYPE_STRING;
			_str = value;
		}
		
		public function setList():void
		{
			_type = TYPE_LIST;
			_list = new Vector.<PlayerVariable>();
		}
		
		public function pushList(value:Object):void
		{
			var num:int = _list.length;
			
			_list[num] = new PlayerVariable(num + "");
			
			_list[num].setValue(value);
		}
		
		public function setSelectList():void
		{
			_type = TYPE_SELECT;
			_selectList = new Vector.<SelectCommandData>;
		}
		
		public function pushSelect(param:Object):void
		{
			
			var selectData:SelectCommandData = new SelectCommandData();
			selectData.key = param.key;
			if (param.hasOwnProperty("value"))
			{
				selectData.value = param.value;
			}
			else
			{
				selectData.value = param.key;
			}
			_selectList.push(selectData);
		}
		
		public function getValue():Object
		{
			switch (_type)
			{
			case TYPE_NUM: 
				return _number;
			case TYPE_STRING: 
				return _str;
			case TYPE_SELECT: 
				return _selectList;
			case TYPE_LIST: 
				return _list;
			}
			return null;
		}
		
		public function get value():Object
		{
			switch (_type)
			{
			case TYPE_NUM: 
				return _number;
			case TYPE_STRING: 
				return _str;
			case TYPE_SELECT: 
				return _selectList;
			case TYPE_LIST: 
				return _list;
			}
			return null;
		}
		
		public function set value(val:Object):void
		{
			switch (_type)
			{
			case TYPE_NUM: 
				_number = val as int;
			case TYPE_STRING: 
				_str = val as String;
			case TYPE_SELECT: 
				_selectList = val as Vector.<SelectCommandData>;
			case TYPE_LIST: 
				_list = val as Vector.<PlayerVariable>;
			}
		}
		
		public function getSelectList():Vector.<SelectCommandData>
		{
			return _selectList;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{
			_type = value;
		}
		
        public function get global():Boolean 
        {
            return _global;
        }
        
        public function set global(value:Boolean):void 
        {
            _global = value;
        }
        
		public function set name(value:String):void
		{
			_name = value;
		}
		
	
	}

}