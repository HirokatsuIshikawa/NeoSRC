package view
{
	import custom.CustomTheme;
	import dataloader.MapLoader;
	import dataloader.TipLoader;
	import feathers.controls.Slider;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.NativeWindow;
	import flash.filesystem.File;
	import flash.net.SharedObject;
	import map.canvas.MapCanvas;
	import map.pallet.Pallet;
	import parts.header.Header;
	import parts.popwindow.CreateAreaWindow;
	import parts.popwindow.SizeChangeWindow;
	import parts.popwindow.StartWindow;
	import parts.popwindow.TileConfig;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import system.CommonDef;
	import system.UserImage;
	import texttex.TextTex;
	
	/**
	 * ...
	 * @author
	 */
	public class MainViewer extends Sprite
	{
		public static var INFO:SharedObject = null;
		public static var SCENARIO_PATH:String = "";
		/**カスタムテーマ*/
		protected var theme:CustomTheme;
		/**コントローラー*/
		private var m_manager:MainController = null;
		//パレット
		private var m_pallet:Pallet = null;
		//パレットスライダー
		private var m_canvasSliderX:Slider = null;
		private var m_canvasSliderY:Slider = null;
		
		/**出撃エリアウィンドウ*/
		private var m_launchWindow:CreateAreaWindow = null;
		
		
		//パレット選択
		//private var m_palletSelecter:PalletSelecter = null;
		/**暗幕*/
		private var m_darkField:Image = null;
		//タイル移動幅
		private var m_tileConfig:TileConfig = null;
		
		/**チップローダー*/
		private var m_tipLoader:TipLoader = null;
		/**マップローダー*/
		private var m_mapLoader:MapLoader = null;
		/**オープンポップアップ*/
		private var m_startWindow:StartWindow = null;
		//キャンバス
		private var m_canvas:MapCanvas = null;
		/**ベースエリア*/
		private var m_baseArea:Sprite = null;
		/**ヘッダエリア*/
		private var m_header:Header = null;
		
		private var m_mapSizeWindow:SizeChangeWindow = null;
		
		/**コンストラクタ*/
		public function MainViewer()
		{
			
			INFO = SharedObject.getLocal("NeoSrcMapInfo");
			SCENARIO_PATH = INFO.data.scenarioPath;
			if (SCENARIO_PATH == null || SCENARIO_PATH.length <= 0)
			{
				SCENARIO_PATH = File.applicationDirectory.resolvePath("map\\img").nativePath;
			}
			
			UserImage.$.initAssetManager();
			UserImage.$.makeSystemAtlas();
			
			//カスタムテーマ設定
			this.theme = new CustomTheme();
			UserImage.$.init();
			super();
			m_startWindow = new StartWindow();
			m_darkField = new Image(Texture.fromBitmap(new Bitmap(new BitmapData(CommonDef.WINDOW_W, CommonDef.WINDOW_H, true, 0xAA444444))));
			m_tipLoader = new TipLoader();
			m_mapLoader = new MapLoader();
			m_tileConfig = new TileConfig();
			
			//マネージャー起動
			m_manager = new MainController(this);
			//ツール初期化
			TextTex.init();
			
			//パーツ初期化
			m_pallet = new Pallet();
			
			m_canvas = new MapCanvas();
			m_canvas.y = 32;
			m_pallet.x = m_pallet.width / 2;
			m_pallet.y = CommonDef.WINDOW_H - 192;
			
			m_launchWindow = new CreateAreaWindow();
			m_launchWindow.x = m_launchWindow.width / 2;
			m_launchWindow.y = CommonDef.WINDOW_H - 192;
			m_launchWindow.visible = false;
			
			//m_palletSelecter.x = Def.WINDOW_W - 134;
			//m_palletSelecter.y = 32;
			m_header = new Header();
			addChild(m_canvas);
			addChild(m_pallet);
			addChild(m_launchWindow);
			addChild(m_header);
			addChild(m_darkField);
			m_darkField.visible = false;
			
			m_tileConfig.x = 32;
			m_tileConfig.y = 64;
			addChild(m_tileConfig);
			m_tileConfig.visible = false;
			
			waitDark(true);
			m_startWindow.x = (CommonDef.WINDOW_W - m_startWindow.width) / 2;
			m_startWindow.y = (CommonDef.WINDOW_H - m_startWindow.height) / 2;
			this.addChild(m_startWindow);
			
			m_pallet.pivotX = m_pallet.width / 2;
			m_pallet.pivotY = m_pallet.height / 2;
			
			m_pallet.back.name = "normalBack";
			m_pallet.selecter.back.name = "selectBack";
			m_pallet.terrainStateWindow.back.name = "selectBack";
			//m_pallet.terrainSelecter.back.name = "selectBack";
			
			m_pallet.back.addEventListener(TouchEvent.TOUCH, mouseOperated);
			m_pallet.selecter.back.addEventListener(TouchEvent.TOUCH, mouseOperated);
			m_pallet.terrainStateWindow.back.addEventListener(TouchEvent.TOUCH, mouseOperated);
			
			m_launchWindow.back.addEventListener(TouchEvent.TOUCH, mouseOperated);
			//m_pallet.terrainSelecter.back.addEventListener(TouchEvent.TOUCH, mouseOperated);
			
			//m_palletSelecter.pivotX = m_palletSelecter.width / 2;
			//m_palletSelecter.pivotY = m_palletSelecter.height / 2;
			//m_palletSelecter.back.addEventListener(TouchEvent.TOUCH, mouseOperated);
			
			//m_pallet.x = m_pallet.width / 2;
			//m_pallet.y = CommonDef.WINDOW_H - 120;
			
			//m_palletSelecter.x = Def.WINDOW_W - m_palletSelecter.width / 2;
			//m_palletSelecter.y = Def.WINDOW_H - m_palletSelecter.height / 2;
			
			m_canvasSliderX = new Slider();
			m_canvasSliderY = new Slider();
			
			//_slider.visible = false;
			m_canvasSliderX.direction = Slider.DIRECTION_HORIZONTAL;
			m_canvasSliderX.x = 0;
			m_canvasSliderX.y = CommonDef.WINDOW_H - 16;
			m_canvasSliderX.width = CommonDef.WINDOW_W - 64;
			m_canvasSliderX.height = 16;
			
			m_canvasSliderX.step = 1;
			m_canvasSliderX.minimum = 0;
			m_canvasSliderX.maximum = 320;
			m_canvasSliderX.value = 0;
			m_canvasSliderX.addEventListener(Event.CHANGE, changeSlider);
			m_canvasSliderX.visible = false;
			m_canvasSliderX.thumbProperties.width = 32;
			m_canvasSliderX.thumbProperties.height = 16;
			addChild(m_canvasSliderX);
			
			m_canvasSliderY.direction = Slider.DIRECTION_VERTICAL;
			m_canvasSliderY.x = CommonDef.WINDOW_W - 16;
			m_canvasSliderY.y = 32;
			m_canvasSliderY.width = 16;
			m_canvasSliderY.height = CommonDef.WINDOW_H - 64;
			
			m_canvasSliderY.step = 1;
			m_canvasSliderY.minimum = -320;
			m_canvasSliderY.maximum = 32;
			m_canvasSliderY.value = 32;
			m_canvasSliderY.addEventListener(Event.CHANGE, changeSlider);
			m_canvasSliderY.visible = false;
			m_canvasSliderY.thumbProperties.width = 16;
			m_canvasSliderY.thumbProperties.height = 32;
			addChild(m_canvasSliderY);
		}
		
		
		//別ウィンドウパレット乗せ
		private var _nwindow:NativeWindow;
		private var _secondStarling:Starling;
		
		
		public function openPallet(e:Event = null):void
		{
			_secondStarling = new Starling(Sprite, _nwindow.stage);
			_secondStarling.start();
			_secondStarling.addEventListener(Event.ROOT_CREATED, _onPrimaryStarlingReady);
			//_secondStarling.addEventListener(Event.ROOT_CREATED, _onPrimaryStarlingReady);
				
		}
		
		public function _onPrimaryStarlingReady(e:Event):void
		{
			
			_secondStarling.removeEventListener(Event.ROOT_CREATED, _onPrimaryStarlingReady);
			// Add the 'one' icon to the primary stage
			var sl:Starling = (e.currentTarget as Starling);
			sl.stage.addChild(m_pallet);
			m_pallet.x = 0;
			m_pallet.y = 0;
			_secondStarling.stage.addChild(m_pallet);
			//sl.stage.addChild(getImage(OneBitmap));
			
			// This next line is key. If you try to setup the secondary 
			// Starling instance right away, you might crash or generate a 
			// Starling error [see for yourself by calling startSecondary() 
			// right away]. That's why it is being delayed a bit.
			//Starling.current.juggler.delayCall(startSecondary, 1.5);
			//			startSecondary();
		
		}
		
		
		/**スライダー変更*/
		private function changeSlider(e:Event):void
		{
			m_canvas.x = -m_canvasSliderX.value;
			m_canvas.y = m_canvasSliderY.value;
		}
		
		private function mouseOperated(eventObject:TouchEvent):void
		{
			var target:DisplayObject = eventObject.currentTarget as DisplayObject;
			if (target.name === "normalBack")
			{
				target = target.parent;
			}
			else if (target.name === "selectBack")
			{
				target = target.parent.parent;
			}
			
			var myTouch:Touch = eventObject.getTouch(target, TouchPhase.MOVED);
			if (myTouch)
			{
				var nMoveX:Number = myTouch.globalX - myTouch.previousGlobalX;
				var nMoveY:Number = myTouch.globalY - myTouch.previousGlobalY;
				target.x += nMoveX;
				target.y += nMoveY;
			}
		}
		
		public function start():void
		{
		
		}
		
		/**新規作成*/
		public function newCreate():void
		{
			m_tipLoader.tipListSet(0);
			setMapCenter();
		}
		
		/**パレット可視化*/
		public function showPallet():void
		{
			m_launchWindow.showImgList(false);
			m_launchWindow.visible = false;
			
			if (!m_pallet.visible)
			{
				m_pallet.x = m_pallet.width / 2;
				m_pallet.y = CommonDef.WINDOW_H - 192;
			}
			
			m_pallet.visible = !m_pallet.visible;
		}
		
		
		/**出撃配置ウィンドウセット*/
		public function showLaunchWindow():void
		{
			m_pallet.visible = false;
			
			
			if (!m_launchWindow.visible)
			{
				m_launchWindow.x = m_pallet.width / 2;
				m_launchWindow.y = CommonDef.WINDOW_H - m_launchWindow.height;
			}
			m_launchWindow.visible = !m_launchWindow.visible;
			m_launchWindow.showImgList(m_launchWindow.visible);
		}
		
		
		/**チップ選択セット*/
		public function setSelecter(type:int):void
		{
			m_tipLoader.tipListSet(type);
		}
		
		
		
		/**オートタイルチップ選択セット*/
		public function setSelecterFilter(type:int, filter:String):void
		{
			m_tipLoader.tipListFilterSet(type, filter);
		}
		
		
		/**タイルチップ選択セット*/
		public function tileFilter(filter:String):void
		{
			m_tipLoader.filterloadStart("tile", filter);
		}
		
		
		
		public function setMapCenter():void
		{
			if (m_canvas != null)
			{
				if ((m_canvas.mapWidth * 32) < CommonDef.WINDOW_W)
				{
					m_canvas.x = (CommonDef.WINDOW_W - m_canvas.mapWidth * 32) / 2;
				}
				else
				{
					m_canvas.x = 0;
				}
				
				m_canvas.y = 32;
				/*
				   if (m_canvas.height < Def.WINDOW_H)
				   {
				   m_canvas.y = (Def.WINDOW_H - m_canvas.height) / 2;
				   }
				   else
				   {
				   m_canvas.y = 0;
				   }
				 */
			}
		}
		
		public function get pallet():Pallet
		{
			return m_pallet;
		}
		
		public function get canvas():MapCanvas
		{
			return m_canvas;
		}
		
		public function get tileConfig():TileConfig
		{
			return m_tileConfig;
		}
		
		public function get header():Header
		{
			return m_header;
		}
		
		public function get isLaunchWindow():Boolean
		{
			return m_launchWindow.visible;
		}
		
		public function get launchWindow():CreateAreaWindow 
		{
			return m_launchWindow;
		}
		
		public function get mapLoader():MapLoader
		{
			return m_mapLoader;
		}
		
		public function setSlider():void
		{
			if (m_canvas.mapWidth * 32 > CommonDef.WINDOW_W)
			{
				m_canvasSliderX.visible = true;
				m_canvasSliderX.minimum = 0;
				m_canvasSliderX.maximum = -(CommonDef.WINDOW_W - m_canvas.mapWidth * 32 - 32);
			}
			if (m_canvas.mapHeight * 32 > CommonDef.WINDOW_H)
			{
				m_canvasSliderY.visible = true;
				m_canvasSliderY.minimum = CommonDef.WINDOW_H - m_canvas.mapHeight * 32 - 32;
				m_canvasSliderY.maximum = 32;
			}
		
		}
		
		/**初期画面終了*/
		public function endStartWindow():void
		{
			if (m_startWindow != null)
			{
				removeChild(m_startWindow);
				m_startWindow.dispose();
				m_startWindow = null;
			}
			waitDark(false);
			newCreate();
			setSlider();
		}
		
		public function startSizeWindow():void
		{
			waitDark(true);
			m_mapSizeWindow = new SizeChangeWindow();
			m_mapSizeWindow.x = (CommonDef.WINDOW_W - m_mapSizeWindow.width) / 2;
			m_mapSizeWindow.y = (CommonDef.WINDOW_H - m_mapSizeWindow.height) / 2;
			addChild(m_mapSizeWindow)
		}
		
		/**初期画面終了*/
		public function endSizeWindow(flg:Boolean, wid:int = 0, hgt:int = 0):void
		{
			if (m_mapSizeWindow != null)
			{
				removeChild(m_mapSizeWindow);
				m_mapSizeWindow.dispose();
				m_mapSizeWindow = null;
			}
			waitDark(false);
			if (flg)
			{
				m_canvas.changeMapSize(wid, hgt);
			}
			setSlider();
		}
		
		/**暗幕設置*/
		public function waitDark(flg:Boolean):void
		{
			if (flg)
			{
				this.setChildIndex(m_darkField, this.numChildren - 1);
				m_darkField.visible = true;
			}
			else
			{
				m_darkField.visible = false;
			}
		}
	
	}
}