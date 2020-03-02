package map.pallet
{
	import feathers.controls.TextArea;
	import feathers.controls.ToggleButton;
	import feathers.core.ToggleGroup;
	import flash.display.BitmapData;
	import map.canvas.TerrainTip;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import system.UserImage;
	import main.MainController;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class TerrainStateWindow extends Sprite
	{
		
		private var m_back:Image = null;
		
		private var _typeName:ToggleButton = null;
		private var _categoryName:ToggleButton = null;
		private var _costName:ToggleButton = null;
		private var _agiName:ToggleButton = null;
		private var _defName:ToggleButton = null;
		private var _evName:ToggleButton = null;
		private var _highName:ToggleButton = null;
		private var _underJudge:ToggleButton = null;
		
		private var m_tipType:ToggleGroup = null;
		
		private const btnWidth:int = 120;
		
		public function TerrainStateWindow()
		{
			m_back = new Image(UserImage.$.getSystemTex("tex_black"));
			m_back.alpha = 0.7;
			m_back.width = 148;
			m_back.height = 32 * Pallet.HEIGHT_TIP + 72;
			addChild(m_back);
			
			m_tipType = new ToggleGroup();
			m_tipType.addEventListener(Event.CHANGE, selectShowInfo);
			
			// 地形タイプ
			_typeName = new ToggleButton();
			_typeName.styleName = "defText";
			_typeName.label = "タイプ";
			_typeName.x = 8;
			_typeName.y = 20;
			_typeName.width = btnWidth;
			
			// コスト
			_costName = new ToggleButton();
			_costName.styleName = "defText";
			_costName.label = "コスト";
			_costName.x = 8;
			_costName.y = 52;
			_costName.width = btnWidth;
			
			// 補正回避
			_agiName = new ToggleButton();
			_agiName.styleName = "defText";
			_agiName.label = "回避";
			_agiName.x = 8;
			_agiName.y = 84;
			_agiName.width = btnWidth;
			
			// 補正防御
			_defName = new ToggleButton();
			_defName.styleName = "defText";
			_defName.label = "防御";
			_defName.x = 8;
			_defName.y = 116;
			_defName.width = btnWidth;
			
			// イベント番号
			_evName = new ToggleButton();
			_evName.styleName = "defText";
			_evName.label = "Ev番号";
			_evName.x = 8;
			_evName.y = 148;
			_evName.width = btnWidth;
			
			//入力欄
			_categoryName = new ToggleButton();
			_categoryName.styleName = "defText";
			_categoryName.label = "名称";
			_categoryName.x = 8;
			_categoryName.y = 180;
			_categoryName.width = btnWidth;
			
			//高さ
			_highName = new ToggleButton();
			_highName.styleName = "defText";
			_highName.label = "高さ";
			_highName.x = 8;
			_highName.y = 212;
			_highName.width = btnWidth;
			//地水中
			_underJudge = new ToggleButton();
			_underJudge.styleName = "defText";
			_underJudge.label = "地水中";
			_underJudge.x = 8;
			_underJudge.y = 244;
			_underJudge.width = btnWidth;
			
			_typeName.toggleGroup = m_tipType;
			_categoryName.toggleGroup = m_tipType;
			_costName.toggleGroup = m_tipType;
			_agiName.toggleGroup = m_tipType;
			_defName.toggleGroup = m_tipType;
			_evName.toggleGroup = m_tipType;
			_highName.toggleGroup = m_tipType;
			_underJudge.toggleGroup = m_tipType;
			
			addChild(_typeName);
			addChild(_costName);
			addChild(_agiName);
			addChild(_defName);
			addChild(_evName);
			addChild(_categoryName);
			addChild(_highName);
			addChild(_underJudge);
		}
		
		public function setState(type:int, cost:int, agiComp:int, defComp:int, evNo:int, high:int, under:Boolean, category:String = ""):void
		{
			
			_typeName.label = "タイプ:" + TerrainTip.TYPE_NAME[type];
			_costName.label = "Cost:" + cost;
			_agiName.label = "回避:" + agiComp;
			_defName.label = "防御:" + defComp;
			_evName.label = "Ev:" + evNo;
			_categoryName.label = "名称:" + category;
			_highName.label = "高さ:" + high;
			_underJudge.label = under == true ? "地水中:〇" : "地水中：×";
		
		}
		
		public function selectShowInfo(e:Event):void
		{
			
			var group:ToggleGroup = e.currentTarget as ToggleGroup;
			// 地形セット
			TerrainTip.ViewType = group.selectedIndex;
			if (MainController.$.view.canvas != null)
			{
				MainController.$.view.canvas.refreshTerrain();
			}
		}
		
		public function get back():Image
		{
			return m_back;
		}
	}
}