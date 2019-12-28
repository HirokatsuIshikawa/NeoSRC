package database.master
{
	import common.CommonDef;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MasterWeaponData
	{
		public static const ACT_TYPE_ATK:int = 0;
		public static const ACT_TYPE_DEF:int = 1;
		public static const ACT_TYPE_AVO:int = 2;
		public static const ACT_TYPE_SKILL:int = 3;
		
		public static const WPN_CAP_OTHER:int = 0;
		public static const WPN_CAP_SKY:int = 1;
		public static const WPN_CAP_GROUND:int = 2;
		public static const WPN_CAP_WATER:int = 3;
		
		public static const WPN_BASIC_GRAP:int = 0;
		public static const WPN_BASIC_SHOT:int = 1;
		public static const WPN_BASIC_GUARD:int = 2;
		
		public static const ACT_LIST:Array = [ //
		"ATK", "DEF", "AVO", "SKILL"];
		
		public static const ACT_P_LIST:Array = [ //
		"攻撃", "防御", "回避", "スキル"];
		
		public static const WEAPON_PARAM_LIST:Array = [ //
		"name", "value", "atkplus",//
		"minrange", "maxrange", //
		"fp", "count", //
		"tp", "usetp", //
		"hitrate", "hitplus", //
		"avorate", "avoplus", //
		"defrate", "defplus", //
		"crttype", "crthit", "crtvalue", //
		"attribute", "weapontype", "terrain", //
		"actiontype"
		];
		public static const WEAPON_PARAM_P_LIST:Array = [ //
		"名前", "威力", "攻撃補正",//
		"最小射程", "最大射程",  //
		"消費", "回数", //
		"テンション", "消費テンション", //
		"命中率", "命中補正", //
		"回避率", "回避補正",  //
		"防御率", "防御補正", //
		"会心タイプ", "会心率", "会心値",  //
		"属性", "武器属性", "地形", //
		"行動タイプ" //
		];
		public static const WEAPON_DEFAULT_VALUE_LIST:Array = [ //
		"NO_NAME", 10, 0,//
		1, 1,  	// 射程
		0, 0, //消費、回数
		0, 0, //テンション
		100, 0,  //命中
		100, 0,  //回避
		100, 0,  //防御
		0, 0, 150,  //会心
		"", "", "BBBB", //
		1
		];
		
		
		/**識別用ID*/
		private var _id:int = 0;
		
		public function get id():int  { return _id; }
		
		/**武装名*/
		private var _name:String = null;
		
		public function get name():String  { return _name; }
		
		/**数値*/
		private var _value:int = 0;
		
		public function get value():int  { return _value; }
		/**攻撃補正*/
		private var _atkplus:int = 0;
		
		public function get atkplus():int  { return _atkplus; }
		
		/**最低射程*/
		private var _minRange:int = 0;
		
		public function get minRange():int  { return _minRange; }
		
		/**最大射程*/
		private var _maxRange:int = 0;
		
		public function get maxRange():int  { return _maxRange; }
		
		/**命中率*/
		private var _hitRate:int = 0;
		
		public function get hitRate():int  { return _hitRate; }
		
		/**命中補正*/
		private var _hitPlus:int = 0;
		
		public function get hitPlus():int  { return _hitPlus; }
		
		/**回避率*/
		private var _avoRate:int = 0;
		
		public function get avoRate():int  { return _avoRate; }
		
		/**回避補正*/
		private var _avoPlus:int = 0;
		
		public function get avoPlus():int  { return _avoPlus; }
		
		/**防御率*/
		private var _defRate:int = 0;
		
		public function get defRate():int  { return _defRate; }
		
		/**防御補正*/
		private var _defPlus:int = 0;
		
		public function get defPlus():int  { return _defPlus; }
		
		/**会心タイプ*/
		private var _crtType:String = null;
		
		public function get crtType():String  { return _crtType; }
		
		/**会心率*/
		private var _crtHit:int = 0;
		
		public function get crtHit():int  { return _crtHit; }
		
		/**会心値*/
		private var _crtValue:int = 0;
		
		public function get crtValue():int  { return _crtValue; }
		
		/**属性*/
		private var _attribute:String = null;
		
		public function get attribute():String  { return _attribute; }
		
		/**武器属性*/
		private var _weaponType:String = null;
		
		public function get weaponType():String  { return _weaponType; }
		
		/**地形*/
		private var _terrain:Vector.<int> = null;
		
		public function get terrain():Vector.<int>  { return _terrain; }
		
		/**行動タイプ*/
		private var _actType:int = 0;
		
		public function get actType():int  { return _actType; }
		
		public function get pWeapon():Boolean 
		{
			return _pWeapon;
		}
		
		public function get wpnBasicType():int 
		{
			return _wpnBasicType;
		}
		
		public function get useCount():int 
		{
			return _useCount;
		}
		
		public function get useFp():int 
		{
			return _useFp;
		}
		
		
		public function get maxCount():int 
		{
			return _maxCount;
		}
		
		public function set useCount(value:int):void 
		{
			_useCount = value;
		}
		
		public function get enableTp():int 
		{
			return _enableTp;
		}
		
		/**P武器*/
		private var _pWeapon:Boolean = false;
		/**格闘射撃判別*/
		private var _wpnBasicType:int = 0;
		/**使用回数*/
		private var _useCount:int = 0;
		private var _maxCount:int = 0;
		/**消費EN*/
		private var _useFp:int = 0;
		/**TP*/
		private var _enableTp:int = 0;
		/**消費TP*/
		private var _useTp:int = 0;
		
		public function MasterWeaponData(data:Object)
		{
			var i:int = 0;
			// 空データを基本値で埋める
			for (i = 0; i < WEAPON_PARAM_LIST.length; i++)
			{
				if (!data.hasOwnProperty(WEAPON_PARAM_LIST[i]))
				{
					data[WEAPON_PARAM_LIST[i]] = WEAPON_DEFAULT_VALUE_LIST[i];
				}
			}
			
			// データ設定
			_name = data.name;
			_value = data.value;
			_atkplus = data.atkplus;
			_minRange = data.minrange;
			_maxRange = data.maxrange;
			_hitRate = data.hitrate;
			_hitPlus = data.hitplus;
			_avoRate = data.avorate;
			_avoPlus = data.avoplus;
			_defRate = data.defrate;
			_defPlus = data.defplus;
			_crtType = data.crttype;
			_crtValue = data.cryvalue;
			_attribute = data.attribute;
			_weaponType = data.weapontype;
			_useFp = data.fp;
			_useCount = data.count;
			_maxCount = data.count;
			_useTp = data.usetp;
			_enableTp = data.tp;
			
			
			switch(data.actiontype)
			{
				case ACT_LIST[ACT_TYPE_ATK]:
				case ACT_P_LIST[ACT_TYPE_ATK]:
					_actType = ACT_TYPE_ATK;
					break;
				case ACT_LIST[ACT_TYPE_DEF]:
				case ACT_P_LIST[ACT_TYPE_DEF]:
					_actType = ACT_TYPE_DEF;
					_wpnBasicType = WPN_BASIC_GUARD;
					break;
				case ACT_LIST[ACT_TYPE_AVO]:
				case ACT_P_LIST[ACT_TYPE_AVO]:
					_actType = ACT_TYPE_AVO;
					_wpnBasicType = WPN_BASIC_GUARD;
					break;
				case ACT_LIST[ACT_TYPE_SKILL]:
				case ACT_P_LIST[ACT_TYPE_SKILL]:
					_actType = ACT_TYPE_SKILL;
					_wpnBasicType = WPN_BASIC_GUARD;
					break;
			}
			
			
			_terrain = new Vector.<int>;
			var str:String = data.terrain;
			str = str.toUpperCase();
			for (i = 0; i < 4; i++)
			{
				_terrain[i] = CommonDef.terrainChanger(str.charAt(i));
			}
			
			/**移動後可能武器設定*/
			if (_attribute.indexOf("Ｐ") >= 0)
			{
				_attribute = _attribute.replace("Ｐ", "");
				_pWeapon = true;
			}
			
			//武器属性
			if (_actType == ACT_TYPE_ATK)
			{
				if (_attribute.indexOf("格") >= 0)
				{
					_attribute = _attribute.replace("格", "");
					_wpnBasicType = WPN_BASIC_GRAP;
				}
				else if (_attribute.indexOf("射") >= 0)
				{
					_attribute = _attribute.replace("射", "");
					_wpnBasicType = WPN_BASIC_SHOT;
				}
				else
				{
					if (_minRange == 1 && _maxRange == 1)
					{
						_wpnBasicType = WPN_BASIC_GRAP;
					}
					else
					{
						_wpnBasicType = WPN_BASIC_SHOT;
					}
				}
			}
		}
	}
}