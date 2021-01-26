package database.master.base
{
	
	/**
	 * ...
	 * @author ...
	 */
	public class BaseParam
	{
		
		public static const STATUS_STR:Array = ["HP", "FP", "ATK", "DEF", "TEC", "SPD", "CAP", "MND", "MOV", "CON"];
		public static const STATUS_STR_JP:Array = ["HP", "FP", "攻撃", "防御", "技術", "敏捷", "潜在", "精神", "移動", "制圧"];
		public static const ADD_STR:Array = ["HIT", "EVA", "HealHP", "HealFP"];
		public static const ADD_STR_JP:Array = ["命中", "回避", "HP回復", "FP回復"];
		/**HP*/
		protected var _HP:int = 0;
		
		public function get HP():int  { return _HP; }
		
		public function set HP(value:int):void
		{
			_HP = value;
		}
		
		/**FP*/
		protected var _FP:int = 0;
		
		public function get FP():int  { return _FP; }
		
		public function set FP(value:int):void
		{
			_FP = value;
		}
		
		/**攻撃*/
		protected var _ATK:int = 0;
		
		public function get ATK():int  { return _ATK; }
		
		public function set ATK(value:int):void
		{
			_ATK = value;
		}
		
		/**防御*/
		protected var _DEF:int = 0;
		
		public function get DEF():int  { return _DEF; }
		
		public function set DEF(value:int):void
		{
			_DEF = value;
		}
		
		/**器用*/
		protected var _TEC:int = 0;
		
		public function get TEC():int  { return _TEC; }
		
		public function set TEC(value:int):void
		{
			_TEC = value;
		}
		
		/**速度*/
		protected var _SPD:int = 0;
		
		public function get SPD():int  { return _SPD; }
		
		public function set SPD(value:int):void
		{
			_SPD = value;
		}
		
		/**潜在*/
		protected var _CAP:int = 0;
		
		public function get CAP():int  { return _CAP; }
		
		public function set CAP(value:int):void
		{
			_CAP = value;
		}
		
		/**精神*/
		protected var _MND:int = 0;
		
		public function get MND():int  { return _MND; }
		
		public function set MND(value:int):void
		{
			_MND = value;
		}
		
		/**移動*/
		protected var _MOV:int = 0;
		
		public function get MOV():int  { return _MOV; }
		
		public function set MOV(value:int):void
		{
			_MOV = value;
		}
		
		/**HP*/
		private var _HealHP:int = 0;
		
		public function get HealHP():int  { return _HealHP; }
		
		
		public function set HealHP(value:int):void
		{
			_HealHP = value;
		}
		
		/**FP*/
		private var _HealFP:int = 0;
		
		public function get HealFP():int  { return _HealFP; }
		
		
		public function set HealFP(value:int):void
		{
			_HealFP = value;
		}
		
		/**命中率*/
		private var _HIT:int = 0;
		
		public function get HIT():int  { return _HIT; }
		
		
		public function set HIT(value:int):void
		{
			_HIT = value;
		}
		
		/**回避率*/
		private var _EVA:int = 0;
		
		public function get EVA():int  { return _EVA; }
	
		
		public function set EVA(value:int):void
		{
			_EVA = value;
		}
		
        
		
		/**制圧*/
		protected var _CON:int = 0;
		
		public function get CON():int  { return _CON; }
		
		public function set CON(value:int):void
		{
			_CON = value;
		}
        
	}

}