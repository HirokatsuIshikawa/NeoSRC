package database.master
{
    import database.master.base.MasterParamData;
    import starling.utils.MathUtil;
    
    /**
     * ...
     * @author ...
     */
    public class MasterCommanderData extends MasterParamData
    {
        
        public static const INPUT_TYPE:Array = ["HP", "FP", "攻撃", "防御", "技術", "敏捷", "潜在", "精神", "移動"];
        public static const DATA_TYPE:Array = ["HP", "FP", "ATK", "DEF", "TEC", "SPD", "CAP", "MND", "MOV"];
        
        public static const ADD_INPUT_TYPE:Array = ["命中", "回避", "策略", "回復", "補給"];
        public static const ADD_DATA_TYPE:Array = ["HIT", "EVA", "Point", "Heal", "Supply"];
        
        /**識別用ID*/
        private var _id:int = 0;
        
        public function get id():int  { return _id; }
        /**Lv*/
        private var _MaxLv:int = 0;
        
        public function get MaxLv():int  { return _MaxLv; }
        /**キャラ名*/
        private var _name:String = null;
        
        public function get name():String  { return _name; }
        
        /**キャラ表示名*/
        private var _nickName:String = null;
        
        public function get nickName():String  { return _nickName; }
        
        /**策略ポイント*/
        public var Point_Max:int = 0;
        public var Point_Min:int = 0;
        public var Heal_Max:int = 0;
        public var Heal_Min:int = 0;
        public var Supply_Max:int = 0;
        public var Supply_Min:int = 0;
        
        /**命中*/
        public var HIT_Max:int = 0;
        public var HIT_Min:int = 0;
        /**回避*/
        public var EVA_Max:int = 0;
        public var EVA_Min:int = 0;
        
        /**スキルデータ*/
        private var _skillDataList:Vector.<MasterSkillData> = null;
        
        private var _charaImgName:String = null;
        
        public function get charaImgName():String
        {
            return _charaImgName;
        }
        
        public function MasterCommanderData(data:Object)
        {
            var i:int = 0;
            _name = data.name;
            _nickName = data.nickName;
            _charaImgName = data.charaImg;
            _MaxLv = MathUtil.max(data.MaxLv, 1);
            
            //各種ステータス
            for (i = 0; i < DATA_TYPE.length; i++)
            {
                // 最小値、値がない場合はデフォルト値
                if (data.hasOwnProperty(DATA_TYPE[i]))
                {
                    this.minParam[DATA_TYPE[i]] = data[DATA_TYPE[i]];
                }
                else
                {
                    this.minParam[DATA_TYPE[i]] = 0;
                }
                // 最大値、値がない場合は最低値と同値
                if (data.hasOwnProperty(DATA_TYPE[i] + "_Max"))
                {
                    this.maxParam[DATA_TYPE[i]] = data[DATA_TYPE[i] + "_Max"];
                }
                else
                {
                    this.maxParam[DATA_TYPE[i]] = this.minParam[DATA_TYPE[i]];
                }
            }
            //軍師専用パラメータ
            for (i = 0; i < ADD_DATA_TYPE.length; i++)
            {
                // 最小値、値がない場合はデフォルト値
                if (data.hasOwnProperty(ADD_DATA_TYPE[i]))
                {
                    this[ADD_DATA_TYPE[i] + "_Min"] = data[ADD_DATA_TYPE[i]];
                }
                else
                {
                    this[ADD_DATA_TYPE[i] + "_Min"] = 0;
                }
                // 最大値、値がない場合は最低値と同値
                if (data.hasOwnProperty(ADD_DATA_TYPE[i] + "_Max"))
                {
                    this[ADD_DATA_TYPE[i] + "_Max"] = data[ADD_DATA_TYPE[i] + "_Max"];
                }
                else
                {
                    this[ADD_DATA_TYPE[i] + "_Max"] = this[ADD_DATA_TYPE[i] + "_Min"];
                }
            }
            
            _skillDataList = new Vector.<database.master.MasterSkillData>();
            
            // スキルデータセット
            if (data.hasOwnProperty("Skill"))
            {
                for (i = 0; i < data.Skill.length; i++)
                {
                    var skillData:MasterSkillData = new MasterSkillData(data.Skill[i]);
                    _skillDataList.push(skillData);
                }
            }
        }
    
    }

}