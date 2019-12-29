package map.pallet
{
	import feathers.controls.Check;
	import feathers.controls.NumericStepper;
	import feathers.controls.TextArea;
	import feathers.controls.TextInput;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import map.canvas.TerrainTip;
	import parts.pulldown.OnePullDownList;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import system.UserImage;
	import view.MainController;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class TerrainSetter extends Sprite
	{
		
		//private var m_back:Image = null;
		/*
		private var _viewName:TextArea = null;
		private var _viewSelect:OnePullDownList = null;
		*/
		private var _typeName:TextArea = null;
		private var _typeSelect:OnePullDownList = null;
		
		private var _allCheckText:TextArea = null;
		
		private var _categoryName:TextArea = null;
		private var _categoryInput:TextInput = null;
		
		private var _costName:TextArea = null;
		private var _highName:TextArea = null;
		private var _agiName:TextArea = null;
		private var _defName:TextArea = null;
		private var _evName:TextArea = null;
		private var _underName:TextArea = null;
		
		private var _costStep:NumericStepper = null;
		
		private var _highStep:NumericStepper = null;
		private var _agiStep:NumericStepper = null;
		private var _defStep:NumericStepper = null;
		private var _evStep:NumericStepper = null;
		private var _underCheck:Check;
		
		// 変更チェック
		
		private var _setAllCheck:Check;
		private var _setTypeCheck:Check;
		private var _setCategoryCheck:Check;
		private var _setCostCheck:Check;
		private var _setHighCheck:Check;
		private var _setAgiCheck:Check;
		private var _setDefCheck:Check;
		private var _setEvCheck:Check;
		private var _setUnderCheck:Check;
		
		private var _typeBackImg:Image;
		private var _typeCategoryImg:Image;
		private var _typeCostImg:Image;
		private var _typeHighImg:Image;
		private var _typeAgiImg:Image;
		private var _typeDefImg:Image;
		private var _typeEvImg:Image;
		private var _typeUnderImg:Image;
		
		private var _type:int = 0;
		
		public function TerrainSetter()
		{
			var i:int = 0;
			super();
			
			//////////////////////////////////////////一段目/////////////////////////////////////
			// 全体チェック
			_allCheckText = new TextArea();
			_allCheckText.styleName = "defText";
			_allCheckText.text = "全体チェック";
			_allCheckText.backgroundSkin = new Image(UserImage.$.getSystemTex("tex_red"));
			_allCheckText.x = 180;
			_allCheckText.y = 8;
			_allCheckText.width = 64;
			
			addChild(_allCheckText);
			
			_setAllCheck = new Check();
			_setAllCheck.isSelected = true;
			_setAllCheck.x = 160;
			_setAllCheck.y = 8;
			_setAllCheck.addEventListener(Event.CHANGE, chengeAllCheck);
			
			// 表示名
			/*
			_viewName = new TextArea();
			_viewName.styleName = "defText";
			_viewName.text = "表示";
			_viewName.x = 8;
			_viewName.y = 8;
			_viewName.width = 48;
			
			_viewSelect = new OnePullDownList(TerrainTip.VIEW_TYPE_NAME[i], 0, 24, 64, 24, 8, false);
			_viewSelect.x = 72;
			_viewSelect.y = 8;
			for (i = 0; i < TerrainTip.VIEW_TYPE_NAME.length; i++)
			{
				_viewSelect.addChildList(TerrainTip.VIEW_TYPE_NAME[i], setTerrain, [TerrainTip.VIEW_TYPE[i]]);
			}
			//////////////////////////////////////////二段目/////////////////////////////////////
			// 地形セット
			function setTerrain(data:Array):void
			{
				_viewSelect.label = TerrainTip.VIEW_TYPE_NAME[data[0]];
				TerrainTip.ViewType = data[0];
				MainController.$.view.canvas.refreshTerrain();
				_viewSelect.closeList();
			}
			*/
			
			// 地形チェック
			
			_setTypeCheck = new Check();
			_setTypeCheck.isSelected = true;
			_setTypeCheck.x = 8;
			_setTypeCheck.y = 44;
			
			// 地形タイプ
			
			_typeName = new TextArea();
			_typeName.styleName = "defText";
			_typeName.text = "タイプ";
			_typeName.x = 28;
			_typeName.y = 48;
			_typeName.width = 48;
			
			_typeSelect = new OnePullDownList(TerrainTip.TYPE_NAME[0], 0, 24, 64, 24, 5, false);
			_typeSelect.x = 92;
			_typeSelect.y = 48;
			for (i = 0; i < TerrainTip.TYPE_NAME.length; i++)
			{
				_typeSelect.addChildList(TerrainTip.TYPE_NAME[i], setType, [TerrainTip.TYPE_NUM[i]]);
			}
			
			function setType(data:Array):void
			{
				_type = data[0];
				_typeSelect.closeList();
				_typeSelect.label = TerrainTip.TYPE_NAME[data[0]];
			}
			
			_typeBackImg = new Image(UserImage.$.getSystemTex("tex_red"));
			_typeBackImg.x = 4;
			_typeBackImg.y = 44;
			_typeBackImg.alpha = 0.7;
			_typeBackImg.width = 160;
			_typeBackImg.height = 32;
			
			//入力欄
			_setCategoryCheck = new Check();
			_setCategoryCheck.isSelected = true;
			_setCategoryCheck.x = 184;
			_setCategoryCheck.y = 44;
			
			_categoryName = new TextArea();
			_categoryName.styleName = "defText";
			_categoryName.text = "名称";
			_categoryName.x = 204;
			_categoryName.y = 48;
			_categoryName.width = 48;
			
			_categoryInput = new TextInput();
			_categoryInput.text = "";
			
			_categoryInput.textEditorFactory = function():ITextEditor
			{
				var stageTextTextEditor:StageTextTextEditor = new StageTextTextEditor();
				stageTextTextEditor.multiline = false;
				return stageTextTextEditor;
			}
			_categoryInput.backgroundSkin = new Image(Texture.fromBitmap(new Bitmap(new BitmapData(80, 24, true, 0xFF7733FF))));
			_categoryInput.x = 268;
			_categoryInput.y = 48;
			_categoryInput.width = 96;
			
			_typeCategoryImg = new Image(UserImage.$.getSystemTex("tex_red"));
			_typeCategoryImg.x = 180;
			_typeCategoryImg.y = 44;
			_typeCategoryImg.alpha = 0.7;
			_typeCategoryImg.width = 200;
			_typeCategoryImg.height = 32;
			
			//////////////////////////////////////////三段目/////////////////////////////////////
			_setCostCheck = new Check();
			_setCostCheck.isSelected = true;
			_setCostCheck.x = 8;
			_setCostCheck.y = 84;
			
			// コスト
			_costName = new TextArea();
			_costName.styleName = "defText";
			_costName.text = "コスト";
			_costName.x = 28;
			_costName.y = 88;
			_costName.width = 48;
			
			_costStep = new NumericStepper();
			_costStep.x = 92;
			_costStep.y = 88;
			_costStep.maximum = 99;
			_costStep.minimum = -1;
			_costStep.value = 1;
			_costStep.step = 1;
			
			
			_typeCostImg = new Image(UserImage.$.getSystemTex("tex_red"));
			_typeCostImg.x = 4;
			_typeCostImg.y = 84;
			_typeCostImg.alpha = 0.7;
			_typeCostImg.width = 160;
			_typeCostImg.height = 32;
			
			// 高さ			
			_setHighCheck = new Check();
			_setHighCheck.isSelected = true;
			_setHighCheck.x = 184;
			_setHighCheck.y = 84;
			
			_highName = new TextArea();
			_highName.styleName = "defText";
			_highName.text = "高さ";
			_highName.x = 204;
			_highName.y = 88;
			_highName.width = 48;
			
			_highStep = new NumericStepper();
			_highStep.x = 270;
			_highStep.y = 88;
			_highStep.maximum = 99;
			_highStep.minimum = -1;
			_highStep.value = 1;
			_highStep.step = 1;
			
			_typeHighImg = new Image(UserImage.$.getSystemTex("tex_red"));
			_typeHighImg.x = 180;
			_typeHighImg.y = 84;
			_typeHighImg.alpha = 0.7;
			_typeHighImg.width = 160;
			_typeHighImg.height = 32;
			
			//////////////////////////////////////////四段目/////////////////////////////////////
			// 補正回避
			_setAgiCheck = new Check();
			_setAgiCheck.x = 8;
			_setAgiCheck.y = 124;
			_setAgiCheck.isSelected = true;
			
			_agiName = new TextArea();
			_agiName.styleName = "defText";
			_agiName.text = "回避";
			_agiName.x = 28;
			_agiName.y = 128;
			_agiName.width = 48;
			
			_agiStep = new NumericStepper();
			_agiStep.x = 92;
			_agiStep.y = 128;
			_agiStep.maximum = 99;
			_agiStep.minimum = -99;
			_agiStep.value = 0;
			_agiStep.step = 1;
			
			
			_typeAgiImg = new Image(UserImage.$.getSystemTex("tex_red"));
			_typeAgiImg.x = 4;
			_typeAgiImg.y = 124;
			_typeAgiImg.alpha = 0.7;
			_typeAgiImg.width = 160;
			_typeAgiImg.height = 32;
			
			// 補正防御
			
			_setDefCheck = new Check();
			_setDefCheck.x = 184;
			_setDefCheck.y = 124;
			_setDefCheck.isSelected = true;
			
			_defName = new TextArea();
			_defName.styleName = "defText";
			_defName.text = "防御";
			_defName.x = 204;
			_defName.y = 128;
			_defName.width = 48;
			
			_defStep = new NumericStepper();
			_defStep.x = 268;
			_defStep.y = 128;
			_defStep.maximum = 99;
			_defStep.minimum = -99;
			_defStep.value = 0;
			_defStep.step = 1;
			
			_typeDefImg = new Image(UserImage.$.getSystemTex("tex_red"));
			_typeDefImg.x = 180;
			_typeDefImg.y = 124;
			_typeDefImg.alpha = 0.7;
			_typeDefImg.width = 160;
			_typeDefImg.height = 32;
			
			//////////////////////////////////////////五段目/////////////////////////////////////
			// イベント番号
			
			_setEvCheck = new Check();
			_setEvCheck.isSelected = true;
			_setEvCheck.x = 8;
			_setEvCheck.y = 164;
			
			_evName = new TextArea();
			_evName.styleName = "defText";
			_evName.text = "Ev番号";
			_evName.x = 28;
			_evName.y = 168;
			_evName.width = 48;
			
			_evStep = new NumericStepper();
			_evStep.x = 92;
			_evStep.y = 168;
			_evStep.maximum = 999;
			_evStep.minimum = 0;
			_evStep.value = 0;
			_evStep.step = 1;
			
			_typeEvImg = new Image(UserImage.$.getSystemTex("tex_red"));
			_typeEvImg.x = 4;
			_typeEvImg.y = 164;
			_typeEvImg.alpha = 0.7;
			_typeEvImg.width = 160;
			_typeEvImg.height = 32;
			
			// 地水中
			
			_setUnderCheck = new Check();
			_setUnderCheck.isSelected = true;
			_setUnderCheck.x = 184;
			_setUnderCheck.y = 164;
			
			_underName = new TextArea();
			_underName.styleName = "defText";
			_underName.text = "地水中";
			_underName.x = 204;
			_underName.y = 168;
			_underName.width = 48;
			
			_underCheck = new Check();
			_underCheck.x = 260;
			_underCheck.y = 164;
			_underCheck.isSelected = false;
			
			
			_typeUnderImg = new Image(UserImage.$.getSystemTex("tex_red"));
			_typeUnderImg.x = 180;
			_typeUnderImg.y = 164;
			_typeUnderImg.alpha = 0.7;
			_typeUnderImg.width = 160;
			_typeUnderImg.height = 32;
			
			
			addChild(_typeBackImg);
			addChild(_typeCategoryImg);
			addChild(_typeCostImg);
			addChild(_typeHighImg);
			addChild(_typeAgiImg);
			addChild(_typeDefImg);
			addChild(_typeEvImg);
			addChild(_typeUnderImg);
			
			//addChild(_viewName);
			addChild(_typeName);
			addChild(_costName);
			addChild(_highName);
			addChild(_agiName);
			addChild(_defName);
			addChild(_evName);
			addChild(_underName);
			addChild(_categoryName);
			
			addChild(_highStep);
			addChild(_costStep);
			addChild(_agiStep);
			addChild(_defStep);
			addChild(_evStep);
			
			addChild(_categoryInput);
			
			addChild(_typeSelect);
			
			addChild(_underCheck);
			
			addChild(_setAllCheck);
			addChild(_setTypeCheck);
			addChild(_setCategoryCheck);
			addChild(_setCostCheck);
			addChild(_setHighCheck);
			addChild(_setUnderCheck);
			addChild(_setEvCheck);
			addChild(_setAgiCheck);
			addChild(_setDefCheck);
			//addChild(_viewSelect);
		}
		
		private function chengeAllCheck(e:Event):void
		{
			if (_setAllCheck.isSelected)
			{
				_setTypeCheck.isSelected = true;
				_setCostCheck.isSelected = true;
				_setUnderCheck.isSelected = true;
				_setHighCheck.isSelected = true;
				_setCategoryCheck.isSelected = true;
				_setEvCheck.isSelected = true;
				_setAgiCheck.isSelected = true;
				_setDefCheck.isSelected = true;
			}
			else
			{
				_setTypeCheck.isSelected = false;
				_setCostCheck.isSelected = false;
				_setUnderCheck.isSelected = false;
				_setHighCheck.isSelected = false;
				_setCategoryCheck.isSelected = false;
				_setEvCheck.isSelected = false;
				_setAgiCheck.isSelected = false;
				_setDefCheck.isSelected = false;
			}
		
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function get cost():int
		{
			return _costStep.value;
		}
		
		public function get category():String
		{
			return _categoryInput.text;
		}
		
		public function get defComp():int
		{
			return _defStep.value;
		}
		
		public function get agiComp():int
		{
			return _agiStep.value;
		}
		
		public function get eventNo():int
		{
			return _evStep.value;
		}
		
		/*
		   public function get back():Image
		   {
		   return m_back;
		   }
		 */
		public function get high():int
		{
			return _highStep.value;
		}
		
		public function get under():Boolean
		{
			return _underCheck.isSelected;
		}
		
		public function get TypeCheck():Boolean
		{
			return _setTypeCheck.isSelected;
		}
		
		public function get CategoryCheck():Boolean
		{
			return _setCategoryCheck.isSelected;
		}
		
		public function get CostCheck():Boolean
		{
			return _setCostCheck.isSelected;
		}
		
		public function get HighCheck():Boolean
		{
			return _setHighCheck.isSelected;
		}
		
		public function get AgiCheck():Boolean
		{
			return _setAgiCheck.isSelected;
		}
		
		public function get DefCheck():Boolean
		{
			return _setDefCheck.isSelected;
		}
		
		public function get EvCheck():Boolean
		{
			return _setEvCheck.isSelected;
		}
		
		public function get UnderCheck():Boolean
		{
			return _setUnderCheck.isSelected;
		}
	
	}
}