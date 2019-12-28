package database.user
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class FaceData
	{
		private var _name:String = null;
		private var _nickName:String = null;
		/**画像URL*/
		private var _imgUrl:String = null;
		/**基本画像データ*/
		private var _basicList:Vector.<String> = null;
		/**画像リスト*/
		private var _imgList:Vector.<ImgData> = null;
		
		private var _addPoint:Point = null;
		
		private var _defaultType:String = null;
		
		public function FaceData(data:Object = null)
		{
			var i:int = 0;
			_imgList = new Vector.<ImgData>;
			_basicList = new Vector.<String>(String);
			
			_name = data.name;
			_nickName = data.nickname;
			
			
			_imgUrl = data.imgUrl;
			
			if (data.hasOwnProperty("add_x") && data.hasOwnProperty("add_y"))
			{
				_addPoint = new Point(data.add_x, data.add_y);
			}
			else if (data.hasOwnProperty("add_x"))
			{
				_addPoint = new Point(data.add_x, 0);
			}
			else if (data.hasOwnProperty("add_y"))
			{
				_addPoint = new Point(0, data.add_y);
			}
			else
			{
				_addPoint = new Point(0, 0);
			}
			
			if (data != null)
			{
				_defaultType = data.defaultType;
				for (i = 0; i < data.basicList.length; i++)
				{
					_basicList[i] = data.basicList[i];
				}
				
				_imgUrl = data.imgUrl;
				for (i = 0; i < data.imgList.length; i++)
				{
					if (data.hasOwnProperty("defaultType"))
					{
						_imgList[i] = new ImgData(data.imgList[i], data.defaultType);
					}
					else
					{
						_imgList[i] = new ImgData(data.imgList[i]);
					}
				}
			}
			else
			{
				_imgUrl = "";
			}
		}
		
		public function getFileName(name:String):String
		{
			var file:String = null;
			for (var i:int = 0; i < _imgList.length; i++)
			{
				if (_imgList[i].name === name)
				{
					file = _imgList[i].file;
					break;
				}
			}
			return file;
		}
		
		public function get imgUrl():String
		{
			return _imgUrl;
		}
		
		public function set imgUrl(value:String):void
		{
			_imgUrl = value;
		}
		
		public function get basicList():Vector.<String>
		{
			return _basicList;
		}
		
		public function get imgList():Vector.<ImgData>
		{
			return _imgList;
		}
		
		public function set imgList(value:Vector.<ImgData>):void
		{
			_imgList = value;
		}
		
		public function get addPoint():Point
		{
			return _addPoint;
		}
		
		public function get defaultType():String 
		{
			return _defaultType;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get nickName():String 
		{
			return _nickName;
		}
		
	
	}

}