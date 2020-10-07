package converter.parse
{
    import converter.parse.common.ParseCommon;
    import database.master.MasterBuffData;
    import database.master.base.LearnLevelData;
    import database.user.buff.CharaBuffData;
    import database.user.buff.UnitBuffData;
    import main.MainController;
    
    /**
     * ...
     * @author ishikawa
     */
    public class CharaDataParse
    {
        
        public static const STATE_NONE:int = 0;
        public static const STATE_DATA:int = 1;
        public static const STATE_WEAPON:int = 2;
        public static const STATE_IMG:int = 3;
        public static const STATE_SKILL:int = 4;
        public static const STATE_PASSIVE:int = 5;
        
        public static function parseCharaData(str:String):Array
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
            
            for (var i:int = 0; i < ary.length; i++)
            {
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
                case "WEAPON": 
                case "武器": 
                case "武装": 
                    state = STATE_WEAPON;
                    break;
                case "SKILL": 
                case "スキル": 
                    state = STATE_SKILL;
                    break;
                case "IMG": 
                case "画像": 
                    state = STATE_IMG;
                    break;
                case "特殊能力": 
                case "PASSIVE": 
                    state = STATE_PASSIVE;
                    break;
                default: 
                    switch (state)
                    {
                    case STATE_DATA: 
                        ParseCommon.parseData(data[count], line);
                        break;
                    case STATE_WEAPON: 
                        ParseCommon.parseWeapon(data[count], line);
                        break;
                    case STATE_IMG: 
                        ParseCommon.parseImg(data[count], line);
                        break;
                    case STATE_SKILL: 
                        ParseCommon.parseSkill(data[count], line);
                        break;
                    case STATE_PASSIVE: 
                        ParseCommon.parsePassive(data[count], line);
                        break;
                        
                    }
                    break;
                }
            }
            return data;
        }
    }
}