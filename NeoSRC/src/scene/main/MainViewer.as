package scene.main
{
	import a24.tween.Tween24;
	import bgm.SingleMusic;
	import common.CommonDef;
	import common.CommonSystem;
	import common.SystemController;
	import common.util.CharaDataUtil;
	import system.custom.customSprite.CButton;
	import system.custom.customSprite.CImage;
	import system.custom.customTheme.CustomTheme;
	import database.user.UnitCharaData;
	import database.user.buff.SkillBuffData;
	import flash.display.StageQuality;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import system.InitialLoader;
	import system.file.DataLoad;
	import scene.commandbattle.CommandBattleView;
	import scene.intermission.InterMission;
	import scene.intermission.save.LoadList;
	import scene.map.BaseMap;
	import scene.map.BattleMap;
	import scene.map.panel.BattleMapPanel;
	import scene.map.customdata.SideState;
	import scene.unit.BattleUnit;
	import viewitem.parts.loading.LoadingImg;
	import viewitem.parts.pc.StartWindowPC;
	import viewitem.parts.phone.StartWindowPhone;
	import scene.talk.IconTalkView;
	import scene.talk.StandTalkView;
	import scene.talk.TalkViewBase;
	import scene.talk.classdata.MapEventData;
	import scene.talk.message.SystemWindow;
	
	/**
	 * ...
	 * @author
	 */
	public class MainViewer extends Sprite
	{
		
		/**カスタムテーマ*/
		protected var theme:CustomTheme;
		/**コントローラー*/
		private var _manager:MainController = null;
		/**暗幕*/
		private var _darkField:LoadingImg = null;
		//キャンバス
		private var _battleMap:BattleMap = null;
		/**ベースエリア*/
		private var _baseArea:Sprite = null;
		/**マップ移動コマ*/
		private var _mapComa:DisplayObject = null;
		/**Eveマネージャー*/
		private var _eveManager:TalkViewBase = null;
		/**キャラデータローダー*/
		//private var _charaImgLoader:CharaImgDataLoader = null;
		/**開始シナリオ*/
		//private var _firstEve:String = null;
		/**終了ボタン*/
		private var _btnExit:CButton = null;
		
		/**インターミッションウィンドウ*/
		private var _interMission:InterMission = null;
		/**ロード画面*/
		private var _loadListWindow:LoadList = null;
		
		/**コマンドバトルビュー*/
		private var _commandBattlePanel:CommandBattleView = null;
		
		/**メインビューコンストラクタ*/
		public function MainViewer()
		{
			//カスタムテーマ設定
			this.theme = new CustomTheme();
			
			super();
			//マネージャー起動
			_manager = new MainController(this);
		}
		
		public var debugText:SystemWindow;
		
		//-----------------------------------------------------------------
		//
		// 開始処理
		//
		//-----------------------------------------------------------------
		
		/**コントローラー読み込み終了後*/
		public function start():void
		{
			_darkField = new LoadingImg();
			_darkField.visible = false;
			debugText = new SystemWindow();
			debugText.x = 100;
			debugText.y = 300;
			Starling.current.antiAliasing = 0;
			Starling.current.nativeStage.quality = StageQuality.LOW;
			CONFIG::pc
			{
				//PC用
				var startWindow:StartWindowPC = new StartWindowPC(InitialLoader.$.loadAssetStart);
			}
			
			CONFIG::phone
			{
				//スマホ用
				var startWindow:StartWindowPhone = new StartWindowPhone(InitialLoader.$.loadAssetStart);
			}
			
			//startWindow.x = 100;
			//startWindow.y = 100;
			
			addContent(startWindow);
		}
		
		public function addContent(disp:DisplayObject):void
		{
			super.addChild(disp);
			
			CONFIG::phone
			{
				if (_btnExit != null)
				{
					//addChild(_btnExit);
				}
			}
			//addChild(debugText);
		
		}
		
		public function addContentNum(disp:DisplayObject, num:int):void
		{
			super.addChildAt(disp, num);
			
			CONFIG::phone
			{
				if (_btnExit != null)
				{
					//addChild(_btnExit);
				}
			}
			//addChild(debugText);		
		}
		
		//終了ボタンセット
		public function exitBtnSet():void
		{
			_btnExit = new CButton();
			_btnExit.x = 24;
			_btnExit.y = 24;
			//_btnExit.addEventListener(Event.TRIGGERED, CommonSystem.finishAPK);
			_btnExit.label = "Exit";
			waitDark(true);
		}
		
		//-----------------------------------------------------------------
		//
		// RPGコマンドバトル（未実装）
		//
		//-----------------------------------------------------------------
		/** コマンドバトルパネル設置 */
		public function setCommandBattlePanel(player:Vector.<String>, enemy:Vector.<String>):void
		{
			_commandBattlePanel = new CommandBattleView(player, enemy);
			addContent(_commandBattlePanel);
		}
		
		//-----------------------------------------------------------------
		//
		// マップデータ読み込み
		//
		//-----------------------------------------------------------------
		
		// マップデータロード
		public function loadMapData(str:String, callBack:Function = null, continueFlg:Boolean = false):void
		{
			if (_battleMap != null)
			{
				_battleMap.dispose();
				_battleMap = null;
				
			}
			
			//マップキャンバス作成
			_battleMap = new BattleMap();
			_battleMap.alpha = 0;
			
			//waitDark(true);
			if (str == null || str.length <= 0)
			{
				_battleMap.setTipArea(0, 0);
				_battleMap.setDrag(false);
				_battleMap.visible = false;
				return;
			}
			
			//マップキャンバス作成
			_battleMap.alpha = 0;
			_battleMap.visible = false;
			_darkField.visible = false;
			//addContent(_darkField);
			if (!continueFlg)
			{
				addContent(_battleMap);
				addContent(_eveManager);
			}
			//暗幕を開く（Loading）
			waitDark(true);
			//マップ読み込み
			
			//_battleMap.setTipArea(_battleMap.mapWidth, _battleMap.mapHeight);
			MainController.$.model.mapLoad(str, compLoadMap);
			
			function compLoadMap():void
			{
				_battleMap.pivotX = _battleMap.width / 2;
				_battleMap.pivotY = _battleMap.height / 2;
				_battleMap.x = _battleMap.width / 2;
				_battleMap.y = _battleMap.height / 2;
				_battleMap.setBattleMapPanel();
				_battleMap.mapPanel.showPanel(BattleMapPanel.PANEL_NONE);
				_battleMap.setDrag();
				//_battleMap.visible = true;
				
				//waitDark(false);
				if (callBack != null)
				{
					callBack();
				}
			}
		}
		
		//-----------------------------------------------------------------
		//
		// 画像読み込み後、ニューゲームORデータロード
		//
		//-----------------------------------------------------------------
		public function loadImgComp():void
		{
			_loadListWindow = new LoadList(loadListComp);
		}
		
		/**ロードリスト読み込み完了*/
		private function loadListComp(flg:Boolean):void
		{
			//waitDark(true);
			Tween24.wait(0.3).onComplete(compWait).play();
			
			function compWait():void
			{
				waitDark(false);
				if (flg)
				{
					addContent(_loadListWindow);
				}
				else
				{
					if (_loadListWindow != null)
					{
						_loadListWindow.dispose();
					}
					_loadListWindow = null;
					loadEve(CommonSystem.START_EVE, "スタート");
				}
			}
		}
		
		public function returnLoadSaveData(data:Object):Function
		{
			return function():void
			{
				loadSaveData(data);
			}
		}
		
		/**ニューゲーム押し後*/
		public function pushNewGameBtn(e:Event):void
		{
			removeChild(_loadListWindow);
			_loadListWindow.dispose();
			_loadListWindow = null;
			loadEve(CommonSystem.START_EVE, "スタート");
		}
		
		/**コンティニュー押し後*/
		public function pushContinueBtn(e:Event):void
		{
			
			removeChild(_loadListWindow);
			_loadListWindow.dispose();
			_loadListWindow = null;
			var continueName:String = CommonSystem.SAVE_NAME.replace("{0}", "中断データ");
			DataLoad.loadMapSaveData();
		
		}
		
		/**コンティニュー押し後*/
		public function loadContinueComp(dataStr:String):void
		{
			if (dataStr != null)
			{
				var data:Object = JSON.parse(dataStr);
				
				var i:int = 0;
				//基本データ読み込み
				MainController.$.model.playerParam.loadObject(data.playerData);
				var count:int = CommonDef.objectLength(data.unitList);
				//今のデータ削除
				resetWindow();
				MainController.$.model.resetUnitDate();
				
				//所持ユニットデータ
				for (i = 0; i < count; i++)
				{
					MainController.$.model.addPlayerUnitFromName(data.unitList[i].name, data.unitList[i].lv, data.unitList[i].exp, data.unitList[i].strengthPoint, false, data.unitList[i].customBgmPath);
				}
				
				//会話・マップデータ読み込み
				
				//EVEマネージャー
				if (CommonSystem.TALK_TYPE === "stand")
				{
					_eveManager = new StandTalkView();
				}
				else if (CommonSystem.TALK_TYPE === "icon")
				{
					_eveManager = new IconTalkView();
				}
				loadMapData(data.mapPath, returnMapComp(data), true);
			}
			else
			{
				loadEve(CommonSystem.START_EVE, "スタート");
			}
		}
		
		public function returnMapComp(data:Object):Function
		{
			return function():void
			{
				loadMapComp(data);
			}
		}
		
		public function loadMapComp(data:Object):void
		{
			var i:int = 0;
			var j:int = 0;
			//マップユニット読み込み
			for (i = 0; i < CommonDef.objectLength(data.mapDateList); i++)
			{
				
				MainController.$.map.sideState[i] = new SideState(data.mapDateList[i].name);
				MainController.$.map.sideState[i].state = data.mapDateList[i].state;
				
				for (j = 0; j < CommonDef.objectLength(data.mapDateList[i].unitDate); j++)
				{
					var unitData:Object = data.mapDateList[i].unitDate[j];
					// 戦闘ユニット作成
					var battleUnit:BattleUnit = null;
					
					battleUnit = new BattleUnit(new UnitCharaData(unitData.id, CharaDataUtil.getMasterCharaDataName(unitData.name), unitData.lv), unitData.battleId, i);
					battleUnit.setStrength(unitData.strengthPoint);
					
					if (unitData.buffList != null)
					{
						var k:int = 0;
						for (k = 0; k < unitData.buffList.length; k++)
						{
							var skillBuff:SkillBuffData = new SkillBuffData();
							
							skillBuff.setObjData(unitData.buffList[k]);
							
							battleUnit.buffList.push(skillBuff);
						}
					}
					
					battleUnit.levelSet(unitData.lv);
					battleUnit.setExp(unitData.exp);
					battleUnit.alive = unitData.alive;
					battleUnit.onMap = unitData.onMap;
					battleUnit.launched = unitData.launched;
					battleUnit.moveState = unitData.moveState;
					battleUnit.commandType = unitData.commandType;
					battleUnit.moveCount = unitData.moveCount;
					
					battleUnit.setMoveColor();
					
					battleUnit.setNowPoint(unitData.HP, unitData.FP, unitData.TP);
					
					_battleMap.setLaunchCheck(battleUnit, unitData.posX, unitData.posY);
					var posX:int = battleUnit.PosX;
					var posY:int = battleUnit.PosY;
					// 画像とフレームの位置を追加
					battleUnit.unitImg.x = (posX - 1) * BaseMap.MAP_SIZE;
					battleUnit.unitImg.y = (posY - 1) * BaseMap.MAP_SIZE;
					battleUnit.unitImg.alpha = 1;
					battleUnit.unitImg.visible = true;
					
					if (i == 0)
					{
						var joinFlg:Boolean = true;
						if (unitData.hasOwnProperty("join"))
						{
							joinFlg = unitData.joinFlg;
						}
						
						// 戦闘ユニットデータの設定
						battleUnit.joinFlg = joinFlg;
						battleUnit.frameImg = new CImage(MainController.$.imgAsset.getTexture("frame_b"));
					}
					else
					{
						battleUnit.frameImg = new CImage(MainController.$.imgAsset.getTexture("frame_r"));
					}
					
					battleUnit.frameImg.x = (posX - 1) * BaseMap.MAP_SIZE;
					battleUnit.frameImg.y = (posY - 1) * BaseMap.MAP_SIZE;
					battleUnit.frameImg.alpha = 1;
					battleUnit.frameImg.visible = true;
					
					// 戦闘ユニットを勢力に追加
					_battleMap.sideState[i].addUnit(battleUnit);
					if (battleUnit.onMap)
					{
						// ユニットエリアに画像追加
						_battleMap.unitArea.addChildAt(battleUnit.unitImg, _battleMap.unitArea.numChildren);
						// フレームエリアに沸く追加
						_battleMap.frameArea.addChildAt(battleUnit.frameImg, _battleMap.frameArea.numChildren);
					}
				}
			}
			
			//イベントリスト読み込み
			for (i = 0; i < CommonDef.objectLength(data.mapEventList); i++)
			{
				var mapEvent:MapEventData = new MapEventData();
				mapEvent.loadParam(data.mapEventList[i].label, data.mapEventList[i].param, data.mapEventList[i].type);
				_eveManager.eventList.push(mapEvent);
			}
			
			addContent(_battleMap);
			addContent(_eveManager);
			_battleMap.setBattleMapPanel();
			var bgmData:Object = new Object();
			bgmData.file = data.playerData.playingMapBGM;
			if (bgmData.file != "")
			{
				SingleMusic.playBGMData(bgmData);
			}
			loadContinueEve(data.playerData.nowEve);
		}
		
		/**ロードボタン押し後*/
		public function loadSaveData(data:Object):void
		{
			
			var i:int = 0;
			
			MainController.$.model.playerParam.loadObject(data.playerData);
			
			var count:int = CommonDef.objectLength(data.unitList);
			
			for (i = 0; i < count; i++)
			{
				MainController.$.model.addPlayerUnitFromName(data.unitList[i].name, data.unitList[i].lv, data.unitList[i].exp, data.unitList[i].strengthPoint, false, data.unitList[i].customBgmPath);
			}
			
			removeChild(_loadListWindow);
			_loadListWindow.dispose();
			_loadListWindow = null;
			
			_interMission = new InterMission();
			addContent(_interMission);
		}
		
		//-----------------------------------------------------------------
		//
		// スタートEveファイル読み込み
		//
		//-----------------------------------------------------------------
		// 初期イベントファイル読み込み
		public function loadEve(eveName:String, startLabel:String):void
		{
			SystemController.$.view.removeWebView();
			
			if (_interMission != null)
			{
				//removeChild(_interMission);
				_interMission.dispose();
				_interMission = null;
			}
			
			//EVEマネージャー
			if (CommonSystem.TALK_TYPE === "stand")
			{
				_eveManager = new StandTalkView();
			}
			else if (CommonSystem.TALK_TYPE === "icon")
			{
				_eveManager = new IconTalkView();
			}
			
			debugText.addText(eveName);
			_eveManager.eveStart(eveName, startLabel);
			//EVEマネージャー追加
			addContent(_eveManager);
		}
		
		// 中断イベントファイル読み込み
		public function loadContinueEve(eveName:String):void
		{
			SystemController.$.view.removeWebView();
			
			if (_interMission != null)
			{
				//removeChild(_interMission);
				_interMission.dispose();
				_interMission = null;
			}
			
			debugText.addText(eveName);
			_eveManager.eveContinueStart(eveName);
			//EVEマネージャー追加
			addContent(_eveManager);
			//waitDark(false);
		}
		
		//-----------------------------------------------------------------
		//
		// スタートEveファイル読み込み
		//
		//-----------------------------------------------------------------
		// 初期イベントファイル読み込み
		
		//-----------------------------------------------------------------
		//
		// インターミッション呼び出し
		//
		//-----------------------------------------------------------------
		
		public function callInterMission(nextEve:String):void
		{
			//画面初期化
			resetWindow();
			if (nextEve != null)
			{
				if (nextEve.indexOf(".") <= 0 && nextEve != "未設定")
				{
					nextEve += ".srceve";
				}
				
				MainController.$.model.playerParam.clearEve = MainController.$.model.playerParam.nextEve;
				MainController.$.model.playerParam.nextEve = nextEve;
			}
			
			MainController.$.model.playerParam.refreshVariable();
			
			_interMission = new InterMission();
			
			addContent(_interMission);
		
		}
		
		//画面初期化
		public function resetWindow():void
		{
			SingleMusic.endBGM(0.3);
			removeChild(_eveManager);
			if (_eveManager != null)
			{
				_eveManager.dispose();
				_eveManager = null;
			}
			
			if (_battleMap != null)
			{
				removeChild(_battleMap);
				_battleMap.dispose();
				_battleMap = null;
			}
		}
		
		//-----------------------------------------------------------------
		//
		// 戦闘マップ取得
		//
		//-----------------------------------------------------------------
		/**マップ取得*/
		public function get battleMap():BattleMap
		{
			return _battleMap;
		}
		
		//-----------------------------------------------------------------
		//
		// Eve制御
		//
		//-----------------------------------------------------------------
		public function get eveManager():TalkViewBase
		{
			return _eveManager;
		}
		
		public function get darkField():LoadingImg 
		{
			return _darkField;
		}
		
		public function get interMission():InterMission
		{
			return _interMission;
		}
		
		/**初期画面終了*/
		public function showBattleMap(callBack:Function = null):void
		{
			waitDark(false);
			//Tween24.tween(_battleMap, 1.0, null).fadeIn().onComplete(nextAct).play();
			Tween24.wait(1.0).onComplete(nextAct).play();
			
			function nextAct():void
			{
				//removeChild(_eveManager);
				//_battleMap.setBattleMapPanel();
				if (callBack != null)
				{
					callBack();
				}
			}
		}
		
		/**暗幕設置*/
		public function waitDark(flg:Boolean):void
		{
			if (flg)
			{
				//this.setChildIndex(_darkField, this.numChildren - 1);
				addChild(_darkField);
				_darkField.visible = true;
			}
			else
			{
				removeChild(_darkField);
				_darkField.visible = false;
			}
		}
		
		/**デバッグメッセージ*/
		public function debugMessage(msg:String):void
		{
			debugText.addText(msg);
		}
		
		/**エラーメッセージ*/
		public function errorMessageEve(msg:String, line:int):void
		{
			trace(line + "行目:" + msg);
		}
		
		/**警告メッセージ*/
		public function alertMessage(msg:String, key:String):void
		{
			trace(msg + ":" + key);
		}
	
	}
}