package converter.parse
{
    import converter.parse.common.ParseCommon;
    
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
        public static const STATE_UNIT:int = 4;
        
        public static const PARAM_LIST:Array = ["name", "nickName", "MaxLv", "stratagem", "addition", "HP", "FP", "ATK", "CAP", "TEC", "DEF", "MND", "SPD", "MOV", "HIT", "EVA", "Point", "Heal", "Supply"];
        public static const PARAM_P_LIST:Array = ["名前", "愛称", "最大レベル", "計略", "回復", "ＨＰ", "ＦＰ", "攻撃", "潜在", "技術", "防御", "精神", "敏捷", "移動", "命中", "回避","策略", "回復", "補給"];
        public static const MAX_PARAM:Array = ["策略", "回復", "HP", "FP", "ATK", "CAP", "TEC", "DEF", "MND", "SPD", "MOV", "HIT", "EVA", "Point", "Heal", "Supply"];
        
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
                case "skill": 
                case "スキル": 
                    state = STATE_SPECIAL;
                    break;
                case "formation": 
                case "陣形": 
                    state = STATE_FORMATION;
                    break;
                case "unit":
                case "ユニット":
                    state = STATE_UNIT;
                    break;
                    
                default: 
                    switch (state)
                    {
                    case STATE_DATA: 
                        ParseCommon.parseData(data[count], line);
                        break;
                    case STATE_IMG: 
                        ParseCommon.parseImg(data[count], line);
                        break;
                    case STATE_SPECIAL:
                        ParseCommon.parseSkill(data[count], line);
                        break;
                    case STATE_FORMATION:
                        break;
                    case STATE_UNIT:
                        break;
                    }
                    break;
                }
            }
            return data;
        }
    }
}