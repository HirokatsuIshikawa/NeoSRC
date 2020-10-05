package database.master
{
	import common.CommonDef;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MasterCommanderSkillData
	{
		public static const SKILL_TARGET_ALLY:int = 1;
		public static const SKILL_TARGET_ENEMY:int = 2;
		public static const SKILL_TARGET_ALL:int = 9;
		
		public static const SKILL_PARAM_LIST:Array = [ //
		"name", "target", "toall", //
		"usesp", "count", //
		"heal", "supply", //
		"state", "badstate", //
		"buff", "turn", "level",//
		"terrain" //
		];
		public static const SKILL_PARAM_P_LIST:Array = [ //
		"名前", "対象", "全体", //
		"消費", "回数", //
		"回復", "補給", //
		"状態回復", "状態異常", //
		"効果", "ターン", "レベル", //
		"地形"];
		public static const SKILL_DEFAULT_VALUE_LIST:Array = [ //
		"スキル", SKILL_TARGET_ALLY,0,//名前、ターゲット、全体化
		0, 0,  //消費、回数
		0, 0, 0, 0, //回復、補給、状態回復、状態異常
		null, 0, 1,//バフ効果、ターン、レベル
		"BBBB"//
		];
		
		/**識別用ID*/
		private var _id:int = 0;
		
		public function get id():int  { return _id; }
		
		/**スキル名*/
		private var _name:String = null;
		
		public function get name():String  { return _name; }
		
		/**地形*/
		private var _terrain:Vector.<int> = null;
		
		public function get terrain():Vector.<int>  { return _terrain; }
		
		//使用回数
		public function get useCount():int
		{
			return _useCount;
		}
		
		//最大回数
		public function get maxCount():int
		{
			return _maxCount;
		}
		
		//使用回数
		public function set useCount(value:int):void
		{
			_useCount = value;
		}
		
		//目標
		public function get target():int
		{
			return _target;
		}
		
		//回復値
		public function get heal():int
		{
			return _heal;
		}
		
		//補給値
		public function get supply():int
		{
			return _supply;
		}
		
		//TPセット
		public function get buff():String
		{
			return _buff;
		}
		
		public function get turn():int
		{
			return _turn;
		}
		
		public function get level():int 
		{
			return _level;
		}

        public function get useSp():int 
        {
            return _useSp;
        }
        
        public function get toAll():int 
        {
            return _toAll;
        }
        
        public function set useSp(value:int):void 
        {
            _useSp = value;
        }
		
		/**使用回数*/
		private var _useCount:int = 0;
		private var _maxCount:int = 0;
		/**消費SP*/
		private var _useSp:int = 0;

		/**回復*/
		private var _heal:int = 0;
		/**補給*/
		private var _supply:int = 0;
		/**状態回復*/
		private var _state:int = 0;
		/**状態異常*/
		private var _badstate:int = 0;
		
		private var _target:int = 0;
        private var _toAll:int = 0;
		
		private var _buff:String = null;
		private var _turn:int = 0;
		private var _level:int = 0;
		
		public function MasterCommanderSkillData(data:Object)
		{
			var i:int = 0;
			// 空データを基本値で埋める
			for (i = 0; i < SKILL_PARAM_LIST.length; i++)
			{
				if (!data.hasOwnProperty(SKILL_PARAM_LIST[i]))
				{
					data[SKILL_PARAM_LIST[i]] = SKILL_DEFAULT_VALUE_LIST[i];
				}
			}
			
			// データ設定
			_name = data.name;
			_target = data.target;
			_useSp = data.usesp;
			_useCount = data.count;
			_maxCount = data.count;
			_heal = data.heal;
			_supply = data.supply;
			_state = data.state;
			_badstate = data.badstate;
			_buff = data.buff;
			_turn = data.turn;
			_level = data.level - 1;
            _toAll = data.toall;
			
			_terrain = new Vector.<int>;
			var str:String = data.terrain;
			str = str.toUpperCase();
			for (i = 0; i < 4; i++)
			{
				_terrain[i] = CommonDef.terrainChanger(str.charAt(i));
			}
		}
	}
}