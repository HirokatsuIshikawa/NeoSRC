package converter.parse
{
	import database.master.base.MessageCondition;
    import scene.main.MainController;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MessageDataParse
	{
		//処理ステータス
		public static const STATE_NONE:int = 0;
		
        public static const MSG_START:int = 0;
        public static const MSG_AVO:int = 1; //回避
        public static const MSG_DAMAGE:int = 2;
        public static const MSG_ATTACK:int = 3;
        public static const MSG_DESTROY:int = 4; //撃破
        public static const MSG_OUTRANGE:int = 5;
        public static const MSG_SKILL:int = 6;
        
        public static const MSG_SPECIAL:int = 7;
        
        
		public static var STATE_LIST:Array = ["交戦開始", "回避", "ダメージ", "攻撃", "破壊", "射程外", "スキル", "スペシャル"];
		public static var STATE_LIST_E:Array = ["交戦開始", "回避", "ダメージ", "攻撃", "破壊", "射程外", "スキル", "スペシャル"];
		
		public static var CONDITION_LIST:Array = ["hp", "敵", "武装", "スキル名", "命中率", "スペシャル名"];
		public static var CONDITION_LIST_E:Array = ["hp", "enemy", "weapon", "skillName", "hit", "specialName"];
		
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
			var condition:MessageCondition = null;
			
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
					count = 0;
					lineAry = line.split(":");
					//キャラ名設定
					setName = lineAry[1];
                    if (data[setName] == null)
                    {
					    data[setName] = new Array();
                    }
				}
				//共用の場合
				else if (line === "default")
				{
					count = 0;
					lineAry = line.split(":");
					//キャラ名設定
					setName = line;
                    if (data[setName] == null)
                    {
					    data[setName] = new Array();
                    }
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
							condition = new MessageCondition();
							
							condition.state = STATE_LIST[j];
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
							//武装
							case CONDITION_LIST[2]:
							case CONDITION_LIST_E[2]:
								condition.weaponName = conditionValue;
								break;
                            case CONDITION_LIST[3]:
                            case CONDITION_LIST_E[3]:
                                condition.skillName = conditionValue;
                                break;                           
                            case CONDITION_LIST[5]:
                            case CONDITION_LIST_E[5]:
                                condition.specialName = conditionValue;
                                break;
							}
							
						}
					}
					//メッセージ設定
					else
					{
						var messageAry:Array = line.split(";");
						
                        if (setName == null || setName.length <= 0)
                        {
                            MainController.$.view.alertMessage("メッセージのnameが設定されていません", "メッセージデータエラー");
                        }
                        
						data[setName][count] = new Object();
						data[setName][count].condition = condition;
						data[setName][count].condition.message = new Vector.<String>();
						
						for (k = 0; k < messageAry.length; k++ )
						{
							data[setName][count].condition.message.push(messageAry[k]);						
						}
						count++;
					}
				}
			}
			
			return data;
		}
	
	}

}