package scene.map.tip
{
	import flash.text.TextFormatAlign;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class TerrainData
	{
		public static var ViewType:int = 0;
		public var Type:int = 0;
		public var Cost:Number = 0;
		public var Category:String = "";
		public var EventNo:int = 0;
		public var AgiComp:int = 0;
		public var DefComp:int = 0;
		public var High:int = 0;
		public var Url:String = "";
		public var Under:Boolean = false;
		/**移動可能フラグ*/
		public var MoveChecked:Boolean = false;
		/**ルート選択フラグ*/
		public var RootSelected:Boolean = false;
		/** 攻撃範囲フラグ */
		public var isAttackSelect:Boolean = false;
		/**　攻撃範囲射程ポイント　*/
		public var AttackRangePoint:int = 0;
		/** 移動残りカウント */
		public var MoveCount:int = 0;
		/** 移動rui */
		private var _moveDirrection:Vector.<String>;
		
		
		public static const TERRAIN_TYPE_GROUND:int = 0;
		public static const TERRAIN_TYPE_WATER:int = 1;
		public static const TERRAIN_TYPE_SKY:int = 2;
		public static const TERRAIN_TYPE_SPACE:int = 3;
		public static const TERRAIN_TYPE_NONE:int = 4;
		
		public static const TYPE_NUM:Array = [0, 1, 2, 3, 4];
		public static const TYPE_NAME:Array = ["地上", "水中", "空中", "宇宙", "不可"];
		public static const VIEW_TYPE:Array = [0, 1, 2, 3, 4, 5];
		public static const VIEW_TYPE_NAME:Array = ["タイプ", "名称", "コスト", "回避", "防御", "Ev番号"];
		public static const TYPE_COLOR:Array = [0x33FF00, 0x0000FF, 0x99FFFF, 0x800080, 0xCC00FF]
		
		public static var defaultTex:Texture = null;
		
		public function TerrainData()
		{
			setType(0, 1, 0, 0, 0, 0, false);
		}
		
		/** 地形タイプセット */
		public function setType(type:int, cost:int, agiComp:int, defComp:int, evNo:int, high:int, under:Boolean, category:String = ""):void
		{
			Type = TYPE_NUM[type];
			Cost = cost;
			Category = category;
			AgiComp = agiComp;
			DefComp = defComp;
			EventNo = evNo;
			High = high;
			Under = under;
		}
		
		public function reset():void
		{
			MoveChecked = false;
			RootSelected = false;
			MoveCount = 0;
			isAttackSelect = false;
			AttackRangePoint = 0;
		}
		
		
		
		public function attackReset():void
		{
			isAttackSelect = false;
			AttackRangePoint = 0;
		}
		
		public function moveClone(list:Vector.<String>):void
		{
			var i:int = 0;
			_moveDirrection = new Vector.<String>;
			for (i = 0; i < list.length; i++)
			{
				_moveDirrection.push(list[i]);
			}
		}
		
		public function get MoveDirrection():Vector.<String>
		{
			return _moveDirrection;
		}
	}

}