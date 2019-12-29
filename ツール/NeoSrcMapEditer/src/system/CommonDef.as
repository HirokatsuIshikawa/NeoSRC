package system
{
	
	/**
	 * ...
	 * @author
	 */
	public class CommonDef
	{
		public static const WINDOW_W:int = 1280;
		public static const WINDOW_H:int = 800;
		
		public static function formatZero(n:Number, keta:uint):String
		{
			return ("0000000000000000000000000" + n.toString()).substr(-keta);
		}
		
		//親ファイルパス取得
		public static function getParentLocalPath(type:String, path:String):String
		{
			var start:int = path.lastIndexOf("\\" + type + "\\");
			var end:int = path.lastIndexOf("\\");
			
			if (end < 0 || start < 0)
			{
				return path;
			}
			else
			{
				return path.substr(start + 1, end - start - 1);
			}
		}
		
		//親ファイルパス取得
		public static function getParentPath(type:String, path:String):String
		{
			var start:int = path.lastIndexOf("\\");
			
			if (start < 0)
			{
				return path;
			}
			else
			{
				return path.substr(0, start);
			}
		}
		
		//親ファイルパス取得
		public static function getFileName(path:String):String
		{
			var num:int = path.lastIndexOf("\\");
			if (num < 0)
			{
				return path;
			}
			else
			{
				return path.substr(num + 1, path.length);
			}
		}
		
		//ファイル名取得
		public static function getFileKey(path:String):String
		{
			var start:int = path.lastIndexOf("\\");
			var end:int = path.indexOf(".");
			//どちらも入っていなければ全部返す
			if (start < 0 && end < 0)
			{
				return path;
			}
			//フォルダ内でなければ拡張子を除去
			else if (start < 0)
			{
				return path.substr(0, end);
			}
			//拡張子なければ最後のフォルダ名
			else if (end < 0)
			{
				return path.substr(start, path.length);
			}
			//ファイル名のみ
			else
			{
				return path.substr(start, end);
			}
		}
		
		/**オブジェクト長さ取得*/
		public static function objectLength(data:Object):Number
		{
			var i:Number = 0;
			for (var prop:Object in data)
			{
				if (typeof(data[prop]) != "function")
					i++;
			}
			return i;
		};
        
        /** リストデータ一斉廃棄 */
        public static function disposeList(array:Object):void
        {
            for each (var object:Object in array)
            {
                if (object is Array || (object.hasOwnProperty("length") && object[0].hasOwnProperty("dispose")))
                {
                    //再帰的に実行
                    disposeList(object);
                    continue;
                }
                
                if (object != null && object.hasOwnProperty("dispose"))
                {
                    object.dispose();
                }
            }
        }
    }
}