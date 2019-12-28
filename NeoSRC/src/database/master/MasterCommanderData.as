package database.master
{
	import database.master.base.MasterParamData;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MasterCommanderData extends MasterParamData
	{
		
		public static const INPUT_TYPE:Array = ["HP", "FP", "攻撃", "防御", "技術", "敏捷", "潜在", "精神", "移動", "命中", "回避","策略", "回復"];
		public static const DATA_TYPE:Array = ["HP", "FP", "ATK", "DEF", "TEC", "SPD", "CAP", "MND", "MOV", "HIT", "EVA", "Point", "Heal"];
		/**識別用ID*/
		private var _id:int = 0;
		
		public function get id():int  { return _id; }
		
		/**キャラ名*/
		private var _name:String = null;
		
		public function get name():String  { return _name; }
		
		/**キャラ表示名*/
		private var _nickName:String = null;
		
		public function get nickName():String  { return _nickName; }
		
		/**策略ポイント*/
		private var _Point:int = 0;
		private var _Point_Max:int = 0;
		private var _Heal:int = 0;
		private var _Heal_Max:int = 0;
		
		/**命中*/
		private var _HIT:int = 0;
		private var _HIT_Max:int = 0;
		/**回避*/
		private var _EVA:int = 0;
		private var _EVA_Max:int = 0;
		
		private var _charaImgName:String = null;
		
		public function get charaImgName():String
		{
			return _charaImgName;
		}
		
		public function MasterCommanderData(data:Object)
		{
			
			_name = data.name;
			_nickName = data.nickName;
			_charaImgName = data.charaImg;
			
			//各種ステータス
			for (i = 0; i < DATA_TYPE.length; i++)
			{
				// 最小値、値がない場合はデフォルト値
				if (data.hasOwnProperty(DATA_TYPE[i]))
				{
					this["_" + DATA_TYPE[i]] = data[DATA_TYPE[i]];
				}
				else
				{
					this["_" + DATA_TYPE[i]] = 0;
				}
				// 最大値、値がない場合は最低値と同値
				if (data.hasOwnProperty(DATA_TYPE[i] + "_Max"))
				{
					this["_" + DATA_TYPE[i] + "_Max"] = data[DATA_TYPE[i] + "_Max"];
				}
				else
				{
					this["_" + DATA_TYPE[i] + "_Max"] = this["_" + DATA_TYPE[i]];
				}
			}
			if (data.hasOwnProperty("special"))
			{
				
			}
		
		}
	
	}

}