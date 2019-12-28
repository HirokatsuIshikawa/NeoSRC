package database.master
{
	import common.CommonDef;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MasterSkillData
	{
		public static const SKILL_TARGET_ALLY:int = 1;
		public static const SKILL_TARGET_ENEMY:int = 2;
		public static const SKILL_TARGET_ALL:int = 9;
		
		public static const SKILL_PARAM_LIST:Array = [ //
		"name", "target",//
		"minrange", "maxrange", //
		"fp", "count", //
		"tp", "usetp", //
		"heal", "supply", //
		"state", "badstate", //
		"buff", "turn", "level",//
		//"buffparam", "buffvalue", //
		//"debuffparam", "debuffparam", //
		"terrain" //
		];
		public static const SKILL_PARAM_P_LIST:Array = [ //
		"名前", "対象",//
		"最小射程", "最大射程",  //
		"消費", "回数", //
		"テンション", "消費テンション", //
		"回復", "補給", //
		"状態回復", "状態異常", //
		"効果", "ターン", "レベル", //
		//"強化パラメーター", "強化値", // 
		//"弱体パラメーター", "弱体値", //
		"地形"];
		public static const SKILL_DEFAULT_VALUE_LIST:Array = [ //
		"スキル", SKILL_TARGET_ALLY,//名前、ターゲット
		0, 1,  	// 射程
		0, 0, //消費、回数
		0, 0, //テンション
		0, 0, 0, 0, //回復、補給、状態回復、状態異常
		null, 0, 1,//バフ効果、ターン、レベル
		//0, 0, //強化
		//0, 0, //弱体
		"BBBB"//
		];
		
		/**識別用ID*/
		private var _id:int = 0;
		
		public function get id():int  { return _id; }
		
		/**スキル名*/
		private var _name:String = null;
		
		public function get name():String  { return _name; }
		
		/**最低射程*/
		private var _minRange:int = 0;
		
		public function get minRange():int  { return _minRange; }
		
		/**最大射程*/
		private var _maxRange:int = 0;
		
		public function get maxRange():int  { return _maxRange; }
		
		/**地形*/
		private var _terrain:Vector.<int> = null;
		
		public function get terrain():Vector.<int>  { return _terrain; }
		
		//使用回数
		public function get useCount():int
		{
			return _useCount;
		}
		
		//消費FP
		public function get useFp():int
		{
			return _useFp;
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
		
		//使用可能TP
		public function get enableTp():int
		{
			return _enableTp;
		}
		
		//消費TP
		public function get useTp():int
		{
			return _useTp;
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
		
		public function set useTp(value:int):void
		{
			_useTp = value;
		}
		
		/**使用回数*/
		private var _useCount:int = 0;
		private var _maxCount:int = 0;
		/**消費EN*/
		private var _useFp:int = 0;
		/**TP*/
		private var _enableTp:int = 0;
		/**消費TP*/
		private var _useTp:int = 0;
		/**回復*/
		private var _heal:int = 0;
		/**補給*/
		private var _supply:int = 0;
		/**状態回復*/
		private var _state:int = 0;
		/**状態異常*/
		private var _badstate:int = 0;
		
		private var _target:int = 0;
		
		private var _buff:String = null;
		private var _turn:int = 0;
		private var _level:int = 0;
		
		public function MasterSkillData(data:Object)
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
			_minRange = data.minrange;
			_maxRange = data.maxrange;
			_useFp = data.fp;
			_useCount = data.count;
			_maxCount = data.count;
			_useTp = data.usetp;
			_enableTp = data.tp;
			_heal = data.heal;
			_supply = data.supply;
			_state = data.state;
			_badstate = data.badstate;
			_buff = data.buff;
			_turn = data.turn;
			_level = data.level - 1;
			
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