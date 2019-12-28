package converter.parse
{
	
	/**
	 * ...
	 * @author ...
	 */
	public class CommanderDataParse
	{
		//処理ステータス
		public static const STATE_NONE:int = 0;
		
		
		public static function parseData(str:String):Array
		{
			var count:int = -1;
			// 状態
			var state:int = STATE_NONE;
			
			// 変換データ
			var data:Array = new Array();
			// ※gは繰り返しフラグ
			// 改行
			str = str.replace(/\r\n/g, "\n");
			// タブ
			str = str.replace(/\t/g, "");
			// 半角
			str = str.replace(/ /g, "");
			var ary:Array = str.split("\n");
			
			//データ読み込み
			for (var i:int = 0; i < ary.length; i++)
			{
				//ライン読み込み
				var line:String = ary[i];
				if (line.length <= 0)
				{
					continue;
				}
				if (line.indexOf("//") == 0)
				{
					continue;
				}
				
				count++;
				data[count] = new Object();
				
				
				
				
				
				
			}
		
		}
	
	}

}