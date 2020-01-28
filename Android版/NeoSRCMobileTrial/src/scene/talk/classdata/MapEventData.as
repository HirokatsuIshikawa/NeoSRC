package scene.talk.classdata
{
	import scene.main.MainController;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class MapEventData
	{
		public static const TYPE_NAME_JP:Array = ["", "移動", "戦闘", "戦闘後", "撃破", "全滅"];
		public static const TYPE_NAME:Array = ["", "move", "battle", "afterbattle", "defeat", "extinction"];
		
		public static const TYPE_NONE:int = 0;
		public static const TYPE_MATH_IN:int = 1;
		public static const TYPE_BATTLE_BEFORE:int = 2;
		public static const TYPE_BATTLE_AFTER:int = 3;
		public static const TYPE_DEFEAT:int = 4;
		public static const TYPE_EXTINCTION:int = 5;
		
		private var _label:String = "";
		
		public var _param:Object = null;
		private var _type:int = 0;
		
		public function MapEventData()
		{
		
		}
		
		
		// 移動イベントセット
		public function loadParam(setLabel:String, setParam:Object, setType:int):void
		{
			var i:int = 0;
			_param = setParam;
			_label = setLabel;
			_type = setType;
		}
		
		
		// 移動イベントセット
		public function setMapParam(label:String, param:Object):void
		{
			var i:int = 0;
			_param = param;
			_label = label;
			
			for (i = 0; i < TYPE_NAME.length; i++)
			{
				if (param.type === TYPE_NAME[i] || param.type === TYPE_NAME_JP[i])
				{
					_type = i;
					break;
				}
			}
		}
		
		/**戦闘前・戦闘後イベント*/
		public function setBattleParam(unitName1:String, unitName2:String, label:String, param:Object):void
		{
			var i:int = 0;
			_param = param;
			_label = label;
			_param.unit1 = unitName1;
			_param.unit2 = unitName2;
			if (param.type === MapEventData.TYPE_NAME[MapEventData.TYPE_BATTLE_BEFORE] || param.type === MapEventData.TYPE_NAME_JP[MapEventData.TYPE_BATTLE_BEFORE])
			{
				_type = TYPE_BATTLE_BEFORE;
			}
			else if (param.type === MapEventData.TYPE_NAME[MapEventData.TYPE_BATTLE_AFTER] || param.type === MapEventData.TYPE_NAME_JP[MapEventData.TYPE_BATTLE_AFTER])
			{
				
				_type = TYPE_BATTLE_AFTER;
			}
		}
		
		/**撃破イベント*/
		public function setDefeatParam(label:String, param:Object):void
		{
			var i:int = 0;
			_param = param;
			_label = label;
			_type = TYPE_DEFEAT;
		}
		
		/**全滅イベント*/
		public function setExtinctionParam(side:String, label:String, param:Object):void
		{
			var i:int = 0;
			_param = param;
			_param.side = side;
			_label = label;
			_type = TYPE_EXTINCTION;
		}


		
		public function judgeMapParam(param:Object):Boolean
		{
			var flg:Boolean = true;
			
			for (var key:String in param)
			{
				
				if (key === "type" || key === "label")
				{
					continue;
				}
				
				if (_param.hasOwnProperty(key))
				{
					if (param[key] != _param[key])
					{
						flg = false;
						break;
					}
				}
				else
				{
					flg = false;
					break;
				}
				
			}
			return flg;
		}
		
		
		public function judgeBattleParam(param:Object):Boolean
		{
			var flg:Boolean = false;
			
			/**
			if (
			(param.unit1 === _param.unit1 && param.unit2 === _param.unit2) ||
			(param.unit1 === _param.unit2 && param.unit2 === _param.unit1) ||
			(param.unit1 === _param.unit1 && getSideName(param.side2) === _param.unit2) ||
			(param.unit1 === _param.unit2 && getSideName(param.side2) === _param.unit1) ||
			(param.unit2 === _param.unit2 && getSideName(param.side1) === _param.unit1) ||
			(param.unit2 === _param.unit1 && getSideName(param.side1) === _param.unit2) ||
			(getSideName(param.side1) === _param.unit1 && getSideName(param.side2) === _param.unit2) ||
			(getSideName(param.side1) === _param.unit2 && getSideName(param.side2) === _param.unit1)
			)
			*/
			if (
			(getJudgeName(param, 1, 1) && getJudgeName(param, 2, 2)) ||
			(getJudgeName(param, 1, 2) && getJudgeName(param, 2, 1)) ||
			(getJudgeName(param, 1, 1) && getSideName(param.side2) === _param.unit2) ||
			(getJudgeName(param, 1, 2) && getSideName(param.side2) === _param.unit1) ||
			(getJudgeName(param, 2, 2) && getSideName(param.side1) === _param.unit1) ||
			(getJudgeName(param, 2, 1) && getSideName(param.side1) === _param.unit2) ||
			(getSideName(param.side1) === _param.unit1 && getSideName(param.side2) === _param.unit2) ||
			(getSideName(param.side1) === _param.unit2 && getSideName(param.side2) === _param.unit1)
			)
			{
				flg = true;
			}
			return flg;
		}
		
		public function judgeDefeatParam(param:Object):Boolean
		{
			var flg:Boolean = false;
			
			if (_param.hasOwnProperty("target"))
			{
				if (_param.target === param.unit || _param.target === param.nickname)
				{
					flg = true;
				}
			}
			else if (_param.hasOwnProperty("side"))
			{
				if (_param.side === param.side)
				{
					flg = true;
				}
			}
			
			return flg;
		}
		
		
		
		public function judgeExtinctionParam(param:Object):Boolean
		{
			var flg:Boolean = false;
			
			if (_param.side === param.side)
			{
				flg = true;
			}
			return flg;
		}
		
		
		public function getJudgeName(param:Object, side:int, target:int):Boolean
		{
			var unitname:String = "unit" + side;
			var nickname:String = "nickname" + side;
			var targetname:String = "unit" + target;
			if (param[unitname] === _param[targetname] ||
			param[nickname] === _param[targetname])
			{
				return true;
			}
			
			return false;
		}
		
		public function getSideName(num:int):String
		{
			return MainController.$.map.sideState[num].name;
		}
		
		
		public function get label():String
		{
			return _label;
		}
		
		public function get type():int
		{
			return _type;
		}
	
	}

}