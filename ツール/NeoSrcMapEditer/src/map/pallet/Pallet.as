package map.pallet
{
	import feathers.controls.Button;
	import feathers.controls.Slider;
	import feathers.controls.TextArea;
	import feathers.controls.ToggleButton;
	import feathers.core.ToggleGroup;
	import feathers.skins.ImageSkin;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import map.canvas.TerrainTip;
	import map.pallet.PalletTip;
	import parts.pulldown.OnePullDownList;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import system.UserImage;
	import view.MainController;
	
	/**
	 * ...
	 * @author
	 */
	public class Pallet extends Sprite
	{
		
		private var m_palletState:int = 0;
		public static const PALLET_SIMPLE:int = 0;
		public static const PALLET_LINE:int = 1;
		public static const PALLET_RECT:int = 2;
		public static const PALLET_FILL:int = 3;
		public static const PALLET_SPOIT:int = 4;
		public static const PALLET_COPY:int = 5;
		public static const PALLET_PEAST:int = 6;
		
		public static const WIDTH_TIP:int = 12;
		public static const HEIGHT_TIP:int = 10;
		
		/**パレット背景*/
		private var m_back:Image = null;
		/**チップエリア背景画像*/
		private var m_tipAreaImg:Image = null;
		
		/**パレットチップ一覧*/
		private var m_tip:Vector.<PalletTip> = null;
		/**チップコンテナ*/
		private var m_tipContena:Sprite = null;
		/**パレットチップエリア*/
		private var m_tipArea:Sprite = null;
		/**選択ちゅうエリア*/
		private var m_selectTipArea:Image = null;
		/**選択中チップ*/
		private var m_selectTip:Image = null;
		/**スライダー*/
		private var m_slider:Slider = null;
		/**URL*/
		private var m_url:String = null;
		/**チップ名*/
		private var m_name:String = null;
		
		/**ボタン枠画像*/
		private var m_flameImg:Image = null;
		/**ボタン枠画像*/
		public var m_elaseFlameImg:Image = null;
		
		/**消しゴムボタン*/
		private var m_elaseBtn:Button = null;
		
		/**ペン先状況*/
		//private var m_stateTxt:TextArea = null;
		
		/**単発ボタン*/
		private var m_simpleBtn:Button = null;
		/**四角形ボタン*/
		private var m_rectBtn:Button = null;
		/**塗りつぶしボタン*/
		private var m_fillBtn:Button = null;
		/**スポイトボタン*/
		private var m_spoitBtn:Button = null;
		/**コピーボタン*/
		private var m_copyBtn:Button = null;
		/**ペーストボタン*/
		private var m_peastBtn:Button = null;
		/**選択番号*/
		private var m_selectNum:int = 0;
		
		/**オートタイルフラグ*/
		private var m_autoTile:Boolean = false;
		private var m_autoObj:Boolean = false;
		
		/**スポイト使用フラグ*/
		private var m_useSpoit:Boolean = false;
		
		/**選択階層ラベル*/
		private var m_selectLayerNum:TextArea = null;
		
		/**チップタイプボタンリスト*/
		private var m_tipTypeBtnList:Vector.<ToggleButton> = null;
		private var m_tipTypeToggleGroup:ToggleGroup = null;
		/**レイヤー選択ボタンリスト*/
		private var m_layerBtnList:Vector.<ToggleButton> = null;
		private var m_layerToggleGroup:ToggleGroup = null;
		
		/**パレット選択*/
		private var m_selecter:PalletSelecter = null;
		/**地形データセット*/
		private var _terrainSelecter:TerrainSetter = null;
		/** 地形データビュー */
		protected var _terrainStateWindow:TerrainStateWindow = null;
		/**初期化中*/
		private var _initing:Boolean = false;
		
		public function Pallet()
		{
			super();
			_initing = true;
			m_back = new Image(UserImage.$.getSystemTex("tex_black"));
			m_back.alpha = 0.5;
			m_back.width = 32 * WIDTH_TIP + 32;
			m_back.height = 32 * HEIGHT_TIP + 72;
			addChild(m_back);
			
			m_tipAreaImg = new Image(UserImage.$.getSystemTex("tex_black"));
			m_tipAreaImg.x = 4;
			m_tipAreaImg.y = 132;
			m_tipAreaImg.alpha = 0.3;
			m_tipAreaImg.width = WIDTH_TIP * 32;
			m_tipAreaImg.height = (HEIGHT_TIP - 2) * 32;
			m_tipAreaImg.touchable = false;
			addChild(m_tipAreaImg);
			
			//チップコンテナ
			m_tipContena = new Sprite();
			m_tipContena.x = 4;
			m_tipContena.y = 132;
			m_tipContena.mask = new Quad(WIDTH_TIP * 32, (HEIGHT_TIP - 2) * 32);
			
			addChild(m_tipContena);
			//チップ表示エリア
			m_tipArea = new Sprite();
			m_tip = new Vector.<PalletTip>;
			m_tipContena.addChild(m_tipArea);
			m_tipArea.addEventListener(TouchEvent.TOUCH, clickHandler);
			//スライダー
			m_slider = new Slider();
			//m_slider.visible = false;
			m_slider.direction = Slider.DIRECTION_VERTICAL;
			m_slider.x = 32 * WIDTH_TIP + 4;
			m_slider.y = 132;
			m_slider.height = 32 * (HEIGHT_TIP - 2);
			m_slider.step = 0.1;
			m_slider.page = 0.5;
			m_slider.addEventListener(Event.CHANGE, tipAreaMove);
			
			m_slider.visible = false;
			addChild(m_slider);
			
			///////////////////////////////////////一段目//////////////////////////////////////////
			//消しゴムボタン
			m_elaseBtn = new Button();
			m_elaseBtn.styleName = "iconBtn";
			m_elaseBtn.defaultSkin = new Image(UserImage.$.getSystemTex("icon_erlaser"));
			m_elaseBtn.width = 32;
			m_elaseBtn.height = 32;
			m_elaseBtn.x = 52;
			m_elaseBtn.y = 12;
			m_elaseBtn.addEventListener(Event.TRIGGERED, elaseAct);
			addChild(m_elaseBtn);
			
			//消しゴム選択枠
			m_elaseFlameImg = new Image(UserImage.$.getSystemTex("select_frame"));
			m_elaseFlameImg.x = m_elaseBtn.x;
			m_elaseFlameImg.y = m_elaseBtn.y;
			m_elaseFlameImg.width = 32;
			m_elaseFlameImg.height = 32;
			m_elaseFlameImg.touchable = false;
			m_elaseFlameImg.visible = false;
			addChild(m_elaseFlameImg);
			checkElaseFlame();
			
			///////////////////////////////////////二段目//////////////////////////////////////////
			//鉛筆ボタン
			m_simpleBtn = new Button();
			m_simpleBtn.styleName = "iconBtn";
			m_simpleBtn.defaultSkin = new Image(UserImage.$.getSystemTex("icon_pencil"));
			m_simpleBtn.width = 32;
			m_simpleBtn.height = 32;
			m_simpleBtn.x = 12;
			m_simpleBtn.y = 52;
			m_simpleBtn.addEventListener(Event.TRIGGERED, getPsFunc(PALLET_SIMPLE));
			addChild(m_simpleBtn);
			
			//タッチ枠
			m_flameImg = new Image(UserImage.$.getSystemTex("select_frame"));
			m_flameImg.width = 32;
			m_flameImg.height = 32;
			m_flameImg.touchable = false;
			
			//四角形ボタン
			m_rectBtn = new Button();
			m_rectBtn.styleName = "iconBtn";
			m_rectBtn.defaultSkin = new Image(UserImage.$.getSystemTex("icon_rect"));
			m_rectBtn.width = 32;
			m_rectBtn.height = 32;
			m_rectBtn.x = 52;
			m_rectBtn.y = 52;
			m_rectBtn.addEventListener(Event.TRIGGERED, getPsFunc(PALLET_RECT));
			addChild(m_rectBtn);
			
			//塗りつぶしボタン
			m_fillBtn = new Button();
			m_fillBtn.styleName = "iconBtn";
			m_fillBtn.defaultSkin = new Image(UserImage.$.getSystemTex("icon_paint"));
			m_fillBtn.width = 32;
			m_fillBtn.height = 32;
			m_fillBtn.x = 92;
			m_fillBtn.y = 52;
			m_fillBtn.addEventListener(Event.TRIGGERED, getPsFunc(PALLET_FILL));
			addChild(m_fillBtn);
			
			///////////////////////////////////////三段目//////////////////////////////////////////
			//スポイトボタン
			m_spoitBtn = new Button();
			m_spoitBtn.styleName = "iconBtn";
			m_spoitBtn.defaultSkin = new Image(UserImage.$.getSystemTex("icon_spoit"));
			m_spoitBtn.width = 32;
			m_spoitBtn.height = 32;
			m_spoitBtn.x = 12;
			m_spoitBtn.y = 92;
			m_spoitBtn.addEventListener(Event.TRIGGERED, getPsFunc(PALLET_SPOIT));
			addChild(m_spoitBtn);
			
			//コピーボタン
			m_copyBtn = new Button();
			m_copyBtn.styleName = "iconBtn";
			m_copyBtn.defaultSkin = new Image(UserImage.$.getSystemTex("icon_copy"));
			m_copyBtn.width = 32;
			m_copyBtn.height = 32;
			m_copyBtn.x = 52;
			m_copyBtn.y = 92;
			m_copyBtn.addEventListener(Event.TRIGGERED, getPsFunc(PALLET_COPY));
			addChild(m_copyBtn);
			
			//ペーストボタン
			m_peastBtn = new Button();
			m_peastBtn.styleName = "iconBtn";
			m_peastBtn.defaultSkin = new Image(UserImage.$.getSystemTex("icon_paste"));
			m_peastBtn.width = 32;
			m_peastBtn.height = 32;
			m_peastBtn.x = 92;
			m_peastBtn.y = 92;
			m_peastBtn.addEventListener(Event.TRIGGERED, getPsFunc(PALLET_PEAST));
			addChild(m_peastBtn);
			
			//選択状況
			palletStateSet(m_palletState);
			
			///////////////////////////////////////種類選択//////////////////////////////////////////
			
			m_tipTypeBtnList = new Vector.<ToggleButton>();
			m_tipTypeToggleGroup = new ToggleGroup();
			m_tipTypeToggleGroup.addEventListener(Event.CHANGE, selectTipType);
			var i:int = 0;
			var tipTypeTitle:Array = ["マップ", "タイル", "群体"]
			
			for (i = 0; i < tipTypeTitle.length; i++)
			{
				var tipTypeBtn:ToggleButton = new ToggleButton();
				tipTypeBtn.label = tipTypeTitle[i];
				tipTypeBtn.toggleGroup = m_tipTypeToggleGroup;
				tipTypeBtn.x = 160;
				tipTypeBtn.y = 16 + 24 * i;
				tipTypeBtn.width = 96;
				addChild(tipTypeBtn);
				
				m_tipTypeBtnList.push(tipTypeBtn);
			}
			
			m_tipTypeBtnList[0].isSelected = true;
			
			///////////////////////////////////////レイヤー選択//////////////////////////////////////////
			
			m_layerBtnList = new Vector.<ToggleButton>();
			m_layerToggleGroup = new ToggleGroup();
			m_layerToggleGroup.addEventListener(Event.CHANGE, selectLayer);
			var layerBtnTitle:Array = ["レイヤー1", "レイヤー2", "レイヤー3", "地形データ"]
			
			for (i = 0; i < 4; i++)
			{
				var layerBtn:ToggleButton = new ToggleButton();
				layerBtn.label = layerBtnTitle[i];
				layerBtn.toggleGroup = m_layerToggleGroup;
				layerBtn.x = 272;
				layerBtn.y = 16 + 24 * i;
				layerBtn.width = 96;
				addChild(layerBtn);
				
				m_layerBtnList.push(layerBtn);
			}
			
			m_layerBtnList[0].isSelected = true;
			
			// 背景タイルセット
			function setBackTile():void
			{
				MainController.$.view.tileConfig.visible = true;
				MainController.$.view.canvas.setBackTile();
				checkElaseFlame();
			}
			
			m_selecter = new PalletSelecter();
			m_selecter.x = 32 * WIDTH_TIP + 32;
			m_selecter.y = 0;
			addChild(m_selecter);
			
			_terrainSelecter = new TerrainSetter();
			_terrainSelecter.x = 4;
			_terrainSelecter.y = 132;
			_terrainSelecter.visible = false;
			addChild(_terrainSelecter);
			
			_terrainStateWindow = new TerrainStateWindow();
			_terrainStateWindow.x = 32 * WIDTH_TIP + 32;
			_terrainStateWindow.y = 0;
			_terrainStateWindow.visible = false;
			addChild(_terrainStateWindow);
			//this.addChild(m_tipType);
			//this.addChild(m_layerSelect);
			_initing = false;
		}
		
		/**ソート条件セット*/
		private function selectTipType(e:Event):void
		{
			if (_initing)
			{
				return;
			}
			
			var group:ToggleGroup = e.currentTarget as ToggleGroup;
			
			MainController.$.view.setSelecter(group.selectedIndex);
		}
		
		//レイヤーセット関数
		private function selectLayer(e:Event):void
		{
			if (_initing)
			{
				return;
			}
			var group:ToggleGroup = e.currentTarget as ToggleGroup;
			
			var layer:int = group.selectedIndex;
			var i:int = 0;
			switch (layer)
			{
			case 0: 
			case 1: 
			case 2:
				
				if (MainController.$.view.canvas.terrainLayer.visible)
				{
					useTerrainTool(true);
				}
				
				MainController.$.view.tileConfig.visible = false;
				MainController.$.view.canvas.layer = layer;
				MainController.$.view.canvas.terrainLayer.visible = false;
				MainController.$.view.canvas.terrainBackImg.visible = false;
				
				MainController.$.view.tileConfig.visible = false;
				_terrainStateWindow.visible = false;
				_terrainSelecter.visible = false;
				m_selecter.visible = true;
				m_tipContena.visible = true;
				
				m_selectTip.visible = true;
				m_selectTipArea.visible = true;
				for (i = 0; i < m_tipTypeBtnList.length; i++)
				{
					m_tipTypeBtnList[i].visible = true;
				}
				
				break;
			case 3: 
				if (!MainController.$.view.canvas.terrainLayer.visible)
				{
					useTerrainTool(false);
				}
				MainController.$.view.canvas.terrainLayer.visible = true;
				MainController.$.view.canvas.terrainBackImg.visible = true;
				
				MainController.$.view.tileConfig.visible = false;
				_terrainSelecter.visible = true;
				_terrainStateWindow.visible = true;
				m_selecter.visible = false;
				m_tipContena.visible = false;
				MainController.$.view.canvas.refreshTerrain();
				
				m_selectTip.visible = false;
				m_selectTipArea.visible = false;
				
				for (i = 0; i < m_tipTypeBtnList.length; i++)
				{
					m_tipTypeBtnList[i].visible = false;
				}
				
				m_elaseFlameImg.visible = false;
				break;
			}
		}
		
		/**スライダーイベント*/
		private function tipAreaMove(e:Event):void
		{
			var slid:Slider = e.target as Slider;
			m_tipArea.y = slid.value;
			//closeOutSide();
		}
		
		private function closeOutSide():void
		{
			
			for (var i:int = 0; i < m_tip.length; i++)
			{
				if (m_tip[i].y + m_tipArea.y + 32 < 0 || m_tip[i].y + m_tipArea.y > m_tipContena.height)
				{
					m_tip[i].visible = false;
				}
				else
				{
					m_tip[i].visible = true;
				}
			}
		}
		
		/**パレット用画像追加*/
		public function pushTip(tex:Texture, name:String, url:String):void
		{
			if (m_selectTip == null)
			{
				m_selectTipArea = new Image(UserImage.$.getSystemTex("tex_red"));
				m_selectTipArea.x = 10;
				m_selectTipArea.y = 10;
				m_selectTipArea.width = 36;
				m_selectTipArea.height = 36;
				
				m_selectTip = new Image(tex);
				m_selectTip.x = 12;
				m_selectTip.y = 12;
				addChild(m_selectTipArea);
				addChild(m_selectTip);
			}
			
			var tip:PalletTip = new PalletTip(tex, name, url);
			tip.x = Math.floor(m_tip.length % WIDTH_TIP) * 32;
			tip.y = Math.floor(m_tip.length / WIDTH_TIP) * 32;
			//tip.touchFunc(changeTip);
			m_tipArea.addChild(tip);
			//チップ追加
			m_tip.push(tip);
		}
		
		/**チップ追加完了*/
		public function pushComp():void
		{
			if (m_tip.length <= 0)
			{
				return;
			}
			
			var num:int = 0;
			num = m_tip.length / WIDTH_TIP;
			if (m_tip.length % WIDTH_TIP > 0)
			{
				num++;
			}
			if (32 * num > m_tipContena.mask.height)
			{
				m_slider.minimum = -(32 * num - m_tipContena.mask.height);
				m_slider.maximum = 0;
				m_slider.value = 0;
				m_slider.visible = true;
				
				m_slider.thumbProperties.height = Math.max(m_slider.height - (32 * num - m_slider.height), 20);
			}
			else
			{
				m_slider.value = 0;
				m_slider.visible = false;
			}
			
			if (m_autoTile || m_autoObj)
			{
				m_tip[0].texture = UserImage.$.getSystemTex("AUTO");
			}
			m_selectTip.texture = m_tip[0].texture;
			m_name = m_tip[0].tipName;
			m_url = m_tip[0].url;
			m_selectNum = 0;
		}
		
		private function getPsFunc(num:int):Function
		{
			return function():void
			{
				palletStateSet(num);
			}
		}
		
		/**パレット状態セット*/
		public function palletStateSet(num:int):void
		{
			switch (num)
			{
			case PALLET_SIMPLE: 
				m_palletState = PALLET_SIMPLE;
				
				m_flameImg.x = m_simpleBtn.x;
				m_flameImg.y = m_simpleBtn.y;
				//m_stateTxt.text = "単";
				checkElaseFlame();
				break;
			case PALLET_RECT: 
				m_palletState = PALLET_RECT;
				m_flameImg.x = m_rectBtn.x;
				m_flameImg.y = m_rectBtn.y;
				//m_stateTxt.text = "四";
				checkElaseFlame();
				break;
			case PALLET_FILL: 
				m_palletState = PALLET_FILL;
				m_flameImg.x = m_fillBtn.x;
				m_flameImg.y = m_fillBtn.y;
				//m_stateTxt.text = "塗";
				checkElaseFlame();
				break;
			case PALLET_SPOIT: 
				m_palletState = PALLET_SPOIT;
				m_flameImg.x = m_spoitBtn.x;
				m_flameImg.y = m_spoitBtn.y;
				//m_stateTxt.text = "吸";
				checkElaseFlame();
				break;
			case PALLET_COPY: 
				m_palletState = PALLET_COPY;
				m_flameImg.x = m_copyBtn.x;
				m_flameImg.y = m_copyBtn.y;
				//m_stateTxt.text = "写";
				m_elaseFlameImg.visible = false;
				break;
			case PALLET_PEAST: 
				m_palletState = PALLET_PEAST;
				m_flameImg.x = m_peastBtn.x;
				m_flameImg.y = m_peastBtn.y;
				//m_stateTxt.text = "貼";
				m_elaseFlameImg.visible = false;
				break;
			}
			addChild(m_flameImg);
		}
		
		/**消しゴム選択時*/
		public function elaseAct():void
		{
			var tip:PalletTip = new PalletTip(Texture.fromBitmapData(new BitmapData(32, 32, true, 0x0)), "blank", "blank");
			m_selectNum = -1;
			changeTip(tip);
		}
		
		/**消しゴム選択枠表示*/
		public function checkElaseFlame():void
		{
			
			if (m_name === "blank" && m_url === "blank")
			{
				m_elaseFlameImg.visible = true;
			}
			else
			{
				m_elaseFlameImg.visible = false;
			}
		
		}
		
		/**地形ツール*/
		public function useTerrainTool(flg:Boolean):void
		{
			m_fillBtn.visible = flg;
			m_spoitBtn.visible = flg;
			m_copyBtn.visible = flg;
			m_peastBtn.visible = flg;
			m_elaseBtn.visible = flg;
			m_elaseFlameImg.visible = flg;
			
			if (!flg)
			{
				m_palletState = PALLET_SIMPLE;
				//m_stateTxt.text = "単";
				palletStateSet(m_palletState);
			}
			else
			{
				checkElaseFlame();
			}
		}
		
		/**選択中チップ変更*/
		private function changeTip(tip:PalletTip):void
		{
			m_selectTip.texture = tip.texture;
			m_name = tip.tipName;
			m_url = tip.url;
			checkElaseFlame();
			//this.flatten();
		}
		
		/**位置からパレット取得*/
		private function getPalletNo(pos:Point):void
		{
			if (pos.x >= 0 && pos.x <= m_tipArea.width && pos.y >= 0 && pos.y <= m_tipArea.height)
			{
				
				var num:int = 0;
				num += Math.floor(pos.x / 32);
				num += Math.floor(pos.y / 32) * WIDTH_TIP;
				if (num >= 0 && num < m_tip.length)
				{
					MainController.$.view.pallet.useSpoit = false;
					m_selectNum = num;
					changeTip(m_tip[num]);
				}
			}
		}
		
		private function clickHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(stage);
			//タッチしているか
			var pos:Point;
			if (touch)
			{
				//クリック上げた時
				switch (touch.phase)
				{
				case TouchPhase.ENDED: 
					break;
				case TouchPhase.HOVER: 
					break;
				case TouchPhase.MOVED:
					
					//if (touch.isTouching(touch.target))
					//{
					pos = m_tipArea.globalToLocal(new Point(touch.globalX, touch.globalY));
					getPalletNo(pos);
					//}
					break;
				case TouchPhase.BEGAN: 
					pos = m_tipArea.globalToLocal(new Point(touch.globalX, touch.globalY));
					getPalletNo(pos);
					break;
				}
			}
		}
		
		public function reset():void
		{
			m_tipArea.removeChildren();
			for (var i:int = 0; i < m_tip.length; i++)
			{
				m_tip[i].dispose();
			}
			m_tip = new Vector.<PalletTip>;
		}
		
		public function get selectTip():Image
		{
			return m_selectTip;
		}
		
		public function get url():String
		{
			return m_url;
		}
		
		public function get tipName():String
		{
			return m_name;
		}
		
		public function get palletState():int
		{
			return m_palletState;
		}
		
		public function set selectTip(value:Image):void
		{
			m_selectTip = value;
		}
		
		public function set url(value:String):void
		{
			m_url = value;
		}
		
		public function set tipName(value:String):void
		{
			m_name = value;
		}
		
		public function set autoTile(value:Boolean):void
		{
			m_autoTile = value;
		}
		
		public function autoTileTip(num:int):Object
		{
			var obj:Object = new Object();
			obj.name = m_tip[num].tipName;
			obj.url = m_tip[num].url;
			return obj;
		}
		
		public function get autoTile():Boolean
		{
			return m_autoTile;
		}
		
		public function get selectNum():int
		{
			return m_selectNum;
		}
		
		public function get autoObj():Boolean
		{
			return m_autoObj;
		}
		
		public function set autoObj(value:Boolean):void
		{
			m_autoObj = value;
		}
		
		public function get back():Image
		{
			return m_back;
		}
		
		public function get selecter():PalletSelecter
		{
			return m_selecter;
		}
		
		public function get useSpoit():Boolean
		{
			return m_useSpoit;
		}
		
		public function set useSpoit(value:Boolean):void
		{
			m_useSpoit = value;
		}
		
		public function get terrainSelecter():TerrainSetter
		{
			return _terrainSelecter;
		}
		
		public function get terrainStateWindow():TerrainStateWindow
		{
			return _terrainStateWindow;
		}
		
		public function set terrainStateWindow(value:TerrainStateWindow):void
		{
			_terrainStateWindow = value;
		}
		
		public function setBacktileTip():void
		{
			//m_backTileBtn.defaultSkin = new Image(m_selectTip.texture);
		}
	}

}