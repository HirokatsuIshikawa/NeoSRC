package converter.parse
{
	import database.master.base.StateCondition;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MessageDataParse
	{
		//処理ステータス
		public static const STATE_NONE:int = 0;
		
		public static var STATE_LIST:Array = ["交戦開始", "回避", "ダメージ", "攻撃", "撃破", "射程外"];
		public static var STATE_LIST_E:Array = ["交戦開始", "回避", "ダメージ", "攻撃", "撃破", "射程外"];
		
		public static var CONDITION_LIST:Array = ["hp", "敵", "武装", "スキル", "命中率"];
		public static var CONDITION_LIST_E:Array = ["hp", "enemy", "weapon", "skill", "hit"];
		
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
			
			var setName:String = "";
			var condition:StateCondition = null;
			
			var i:int = 0, j:int = 0, k:int = 0;
			
			//データ読み込み
			for (i = 0; i < ary.length; i++)
			{
				var lineAry:Array;
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
				
				//nameでスタート
				if (line.indexOf("name") >= 0)
				{
					
					lineAry = line.split(":");
					//キャラ名設定
					setName = lineAry[1];
					
				}
				//共用の場合
				else if (line === "default")
				{
					lineAry = line.split(":");
					//キャラ名設定
					setName = line;
				}
				//コンディション、メッセージの場合
				else
				{
					lineAry = line.split(",");
					var stateFlg:Boolean = false;
					
					for (j = 0; j < STATE_LIST.length; j++)
					{
						//コンディションがある場合はフラグを立てる
						if (lineAry[0] === STATE_LIST[j] || lineAry[0] === STATE_LIST_E[j])
						{
							condition = new StateCondition();
							
							condition.name = setName;
							stateFlg = true;
							break;
						}
					}
					
					//コンディション設定
					if (stateFlg)
					{
						for (k = 1; k < lineAry.length; k++)
						{
							var conditionLine:String = lineAry[k];
							
							if (conditionLine == null)
							{
								continue;
							}
							
							var conditionAry:Array = conditionLine.split(":")
							var conditionState:String = conditionAry[0];
							
							var conditionName:String = conditionAry[0];
							var conditionValue:String = conditionAry[1];
							
							//条件スイッチ
							switch (conditionState.toLowerCase())
							{
							//HP
							case CONDITION_LIST[0]: 
							case CONDITION_LIST_E[0]: 
								var hpValue:String = conditionValue;
								//最大最小
								var hpCondition:Array = hpValue.split("-");
								condition.hpRateMin = parseInt(hpCondition[0]);
								condition.hpRateMax = parseInt(hpCondition[1]);
								break;
							}
							
						}
					}
					//メッセージ設定
					else
					{
						var messageAry:Array = line.split(":");
						
						count++;
						data[count] = new Object();
						data[count].condition = condition;
						
						if (messageAry.length <= 1)
						{
							data[count].message = messageAry[0];
							data[count].talkName = setName;
						}
						else
						{
							
							data[count].message = messageAry[1];
							data[count].talkName = messageAry[0];
						}
						
					}
					
				}
				
			}
			
			return data;
		}
	
	}

}