package database.user
{
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class ImgData
	{
		
		private var _name:String = "";
		private var _file:String = "";
		private var _type:String = "";
		private var _layer:int = 0;
		
		public function ImgData(data:Object, defaultType:String = "stand")
		{
			_layer = data.layer;
			_name = data.name;
			_file = data.file;
			if (data.hasOwnProperty("type"))
			{
				_type = data.type;
			}
			else
			{
				_type = defaultType;
			}
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get file():String
		{
			return _file;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function get layer():int 
		{
			return _layer;
		}
	
	}

}