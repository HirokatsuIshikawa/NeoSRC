package converter.parse
{
    import database.master.MasterBuffData;
    import database.master.base.LearnLevelData;
    import database.user.buff.CharaBuffData;
    import database.user.buff.UnitBuffData;
    import scene.main.MainController;
    
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
        
        public static const PARAM_LIST:Array = ["name", "nickName", "Cost", "exp", "money", "MaxLv", "HP", "FP", "ATK", "CAP", "TEC", "DEF", "MND", "SPD", "MOV", "terrain", "formation"];
        public static const PARAM_P_LIST:Array = ["名前", "愛称", "コスト", "経験値", "資金", "最大レベル", "ＨＰ", "ＦＰ", "攻撃", "潜在", "技術", "防御", "精神", "敏捷", "移動", "地形", "編成数"];
        public static const MAX_PARAM:Array = ["HP", "FP", "ATK", "CAP", "TEC", "DEF", "MND", "SPD", "MOV"];
        //武器データ
        public static const WEAPON_LIST:Array = [ //
        "name", "value", "atkplus", "count", "fp", "tp", "usetp",//
        "range", "hitrate", "hitplus", "avorate", "avoplus", "defrate", "defplus", //
        "crttype", "crthit", //
        "crtvalue", "attribute", "ground", "weapontype", "actiontype"//
        ];
        public static const WEAPON_P_LIST:Array = [ //
        "名前", "威力", "攻撃補正", "回数", "消費", "テンション", "消費テンション",//
        "射程", "命中率", "命中補正", "回避率", "回避補正", "防御率", "防御補正", //
        "会心タイプ", "会心率", //
        "会心値", "属性", "地形", "武器属性", "行動タイプ"//
        ];
        
        //スキルデータ
        public static const SKILL_LIST:Array = [ //
        "name", "count", "fp", "tp", "usetp",//
        "range", "terrain", //
        "heal", "supply", "state", "badstate", //
        "buff", "turn", "lv"//
        ];
        public static const SKILL_P_LIST:Array = [ //
        "名前", "回数", "消費", "テンション", "消費テンション",//
        "射程", "地形",//
        "回復", "補給", "状態回復", "状態異常", //
        "効果", "ターン", "レベル"//
        ];
        
        public static const CRITICAL_TYPE:Array = ["rate", "nodef"];
        public static const CRITICAL_P_TYPE:Array = ["倍率", "防御無視"];
        
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
                        parseData(data[count], line);
                        break;
                    case STATE_WEAPON: 
                        parseWeapon(data[count], line);
                        break;
                    case STATE_IMG: 
                        parseImg(data[count], line);
                        break;
                    case STATE_SKILL: 
                        parseSkill(data[count], line);
                        break;
                    case STATE_PASSIVE: 
                        parsePassive(data[count], line);
                        break;
                        
                    }
                    break;
                }
            }
            
            return data;
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
        
        //画像データパース
        private static function parseImg(data:Object, line:String):void
        {
            
            var i:int = 0;
            var ary:Array;
            var param:Array;
            ary = line.split(",");
            
            for (i = 0; i < ary.length; i++)
            {
                param = ary[i].split(":");
                var cmd:String = (param[0] as String).toLowerCase();
                switch (cmd)
                {
                case "charaimg": 
                case "キャラ画像": 
                    data.charaImg = param[1];
                    break;
                case "unitimg": 
                case "ユニット画像": 
                    data.unitImg = param[1];
                    break;
                }
            }
        
        }
        
        // 武装データパース
        private static function parseWeapon(data:Object, line:String):void
        {
            if (!data.hasOwnProperty("Weapon"))
            {
                data.Weapon = new Array();
            }
            
            var i:int = 0;
            var j:int = 0;
            var k:int = 0;
            var findFlg:Boolean = false;
            var ary:Array;
            var param:Array;
            var weaponData:Object = new Object();
            ary = line.split(",");
            
            // データ分解
            for (i = 0; i < ary.length; i++)
            {
                findFlg = false;
                param = ary[i].split(":");
                
                for (j = 0; j < WEAPON_LIST.length; j++)
                {
                    if (param[0] === WEAPON_LIST[j] || param[0] === WEAPON_P_LIST[j])
                    {
                        if (WEAPON_LIST[j] === "range")
                        {
                            var rangeAry:Array = param[1].split("-");
                            if (rangeAry.length > 1)
                            {
                                weaponData.minrange = rangeAry[0];
                                weaponData.maxrange = rangeAry[1];
                            }
                            else
                            {
                                weaponData.minrange = rangeAry[0];
                                weaponData.maxrange = rangeAry[0];
                            }
                        }
                        else if (WEAPON_LIST[j] === "crttype")
                        {
                            for (k = 0; k < CRITICAL_TYPE.length; k++)
                            {
                                if (CRITICAL_TYPE[k] == param[1] || CRITICAL_P_TYPE[k] == param[1])
                                {
                                    weaponData[WEAPON_LIST[j]] = CRITICAL_TYPE[k];
                                    break;
                                }
                            }
                        }
                        else
                        {
                            weaponData[WEAPON_LIST[j]] = param[1];
                            findFlg = true;
                        }
                    }
                }
            }
            
            data.Weapon.push(weaponData);
        
        }
        
        // スキルデータパース
        private static function parseSkill(data:Object, line:String):void
        {
            if (!data.hasOwnProperty("Skill"))
            {
                data.Skill = new Array();
            }
            
            var i:int = 0;
            var j:int = 0;
            var k:int = 0;
            var findFlg:Boolean = false;
            var ary:Array;
            var param:Array;
            var skillData:Object = new Object();
            ary = line.split(",");
            
            // データ分解
            for (i = 0; i < ary.length; i++)
            {
                findFlg = false;
                param = ary[i].split(":");
                
                for (j = 0; j < SKILL_LIST.length; j++)
                {
                    if (param[0] === SKILL_LIST[j] || param[0] === SKILL_P_LIST[j])
                    {
                        if (SKILL_LIST[j] === "range")
                        {
                            var rangeAry:Array = param[1].split("-");
                            if (rangeAry.length > 1)
                            {
                                skillData.minrange = rangeAry[0];
                                skillData.maxrange = rangeAry[1];
                            }
                            else
                            {
                                skillData.minrange = rangeAry[0];
                                skillData.maxrange = rangeAry[0];
                            }
                        }
                        else
                        {
                            skillData[SKILL_LIST[j]] = param[1];
                            findFlg = true;
                        }
                    }
                }
            }
            
            data.Skill.push(skillData);
        
        }
        
        // スキルデータパース
        private static function parsePassive(data:Object, line:String):void
        {
            if (!data.hasOwnProperty("Passive"))
            {
                data.Passive = new Vector.<CharaBuffData>();
            }
            
            var i:int = 0;
            var j:int = 0;
            var k:int = 0;
            var findFlg:Boolean = false;
            var ary:Array;
            var param:Array;
            var passiveData:Object = new Object();
            ary = line.split(",");
            
            //特殊能力名
            var passiveName:String = ary[0];
            
            //拾得レベルリスト
            var learnData:Vector.<LearnLevelData> = new Vector.<LearnLevelData>();
            //スキルデータ
            var learnPassive:CharaBuffData = null;
            //元バフデータ
            var baseBuff:MasterBuffData = null;
            
            //バフデータ取得
            for (i = 0; i < MainController.$.model.masterBuffData.length; i++)
            {
                //名前一致
                if (passiveName === MainController.$.model.masterBuffData[i].name)
                {
                    baseBuff = MainController.$.model.masterBuffData[i];
                    break;
                }
            }
            
            // データ分解
            for (i = 1; i < ary.length; i++)
            {
                var levelParam:Array = ary[i].split(":");
                var str:String = levelParam[0].toLowerCase();
                
                var skillLevel:int = int(str.replace("lv", ""));
                var learnLevel:int = int(levelParam[1]);
                
                var levelData:LearnLevelData = new LearnLevelData(skillLevel, learnLevel);
                learnData.push(levelData);
            }
            
            learnPassive = new CharaBuffData(baseBuff, learnData);
            data.Passive.push(learnPassive);
        
        }
    
    }
}