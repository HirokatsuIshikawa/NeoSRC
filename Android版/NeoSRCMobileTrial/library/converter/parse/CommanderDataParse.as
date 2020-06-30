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
        public static const STATE_DATA:int = 1;
        public static const STATE_SPECIAL:int = 2;
        public static const STATE_IMG:int = 3;
        public static const STATE_FORMATION:int = 3;
        
        
        public static const PARAM_LIST:Array = ["name", "nickName", "MaxLv", "stratagem", "addition", "HP", "FP", "ATK", "CAP", "TEC", "DEF", "MND", "SPD", "MOV"];
        public static const PARAM_P_LIST:Array = ["名前", "愛称", "最大レベル", "計略","回復","ＨＰ", "ＦＰ", "攻撃", "潜在", "技術", "防御", "精神", "敏捷", "移動"];
        public static const MAX_PARAM:Array = ["策略", "回復", "HP", "FP", "ATK", "CAP", "TEC", "DEF", "MND", "SPD", "MOV"];
        
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
                
                switch (line)
                {
                case "DATA": 
                case "基本データ": 
                    count++;
                    data[count] = new Object();
                    state = STATE_DATA;
                    break;
                case "IMG":
                case "画像":
                    state = STATE_IMG;
                    break;
                case "special":
                case "スペシャル":
                    state = STATE_SPECIAL;
                    break;
                case "formation":
                case "フォーメーション":
                    state = STATE_FORMATION;
                    break;
                default: 
                    switch (state)
                    {
                    case STATE_DATA: 
                        parseData(data[count], line);
                        break;
                    case STATE_IMG: 
                        parseImg(data[count], line);
                        break;
                    }
                    break;
                }
                
            }
        
        }
        
        
        
        // 基本データパース
        private static function parseData(data:Object, line:String):void
        {
            var i:int = 0;
            var j:int = 0;
            var ary:Array = line.split(",");
            
            for (i = 0; i < ary.length; i++)
            {
                var baseParamStr:String = ary[i];
                var param:Array = baseParamStr.split(":");
                var command:String = param[0];
                var paramNum:Array = (String)(param[1]).split("-");
                var setKey:String = null;
                var growthTypeAry:Array = baseParamStr.split("/");
                var growthType:String = null;
                var maxFlg:Boolean = false;
                
                if (growthTypeAry.length > 0)
                {
                    growthType = growthTypeAry[1];
                }
                
                // セットパラメータ設定
                for (j = 0; j < PARAM_LIST.length; j++)
                {
                    if (command.toLocaleLowerCase() === PARAM_LIST[j].toLocaleLowerCase() || command === PARAM_P_LIST[j])
                    {
                        setKey = PARAM_LIST[j];
                        break;
                    }
                }
                
                // 最大値が指定できるパラメータか判別
                for (j = 0; j < MAX_PARAM.length; j++)
                {
                    if (setKey === MAX_PARAM[j])
                    {
                        maxFlg = true;
                        break;
                    }
                }
                
                setParam(data, setKey, maxFlg, paramNum, growthType);
            }
        }
        
        
        private static function setParam(data:Object, setKey:String, maxFlg:Boolean, paramNum:Array, growthType:String):void
        {
            
            // 成長タイプ設定
            if (growthType != null && maxFlg)
            {
                data[setKey + "_Growth"] = growthType;
            }
            // MAX指定ならば最少と最大をセット
            if (paramNum.length == 2)
            {
                if (isNaN(paramNum[0]))
                {
                    data[setKey] = paramNum[0];
                    if (maxFlg)
                    {
                        data[setKey + "_Max"] = paramNum[1];
                    }
                }
                else
                {
                    data[setKey] = Number(paramNum[0]);
                    
                    if (maxFlg)
                    {
                        data[setKey + "_Max"] = Number(paramNum[1]);
                    }
                }
            }
            // 単品ならば同一の値を入れる
            else if (paramNum.length == 1)
            {
                if (isNaN(paramNum[0]))
                {
                    data[setKey] = paramNum[0];
                    if (maxFlg)
                    {
                        data[setKey + "_Max"] = paramNum[0];
                    }
                }
                else
                {
                    data[setKey] = Number(paramNum[0]);
                    if (maxFlg)
                    {
                        data[setKey + "_Max"] = Number(paramNum[0]);
                    }
                }
            }
        }
    
    }

}