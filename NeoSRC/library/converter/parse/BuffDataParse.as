package converter.parse
{
	import database.master.base.BaseParam;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BuffDataParse
	{
		//別名指定
		public static const PARAM_ALIAS:String = "alias";
		public static const PARAM_ALIAS_JP:String = "別名";
		
		//処理ステータス
		public static const STATE_NONE:int = 0;
		
		public static function parseBuffData(str:String):Array
		{
			var count:int = -1;
			var subCount:int = 0;
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
				
				//レベル指定がある
				if (line.indexOf("Lv") >= 0)
				{
					//データ分解
					parseData(data[count], line, subCount);
					subCount++;
				}
				//新データ追加
				else
				{
					count++;
					subCount = 0;
					data[count] = new Object();
					data[count]["name"] = line;
				}
				
			}
			return data;
		}
		
		// 基本データパース
		private static function parseData(data:Object, line:String, subCount:int):void
		{
			var i:int = 0;
			var j:int = 0;
			var ary:Array = line.split(",");
			
			data[subCount] = new Object;
			
			//パラメーター
			for (i = 1; i < ary.length; i++)
			{
				
				var stateAry:Array = ary[i].split(":");
				//パラメータ設定
				
				//別名設定
				if (stateAry[0] === PARAM_ALIAS || stateAry[0] === PARAM_ALIAS_JP)
				{
					data[subCount][PARAM_ALIAS] = stateAry[1];
				}
				else
				{
					var findFlg:Boolean = false;
					//パラメータ設定
					for (j = 0; j < BaseParam.STATUS_STR.length; j++)
					{
						//パラメータ一致で対応ステータス設定
						if (stateAry[0] === BaseParam.STATUS_STR[j] || stateAry[0] === BaseParam.STATUS_STR_JP[j])
						{
							data[subCount][BaseParam.STATUS_STR[j]] = stateAry[1];
							findFlg = true;
							break;
						}
					}
					//未発見の場合、別のパラメーター設定
					if (!findFlg)
					{
						//パラメータ設定
						for (j = 0; j < BaseParam.ADD_STR.length; j++)
						{
							//パラメータ一致で対応ステータス設定
							if (stateAry[0] === BaseParam.ADD_STR[j] || stateAry[0] === BaseParam.ADD_STR_JP[j])
							{
								data[subCount][BaseParam.ADD_STR[j]] = stateAry[1];
								break;
							}
						}
					}
				}
			}
		}
	
	}

}