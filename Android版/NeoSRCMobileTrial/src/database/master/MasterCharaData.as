package database.master
{
	import common.CommonDef;
	import database.master.base.MasterParamData;
	import database.user.buff.CharaBuffData;
	import database.user.FaceData;
	import database.user.buff.UnitBuffData;
	import starling.utils.MathUtil;
	
	/**
	 * ...
	 * @author
	 */
	public class MasterCharaData extends MasterParamData
	{
		/**識別用ID*/
		private var _id:int = 0;
		
		public function get id():int  { return _id; }
		
		/**キャラ名*/
		private var _name:String = null;
		
		public function get name():String  { return _name; }
		
		/**キャラ表示名*/
		private var _nickName:String = null;
		
		public function get nickName():String  { return _nickName; }
		
		/**コスト*/
		private var _Cost:int = 0;
		
		public function get Cost():int  { return _Cost; }
		
		/**Lv*/
		private var _MaxLv:int = 0;
		
		public function get MaxLv():int  { return _MaxLv; }
		
		
		/**経験値*/
		private var _exp:int = 0;
		
		/**資金*/
		private var _money:int = 0;
		
		/**武装データ*/
		private var _weaponDataList:Vector.<MasterWeaponData> = null;
		/**スキルデータ*/
		private var _skillDataList:Vector.<MasterSkillData> = null;
		
		public function get weaponDataList():Vector.<MasterWeaponData>  { return _weaponDataList; }
		
		private var _charaImgName:String = null;
		private var _unitsImgName:String = null;
		

		public function get charaImgName():String 
		{
			return _charaImgName;
		}
		
		public function get unitsImgName():String 
		{
			return _unitsImgName;
		}
		
		public function get exp():int 
		{
			return _exp;
		}
		
		public function get money():int 
		{
			return _money;
		}
		
		public function get passiveList():Vector.<CharaBuffData> 
		{
			return _passiveList;
		}
		
		public function get skillDataList():Vector.<MasterSkillData> 
		{
			return _skillDataList;
		}
		
		
		public static const INPUT_TYPE:Array = ["HP", "FP", "攻撃", "防御", "技術", "敏捷", "潜在", "精神", "移動"];
		public static const DATA_TYPE:Array = ["HP", "FP", "ATK", "DEF", "TEC", "SPD", "CAP", "MND", "MOV"];
		public static const DATA_INIT_NUM:Array = [15, 15, 15, 15, 15, 15, 15, 15, 4];
		
		public static const PARA_HP:int = 0;
		public static const PARA_FP:int = 1;
		
		public static const PARA_ATK:int = 2;
		public static const PARA_DEF:int = 3;
		public static const PARA_TEC:int = 4;
		public static const PARA_SPD:int = 5;
		public static const PARA_CAP:int = 6;
		public static const PARA_MND:int = 7;
		public static const PARA_MOV:int = 8;
		
		public static const TERRAIN_SKY:int = 0;
		public static const TERRAIN_GROUND:int = 1;
		public static const TERRAIN_WATER:int = 2;
		public static const TERRAIN_SPAGE:int = 3;
		
		private var _passiveList:Vector.<CharaBuffData> = null;
		
		/**コンストラクタ*/
		public function MasterCharaData(data:Object)
		{
			var i:int = 0;
			
			_passiveList = new Vector.<CharaBuffData>();
			_weaponDataList = new Vector.<MasterWeaponData>;
			_skillDataList = new Vector.<MasterSkillData>;
			_id = data.id;
			_name = data.name;
			_nickName = data.nickName;
			_MaxLv = MathUtil.max(data.MaxLv, 1);
			_Cost = data.Cost;
			
			_passiveList = data.Passive;
			
			
			_charaImgName = data.charaImg;
			_unitsImgName = data.unitImg;
			
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
					this.minParam[DATA_TYPE[i]] = DATA_INIT_NUM[i];
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

			
			//経験値対応
			if (data.hasOwnProperty("exp"))
			{
				_exp = data.exp;
			}
			//資金
			if (data.hasOwnProperty("money"))
			{
				_money = data.money;
			}
			
			// 地形対応
			if (!data.hasOwnProperty("terrain"))
			{
				data.terrain = "BBBB";
			}
			_terrain = new Vector.<int>;
			var str:String = data.terrain;
			str = str.toUpperCase();
			for (i = 0; i < 4; i++)
			{
				_terrain[i] = CommonDef.terrainChanger(str.charAt(i));
			}
			
			// 武器データセット
			if (data.hasOwnProperty("Weapon"))
			{
				for (i = 0; i < data.Weapon.length; i++)
				{
					var weaponData:MasterWeaponData = new MasterWeaponData(data.Weapon[i]);
					_weaponDataList.push(weaponData);
				}
				
				_weaponDataList.sort(weaponSort);
			}
			
			
			
			// スキルデータセット
			if (data.hasOwnProperty("Skill"))
			{
				for (i = 0; i < data.Skill.length; i++)
				{
					var skillData:MasterSkillData = new MasterSkillData(data.Skill[i]);
					_skillDataList.push(skillData);
				}
				
				//_skillDataList.sort(weaponSort);
			}
		
			
			var st:int = 0;
		}
		
		public static function weaponSort(data1:MasterWeaponData, data2:MasterWeaponData):Number
		{
			return data1.value - data2.value;
		}
		
		
	
	}
}