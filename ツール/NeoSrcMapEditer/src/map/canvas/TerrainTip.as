package map.canvas
{
	import flash.text.TextFormatAlign;
	import map.pallet.TerrainSetter;
	import starling.display.Image;
	import starling.textures.Texture;
	import texttex.TextTex;
	import main.MainController;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class TerrainTip extends Image
	{
		public static var ViewType:int = 0;
		private var _type:int = 0;
		private var _cost:Number = 0;
		private var _category:String = "";
		private var _eventNo:int = 0;
		private var _agiComp:int = 0;
		private var _defComp:int = 0;
		private var _high:int = 0;
		
		private var _url:String = "";
		
		private var _under:Boolean = false;
		
		public static const TYPE_NUM:Array = [0, 1, 2, 3, 4];
		public static const TYPE_NAME:Array = ["地上", "水中", "空中", "宇宙", "不可"];
		public static const VIEW_TYPE:Array = [0, 1, 2, 3, 4, 5, 6, 7];
		public static const VIEW_TYPE_NAME:Array = ["タイプ", "名称", "コスト", "回避", "防御", "Ev番号", "高さ", "地水中"];
		public static const TYPE_COLOR:Array = [0x33FF00, 0x0000FF, 0x99FFFF, 0x800080, 0xCC00FF]
		
		public static var defaultTex:Texture = null;
		
		public function TerrainTip()
		{
			super(getTex("blank", 32, 32, 10, 0xFFFFFF));
			setType(true, 0, 1, 0, 0, 0, 0, false);
			touchable = false;
		}
		
		private function getTex(str:String, width:int = 0, height:int = 0, size:int = 0, color:uint = 0, align:String = TextFormatAlign.CENTER):Texture
		{
			var data:Object = TextTex.getTextTex(str, width, height, size, color, align);
			_url = data.url;
			return data.tex;
		}
		
		/** 地形タイプセット */
		public function setType( flg:Boolean,type:int, cost:int, agiComp:int, defComp:int, evNo:int, high:int, under:Boolean, category:String = ""):void
		{
			if (flg)
			{
				// チェック具合にかかわらずすべて変更
				_type = TYPE_NUM[type];
				_cost = cost;
				_category = category;
				_agiComp = agiComp;
				_defComp = defComp;
				_eventNo = evNo;
				_high = high;
				_under = under;
			}
			else
			{
				// 頭チェックがついているものだけを変更
				var item:TerrainSetter = MainController.$.view.pallet.terrainSelecter;
				if (item.TypeCheck)
				{
					_type = TYPE_NUM[type];
				}				
				if (item.CostCheck)
				{
					_cost = cost;
				}				
				if (item.CategoryCheck)
				{
					_category = category;
				}				
				if (item.AgiCheck)
				{
					_agiComp = agiComp;
				}				
				if (item.DefCheck)
				{
					_defComp = defComp;
				}				
				if (item.EvCheck)
				{
					_eventNo = evNo;
				}				
				if (item.HighCheck)
				{
					_high = high;
				}		
				if (item.UnderCheck)
				{
					_under = under;
				}
				
				
			}
			refresh();
		}
		
		public function refresh():void
		{
			var color:uint = TYPE_COLOR[_type];
			switch (ViewType)
			{
			// 地形タイプ
			case 0: 
				this.texture = getTex(TYPE_NAME[_type] + "\n" + _cost, 32, 32, 10, color);
				visible = true;
				break;
			// 地形名称
			case 1: 
				if (_category.length > 0)
				{
					visible = true;
					this.texture = getTex(_category.substr(0, 9), 32, 32, 10, color);
				}
				else
				{
					visible = false;
				}
				break;
			// コスト
			case 2: 
				visible = true;
				this.texture = getTex("" + cost, 32, 32, 18, color);
				break;
			// 回避
			case 3: 
				if (_agiComp == 0)
				{
					visible = false;
				}
				else
				{
					
					visible = true;
					this.texture = getTex("回避:\n" + _agiComp, 32, 32, 10, color);
				}
				break;
			// 防御
			case 4: 
				if (_defComp == 0)
				{
					
					visible = false;
				}
				else
				{
					visible = true;
					this.texture = getTex("防御:\n" + _defComp, 32, 32, 10, color);
				}
				break;
			// イベント番号
			case 5: 
				if (_eventNo > 0)
				{
					visible = true;
					this.texture = getTex("" + _eventNo, 32, 32, 18, color);
				}
				else
				{
					visible = false;
				}
				break;
			// 高度
			case 6: 
				visible = true;
				this.texture = getTex("" + _high, 32, 32, 18, color);
				break;
			// 地水中
			case 7: 
				if (_under)
				{
					visible = true;
					this.texture = getTex("○", 32, 32, 18, color);
				}
				else
				{
					
					visible = false;
				}
				
				break;
			}
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function get cost():Number
		{
			return _cost;
		}
		
		public function get category():String
		{
			return _category;
		}
		
		public function get agiComp():int
		{
			return _agiComp;
		}
		
		public function get defComp():int
		{
			return _defComp;
		}
		
		public function get eventNo():int
		{
			return _eventNo;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function get high():int
		{
			return _high;
		}
		
		public function get under():Boolean 
		{
			return _under;
		}
		
	}

}