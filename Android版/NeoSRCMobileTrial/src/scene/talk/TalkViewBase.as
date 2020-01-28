package scene.talk
{
	import a24.tween.Tween24;
	import bgm.SingleMusic;
	import common.CalcInfix;
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CSprite;
	import system.custom.customSprite.CTextArea;
	import database.dataloader.MessageLoader;
	import database.user.FaceData;
	import flash.desktop.NativeApplication;
	import flash.filesystem.File;
	import flash.utils.Timer;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import system.file.DataLoad;
	import scene.main.MainController;
	import scene.map.panel.BattleMapPanel;
	import scene.unit.BattleUnit;
	import scene.intermission.customdata.PlayerVariable;
	import scene.talk.classdata.IfSearch;
	import scene.talk.classdata.MapEventData;
	import scene.talk.classdata.SelectCommandData;
	import scene.talk.common.ImgDef;
	import scene.talk.common.MsgDef;
	import scene.talk.message.TelopWindow;
	import scene.talk.window.SelectWindow;
	import system.viewobject.extensions.PDParticleSystem;
	import system.viewobject.extensions.ParticleSystem;
	
	/**
	 * ...
	 * @author
	 */
	public class TalkViewBase extends CSprite
	{
		//-----------------------------------------------------------------
		// const
		//-----------------------------------------------------------------
		public static const TALK_NONE:int = 0;
		public static const TALK_MSG:int = 1;
		public static const TALK_TELOP:int = 2;
		
		//コメント読み込み時間
		protected const LINE_READ_TIME:Number = 16.6;
		//スキップ時間ミリ秒
		protected const SKIP_TIME:Number = 1000;
		
		// タッチイベント制御、会話
		public static const TOUCH_TALK:int = 1;
		// タッチイベント制御、選択肢
		public static const TOUCH_SELECT:int = 2;
		// タッチイベント制御、マップ・アイテム
		public static const TOUCH_MAP:int = 3;
		
		/**置き換え式*/
		public static const REPLACE_ARY:Array = ["math", "unit", "name", "variable", "sidenum"];
		public static const REPLACE_P_ARY:Array = ["式", "ユニット", "ユニット名", "変数", "陣営数"];
		
		//-----------------------------------------------------------------
		// value
		//-----------------------------------------------------------------
		
		/**開始ラベル*/
		protected var _startLabel:String = null;
		
		/**会話モード*/
		protected var _talkMode:int = 0;
		
		/**会話読み込み行*/
		protected var _loadLine:int = 0;
		/**テキストデータ*/
		protected var _textData:Array = null;
		/**ラベルデータ*/
		protected var _labelData:Array = null;
		
		/**入力中メッセージ*/
		protected var _msgStrage:String = null;
		/**入力中サブメッセージ*/
		protected var _msgSubStorage:String = null;
		/**メッセージ読み込み中フラグ*/
		protected var _msgFlg:Boolean = false;
		/**オブジェクト移動フラグ*/
		protected var _moveFlg:Boolean = false;
		/**空行カウント*/
		protected var blunkCount:int = 0;
		/**メッセージクリアフラグ*/
		protected var _msgClearFlg:Boolean = false;
		/** 発言者変更フラグ */
		protected var _talkChangeFlg:Boolean = false;
		/** 選択中ターゲットレイヤー */
		protected var _selectLayer:int = 0;
		/** ツイーン番号 */
		protected var _tweenNum:int = 0;
		/** タッチ可能フラグ */
		protected var _noTouch:Boolean = false;
		/**分岐検索フラグ*/
		protected var _ifSearch:Vector.<IfSearch> = null;
		/**分岐中カウント*/
		protected var _ifCount:int = 0;
		/**コール元行数*/
		protected var _callBaseLine:Vector.<int> = null;
		/**スイッチ値*/
		protected var _switchValue:Array = null;
		/**スキップフラグ*/
		protected var _skipFlg:Boolean = false;
		/**スキップタイマー*/
		protected var _skipTimer:Timer = null;
		
		/**メッセージウィンドウクローズフラグ*/
		protected var _msgCloseFlg:Boolean = false;
		/**テロップ次の位置*/
		protected var _talkNextPos:int = 0;
		
		//-----------------------------------------------------------------
		// processor
		//-----------------------------------------------------------------
		/**移動処理トゥイーン*/
		protected var _tween:Vector.<Tween24> = null;
		protected var _tweenAry:Array = null;
		/** メッセージタイマー */
		protected var _msgTimer:Timer = null;
		
		//-----------------------------------------------------------------
		// component
		//-----------------------------------------------------------------
		/**表示物*/
		protected var _displayObject:Vector.<DisplayObject> = null;
		/**喋りキャラ位置*/
		protected var _talkArea:CSprite = null;
		/** レイヤー */
		protected var _layer:Vector.<CSprite> = null;
		/** タッチボタン */
		protected var _touchBtn:CImage = null;
		/**メッセージウィンドウ消去ボタン*/
		protected var _msgCloseBtn:CImage = null;
		/**最上段用配置レイヤー*/
		protected var _topLayer:CSprite = null;
		/**選択肢ウィンドウ*/
		protected var _selectWindow:SelectWindow = null;
		/**パーティクルリスト*/
		protected var _pexList:Vector.<XML> = null;
		protected var _pexNameList:Vector.<String> = null;
		/**イベントリスト*/
		protected var _eventList:Vector.<MapEventData> = null;
		/**イベント終了時コールバック*/
		protected var _eventCallBack:Function = null;
		/**フラッシュ演出用*/
		protected var _flashImg:CImage = null;
		/**テロップウィンドウ*/
		protected var _telop:TelopWindow = null;
		
		/** ビデオ */
		//protected var _videoView:VideoView = null;
		
		/**
		 * コンストラクタ
		 *
		 */
		public function TalkViewBase()
		{
			var i:int = 0;
			super();
			_talkMode = TALK_MSG;
			_tween = new Vector.<Tween24>();
			_tweenAry = new Array();
			_layer = new Vector.<CSprite>;
			_layer[0] = new CSprite();
			_callBaseLine = new Vector.<int>;
			_ifSearch = new Vector.<IfSearch>;
			_switchValue = new Array();
			_selectLayer = 0;
			_displayObject = new Vector.<DisplayObject>;
			_talkArea = new CSprite();
			_talkArea.touchable = true;
			_pexList = new Vector.<XML>;
			_pexNameList = new Vector.<String>;
			_eventList = new Vector.<MapEventData>;
			_flashImg = new CImage(MainController.$.imgAsset.getTexture("tex_white"));
			_flashImg.width = CommonDef.WINDOW_W;
			_flashImg.height = CommonDef.WINDOW_H;
			_flashImg.visible = false;
			// レイヤーセット
			addChild(_layer[0]);
			addChild(_talkArea);
			this;
			_touchBtn = new CImage(MainController.$.imgAsset.getTexture("tex_white"));
			_touchBtn.alpha = 0;
			_touchBtn.addEventListener(TouchEvent.TOUCH, touchBtnHandler);
			_touchBtn.width = CommonDef.WINDOW_W;
			_touchBtn.height = CommonDef.WINDOW_H;
			addChild(_touchBtn);
			
			_talkArea.width = CommonDef.WINDOW_W;
			_talkArea.height = CommonDef.WINDOW_H;
		
			//背景
			//addEventListener(TouchEvent.TOUCH, clickHandler);
		}
		
		//-----------------------------------------------------------------
		//
		// 終了時処理
		//
		//-----------------------------------------------------------------
		
		override public function dispose():void
		{
			
			CommonDef.disposeList([ //
			_pexList, _pexNameList, //
			_tween, _tweenAry, _tweenNum, //
			_layer, _ifSearch, _eventList //
			]);
			
			if (_telop != null)
			{
				_telop.dispose();
				_telop = null;
			}
			
			if (_topLayer != null)
			{
				_topLayer.dispose();
			}
			
			if (_touchBtn != null)
			{
				_touchBtn.removeEventListener(Event.TRIGGERED, touchBtnHandler);
				_touchBtn.dispose();
				_touchBtn = null;
			}
			
			if (_selectWindow != null)
			{
				_selectWindow.dispose();
				_selectWindow = null;
			}
			
			_eventCallBack = null;
			
			if (_displayObject != null)
			{
				disposeImgList(_displayObject);
			}
			super.dispose();
		}
		
		/**リスト解放*/
		public function disposeImgList(list:Vector.<DisplayObject>):void
		{
			for (var i:int = 0; i < list.length; )
			{
				if (list[i] != null)
				{
					list[i].removeEventListener(TouchEvent.TOUCH, objectTouch);
					
					if (list[i].parent != null)
					{
						list[i].parent.removeChild(list[i]);
					}
					list[i].dispose();
					list[i] = null;
				}
				list.pop();
			}
			list = null;
		}
		
		//-----------------------------------------------------------------
		//
		// ファイル読み込み関連
		//
		//-----------------------------------------------------------------
		
		/**
		 * イベントファイル読み込み開始
		 * @param filename 読み込みEveファイル名
		 * */
		public function eveStart(fileName:String, startLabel:String):void
		{
			MainController.$.model.playerParam.nowEve = fileName;
			_startLabel = startLabel;
			MessageLoader.loadEveData(fileName, setText);
		}
		
		public function eveContinueStart(fileName:String):void
		{
			MainController.$.model.playerParam.nowEve = fileName;
			MessageLoader.loadEveData(fileName, setContinueText);
		}
		
		/**イベントファイル読み込み完了*/
		protected function setText(ary:Array, label:Array):void
		{
			_textData = ary;
			_labelData = label;
			
			_loadLine = 0;
			
			selectTouchEvent(TOUCH_TALK);
			_loadLine = _labelData[_startLabel + ":"];
			_msgFlg = true;
			setLineCommand();
		}
		
		/**イベントファイル読み込み完了*/
		protected function setContinueText(ary:Array, label:Array):void
		{
			_textData = ary;
			_labelData = label;
			
			_loadLine = 0;
			
			clearIf();
			_skipTimer.stop();
			_skipTimer.reset();
			selectTouchEvent(TOUCH_MAP);
			
			if (MainController.$.view.battleMap != null && MainController.$.view.battleMap.mapPanel != null)
			{
				MainController.$.view.battleMap.mapPanel.showPanel(BattleMapPanel.PANEL_SYSTEM);
			}
		}
		
		/**Eveデータ追加分結合*/
		protected function addEveData(add:Array, label:Array):void
		{
			var base:Array = _textData;
			_textData = base.concat(add);
			setLineCommand();
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		//
		// 読み込みライン処理
		//
		//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		/**テキスト行数読み込み*/
		protected function setLineCommand():void
		{
			_noTouch = false;
			var line:String = _textData[_loadLine];
			_loadLine++;
			
			//追加インクルード
			if (line.substr(0, 1) === "#<" && line.substr(line.length - 1, 1) === ">")
			{
				//追加分のテキストをデータに追加
				MessageLoader.loadEveData(line.substring(1, line.length - 1), addEveData);
			}
			//ラベル
			else if (line.substr(line.length - 1, 1) === ":")
			{
				//何もせずに次を読み込む
				setLineCommand();
			}
			//その他
			else
			{
				if (line.indexOf("$") >= 0)
				{
					line = mathLineValue(line);
				}
				
				//文字列分割
				var command:Array = line.split(" ");
				//パラメーター
				var param:Object = EveParam.getParam(command);
				var commandName:String = command[0].toLowerCase();
				
				if (_ifCount > 0 || // 範囲外のIF文がある場合スキップ
				(_ifSearch.length > 0 && _ifSearch[0].end && commandName != "endif") || // 既に終了してる場合スキップ
				(_ifSearch.length > 0 && _ifSearch[0].start && commandName != "elseif" && commandName != "else" && commandName != "endif" && commandName != "case" && commandName != "default")) // 検索中の場合、該当分以外をスキップ
				{
					if ((commandName === "if" && command[command.length - 1] === "then") || commandName === "switch")
					{
						_ifCount++;
					}
					else if (commandName === "endif")
					{
						_ifCount--;
					}
					
					setLineCommand();
				}
				else
				{
					playCommand(line, command, param);
				}
				
			}
		}
		
		protected function playCommand(line:String, command:Array, param:Object):void
		{
			var i:int = 0;
			var eventData:MapEventData = null;
			//最初の文字列で分岐
			switch (command[0].toLowerCase())
			{
			//-----------------------------------------------------レイヤー-----------------------------------------------------
			case "addlayer": 
				//レイヤー追加
				addLayer(param);
				setLineCommand();
				break;
			case "selectlayer": 
				//レイヤー選択
				selectLayer(param);
				setLineCommand();
				break;
			case "deletelayer": 
				// レイヤー消去
				deleteLayer(param);
				setLineCommand();
				break;
			case "clearlayer": 
				clearLayer(param);
				setLineCommand();
				break;
			case "deletealllayer": 
				resetLayer();
				setLineCommand();
				break;
			//-----------------------------------------------------画面アイテム表示-----------------------------------------------------
			case "setimg": //画像セット
				loadImg(command, param);
				break;
			case "settext": 
				setTextImg(command, param);
				setLineCommand();
				break;
			case "setbutton": 
				setLineCommand();
				break;
			case "changetext": 
				changeText(command, param);
				setLineCommand();
				break;
			case "settextvalue": 
				setTextValue(command, param);
				setLineCommand();
				break;
			case "removeimg": 
			case "removeitem": //画像削除
			case "deleteimg": 
			case "deleteitem": 
				removeItem(command, param);
				break;
			case "setparticle": //パーティクルセット
				loadParticle(command, param);
				break;
			case "setmovie": //動画セット
				break;
			case "alllayer": 
				allLayer(command, param);
				break;
			case "deleteallitem": 
				resetDisplayObject();
				setLineCommand();
				break;
			case "flash": 
				flashWindow(command, param);
				break;
			//-----------------------------------------------------リセット-----------------------------------------------------
			case "allreset": 
				resetAll();
				break;
			//-----------------------------------------------------表示・移動-----------------------------------------------------
			case "show": //オブジェクトを表示
				showItemFunc(command, param);
				break;
			case "hide": //オブジェクトを非表示
				hideItemFunc(command, param);
				break;
			case "readymove": //移動準備
				readyMoveFunc(command, param);
				break;
			case "setmove": //移動アイテムセット
				setMoveFunc(command, param);
				setLineCommand();
				break;
			case "startmove": //移動開始
				startMoveFunc(command, param);
				break;
			//-----------------------------------------------------イベント追加------------------------------------------------
			case "settouchevent": 
				setClickEvent(command, param);
				setLineCommand();
				break;
			//-----------------------------------------------------変数セット-------------------------------------------------
			case "set": //変数設定 
				setVariable(command, param);
				setLineCommand();
				break;
			case "pushlist": //変数リスト設定
				pushVariable(command, param);
				setLineCommand();
				break;
			case "incr": //加算
				incrVariable(command, param);
				setLineCommand();
				break;
			//-----------------------------------------------------選択肢-------------------------------------------------------
			case "select": 
				selectCommand(command, param);
				break;
			//-----------------------------------------------------分岐-------------------------------------------------
			case "switch": 
				setSwitch(command, param);
				break;
			case "case": 
			case "default": 
				searchCase(command, param);
				break;
			case "break": 
				switchBreak();
				setLineCommand();
				break;
			case "if": 
				var thenStr:String = command[command.length - 1].toLowerCase();
				
				if (thenStr === "then")
				{
					var newSearch:IfSearch = new IfSearch();
					_ifSearch.unshift(newSearch);
				}
				
				searchIf(command, param);
				break;
			case "elseif": 
				if (_ifSearch[0].find)
				{
					_ifSearch[0].end = true;
					setLineCommand();
				}
				else
				{
					searchIf(command, param);
				}
				break;
			case "else": 
				if (_ifSearch[0].find)
				{
					_ifSearch[0].end = true;
				}
				else
				{
					_ifSearch[0].start = false;
					_ifSearch[0].end = false;
				}
				
				setLineCommand();
				break;
			case "endif": 
				_ifSearch.shift();
				setLineCommand();
				break;
			//-----------------------------------------------------音楽-----------------------------------------------------
			case "startbgm": 
				MainController.$.model.playerParam.playingMapBGM = param.file;
				if (param.hasOwnProperty("vol"))
				{
					MainController.$.model.playerParam.playingMapBGMVol = param.vol;
				}
				SingleMusic.playBGMData(param);
				setLineCommand();
				break;
			case "stopbgm": 
				MainController.$.model.playerParam.playingMapBGM = "";
				SingleMusic.endBGMData(param);
				setLineCommand();
				break;
			case "changeVol": 
				SingleMusic.changeVolumeBgmData(param);
				setLineCommand();
				break;
			//-----------------------------------------------------サウンド-----------------------------------------------------
			case "playsound": 
				SingleMusic.playLoadDataSE(param);
				setLineCommand();
				break;
			//-----------------------------------------------------マップ-----------------------------------------------------
			case "center": //マップ中央指定
				if (param.hasOwnProperty("unit")) //ユニット
				{
					MainController.$.view.battleMap.setCenterPosUnit(param.unit, setLineCommand);
				}
				else
				{
					MainController.$.view.battleMap.setCenterPos(param.x, param.y, setLineCommand);
				}
				break;
			case "loadmap": // マップ読み込み
				MainController.$.view.loadMapData(param.file, setLineCommand, false);
				break;
			case "setsky": //空中設定
				setSky(param);
				setLineCommand();
				break;
			case "setbacktile": // マップ背景タイル設定
				break;
			//-----------------------------------------------------マップイベント------------------------------------------------
			case "setevent": 
				setEvent(command, param);
				setLineCommand();
				break;
			case "clearevent": 
				clearEvent(command, param);
				setLineCommand();
				break;
			//-----------------------------------------------------ユニット-----------------------------------------------------
			case "playersidename": 
				MainController.$.model.playerParam.sideName = command[1];
				setLineCommand();
				break;
			case "joinunit": 
				if (!param.hasOwnProperty("strength"))
				{
					param.strength = 0;
				}
				
				MainController.$.model.addPlayerUnitFromName(param.name, param.level, 0, param.strength);
				setLineCommand();
				break;
			case "createunit": 
				if (!param.hasOwnProperty("strength"))
				{
					param.strength = 0;
				}
				
				_moveFlg = true;
				if (MainController.$.view.battleMap == null)
				{
					MainController.$.view.errorMessageEve("マップが存在しません", _loadLine);
				}
				MainController.$.view.battleMap.createUnit(param.name, param.side, param.x, param.y, param.level, param.strength, param, mapMoveComp, _skipFlg);
				//setLineCommand();
				break;
			case "launchunit": 
				_moveFlg = true;
				if (MainController.$.view.battleMap == null)
				{
					MainController.$.view.errorMessageEve("マップが存在しません", _loadLine);
				}
				
				MainController.$.view.battleMap.launchUnit(param.name, param.x, param.y, param, mapMoveComp, _skipFlg);
				//setLineCommand();
				break;
			case "setunitname": 
				setUnitName(param);
				setLineCommand();
				break;
			case "escape": 
				_moveFlg = true;
				MainController.$.view.battleMap.escapeUnit(param.name, param.side, param, mapMoveComp);
				break;
			case "organize":
				
				if (MainController.$.model.PlayerUnitData.length < 0)
				{
					MainController.$.view.errorMessageEve("選択できるユニットがありません", _loadLine);
				}
				
				if (!param.hasOwnProperty("width"))
				{
					param.width = 7;
				}
				if (!param.hasOwnProperty("height"))
				{
					param.height = 99;
				}
				
				MainController.$.view.battleMap.organizeUnit(param.count, param.x, param.y, param.width, param.height);
				
				break;
			case "unitmove":
				MainController.$.view.battleMap.moveMapUnit(param.unit, param.x, param.y, setLineCommand);
				
				break;
			//-----------------------------------------------------コマンドバトル-----------------------------------------------------
			case "partyinunit": // パーティ加入
				MainController.$.model.partyIn(param.name);
				setLineCommand();
				break;
			case "commandbattlestart":  // コマンドバトル開始
				MainController.$.view.setCommandBattlePanel(MainController.$.model.playerPartyList, MainController.$.model.enemyPartyList);
				setLineCommand();
				break;
			//-----------------------------------------------------ウェイト-----------------------------------------------------
			case "wait": //ウェイト
				waitFunc(command[1]);
				break;
			case "": 
				waitClick();
				break;
			//-----------------------------------------------------ラベルジャンプ------------------------------------------------
			case "goto": 
				clearIf();
				searchLoadLine(command[1]);
				break;
			case "call": 
				_callBaseLine.unshift(_loadLine);
				searchLoadLine(command[1]);
				break;
			case "return": 
				_loadLine = _callBaseLine.shift();
				setLineCommand();
				break;
			//-----------------------------------------------------テロップモード-----------------------------------------------------
			case "settelop": 
				_talkNextPos = 0;
				makeTelop(param);
				// 会話ウィンドウを最上段に
				setTopLayer();
				setLineCommand();
				break;
			case "telop": 
				if (_telop == null)
				{
					_talkNextPos = 0;
					makeTelop(param);
				}
				showTelop(param);
				break;
			case "endtelop": 
				clearTelop(param);
				break;
			case "cleartelop": 
				_talkNextPos = 0;
				_telop.clearText();
				setLineCommand();
				break;
			//-----------------------------------------------------インターミッション------------------------------------------------
			//インターミッションボタンを表示
			//インターミッションラベルを削除
			case "intermissionitem": 
				MainController.$.model.playerParam.setIntermissionParam(param.name, param.show);
				setLineCommand();
				break;
			//インターミッション背景を変更
			case "intermissionback": 
				if (command[1] === "削除" || command[1] === "delete")
				{
					MainController.$.model.playerParam.intermissionBackURL = null;
				}
				else
				{
					MainController.$.model.playerParam.intermissionBackURL = command[1];
				}
				
				setLineCommand();
				break;
			//クイックロード・ゲームオーバー用
			case "quickload": 
				DataLoad.loadMapSaveData();
				break;
			//-----------------------------------------------------各種終了時処理-----------------------------------------------------
			case "exit": 
				clearIf();
				_skipTimer.stop();
				_skipTimer.reset();
				selectTouchEvent(TOUCH_MAP);
				if (_eventCallBack != null)
				{
					selectTouchEvent(TOUCH_MAP);
					_eventCallBack();
					_eventCallBack = null;
				}
				else
				{
					if (MainController.$.view.battleMap != null && MainController.$.view.battleMap.mapPanel != null)
					{
						MainController.$.view.battleMap.mapPanel.showPanel(BattleMapPanel.PANEL_SYSTEM);
					}
				}
				//selectTouchEvent(TOUCH_MAP);
				break;
			case "finish": 
				var app:NativeApplication = NativeApplication.nativeApplication;
				// AIR アプリケーションを終了する
				app.exit(0);
				break;
			case "continue": 
				if (command.length <= 1)
				{
					MainController.$.view.callInterMission(null);
				}
				else
				{
					MainController.$.view.callInterMission(command[1]);
				}
				break;
			case "gameover":
				
				break;
			default: 
				setLineMsg(line);
				break;
			}
		}
		
		/**ウェイト処理*/
		protected function waitFunc(wait:Number):void
		{
			_moveFlg = true;
			if (_skipFlg)
			{
				wait = 0.01;
			}
			
			Tween24.wait(wait).onComplete(function():void
			{
				_moveFlg = false;
				setLineCommand();
			}).play();
		}
		
		/**ラベル検索*/
		protected function searchLoadLine(lable:String):void
		{
			if (_labelData[lable + ":"] != null)
			{
				_loadLine = _labelData[lable + ":"];
				setLineCommand();
			}
			else
			{
				
			}
		}
		
		/**
		 * コマンド読み込み
		 * @param line 読み込みライン
		 */
		protected function setLineMsg(line:String):void
		{
			//読み込み文字に格納
			_msgFlg = true;
			_msgStrage = line;
		}
		
		/**マップ処理終了時*/
		protected function mapMoveComp():void
		{
			_moveFlg = false;
			setLineCommand();
		}
		
		/**
		 * クリックウェイト
		 */
		protected function waitClick():void
		{
			if (_skipFlg)
			{
				setLineCommand();
			}
			else
			{
				for (var i:int = _loadLine; i < _textData.length; i++)
				{
					if (_textData[i] != "")
					{
						_msgFlg = false;
						break;
					}
				}
			}
		}
		
		/**イベント設定*/
		public function setEvent(command:Array, param:Object):void
		{
			var eventData:MapEventData = null;
			switch (param.type)
			{
			//移動
			case MapEventData.TYPE_NAME[MapEventData.TYPE_MATH_IN]: 
			case MapEventData.TYPE_NAME_JP[MapEventData.TYPE_MATH_IN]: 
				eventData = new MapEventData();
				eventData.setMapParam(param.label, param);
				_eventList.push(eventData);
				break;
			//戦闘・戦闘後
			case MapEventData.TYPE_NAME[MapEventData.TYPE_BATTLE_BEFORE]: 
			case MapEventData.TYPE_NAME_JP[MapEventData.TYPE_BATTLE_BEFORE]: 
			case MapEventData.TYPE_NAME[MapEventData.TYPE_BATTLE_AFTER]: 
			case MapEventData.TYPE_NAME_JP[MapEventData.TYPE_BATTLE_AFTER]: 
				eventData = new MapEventData();
				eventData.setBattleParam(command[1], command[2], param.label, param);
				_eventList.push(eventData);
				break;
			//撃破
			case MapEventData.TYPE_NAME[MapEventData.TYPE_DEFEAT]: 
			case MapEventData.TYPE_NAME_JP[MapEventData.TYPE_DEFEAT]: 
				eventData = new MapEventData();
				eventData.setDefeatParam(param.label, param);
				_eventList.push(eventData);
				break;
			//全滅
			case MapEventData.TYPE_NAME[MapEventData.TYPE_EXTINCTION]: 
			case MapEventData.TYPE_NAME_JP[MapEventData.TYPE_EXTINCTION]: 
				eventData = new MapEventData();
				eventData.setExtinctionParam(param.side, param.label, param);
				_eventList.push(eventData);
				break;
			}
		}
		
		/**マップ移動イベント検索*/
		public function searchMapMoveEvent(data:BattleUnit, side:int, callBack:Function, type:int):void
		{
			var param:Object = new Object();
			
			param.x = data.PosX;
			param.y = data.PosY;
			param.side = side;
			param.unit = data.name;
			
			searchEvent(param, callBack, type);
		}
		
		/**マップ戦闘イベント検索*/
		public function searchMapBattleEvent(attacker:BattleUnit, target:BattleUnit, attackSide:int, targetSide:int, callBack:Function, type:int):void
		{
			
			var param:Object = new Object();
			
			param.unit1 = attacker.name;
			param.nickname1 = attacker.masterData.nickName;
			param.side1 = attackSide;
			param.unit2 = target.name;
			param.nickname2 = target.masterData.nickName;
			param.side2 = targetSide;
			
			searchEvent(param, callBack, type);
		}
		
		/**撃破イベント検索*/
		public function searchDefeatEvent(target:BattleUnit, sideName:String, callBack:Function, type:int):void
		{
			var param:Object = new Object();
			
			param.unit = target.name;
			param.nickname = target.masterData.nickName;
			param.side = sideName;
			
			searchEvent(param, callBack, type);
		}
		
		/**全滅イベント検索*/
		public function searchExtinctionEvent(targetSide:String, callBack:Function, type:int):void
		{
			var param:Object = new Object();
			param.side = targetSide;
			searchEvent(param, callBack, type);
		}
		
		/**イベント検索*/
		public function searchEvent(param:Object, callBack:Function, type:int):void
		{
			_eventCallBack = null;
			var i:int = 0;
			var endFlg:Boolean = false;
			for (i = 0; i < _eventList.length; i++)
			{
				
				if (_eventList[i].type == type)
				{
					// イベントとパラメーターを識別
					if (((type == MapEventData.TYPE_BATTLE_BEFORE || type == MapEventData.TYPE_BATTLE_AFTER) && _eventList[i].judgeBattleParam(param)) || // 戦闘前・後イベント
					(type == MapEventData.TYPE_MATH_IN && _eventList[i].judgeMapParam(param)) ||		//マス侵入イベント
					(type == MapEventData.TYPE_DEFEAT && _eventList[i].judgeDefeatParam(param)) ||	//撃破イベント
					(type == MapEventData.TYPE_EXTINCTION && _eventList[i].judgeExtinctionParam(param))	//全滅イベント
					)
					{
						endFlg = true;
					}
					
				}
				
				if (endFlg)
				{
					selectTouchEvent(TOUCH_TALK);
					_eventCallBack = callBack;
					searchLoadLine(_eventList[i].label);
					break;
				}
			}
			
			if (!endFlg)
			{
				callBack();
			}
		}
		
		/**イベント削除*/
		public function clearEvent(command:Array, param:Object):void
		{
			var i:int = 0;
			for (i = 0; i < _eventList.length; i++)
			{
				if (_eventList[i].label === command[1])
				{
					_eventList[i] = null;
					_eventList.splice(i, 1);
					i--;
				}
			}
			i = 0;
		}
		
		//-----------------------------------------------------------------
		//
		// 表示オブジェクト読み込み
		//
		//-----------------------------------------------------------------
		
		protected function loadImg(command:Array, param:Object):void
		{
			var tex:Texture = null;
			
			if (param.hasOwnProperty("img"))
			{
				tex = MainController.$.imgAsset.getTexture(param.img);
			}
			else if(param.hasOwnProperty("unit"))
			{
			 	var unitName:String = MainController.$.model.masterUnitImageData.getUnitImgName(param.unit);
				tex = MainController.$.imgAsset.getTexture(unitName);
			}
			else
			{
				MainController.$.view.errorMessageEve("画像が指定されていません", _loadLine);
			}
			
			if (tex == null)
			{
				MainController.$.view.errorMessageEve("対象の画像が存在しません", _loadLine);
			}
			
			var i:int = 0;
			var setSpr:CSprite = ImgDef.setImgSpr(tex, param);
			
			if (param.hasOwnProperty("layer"))
			{
				for (i = 0; i < _layer.length; i++)
				{
					if (_layer[i].name === param.layer)
					{
						_layer[i].addChild(setSpr);
						break;
					}
				}
			}
			else
			{
				_layer[_selectLayer].addChild(setSpr);
			}
			_displayObject.push(setSpr);
			setLineCommand();
		}
		
		// 画面フラッシュ
		protected function flashWindow(command:Array, param:Object):void
		{
			_flashImg.alpha = 0;
			_flashImg.visible = true;
			var flashTime:Number;
			
			// 時間設定
			if (param.hasOwnProperty("time"))
			{
				flashTime = param.time / 2.0;
			}
			else
			{
				flashTime = 0.5;
			}
			
			// 色設定
			if (param.hasOwnProperty("color"))
			{
				_flashImg.color = Number(param.color);
			}
			else
			{
				_flashImg.color = 0xFFFFFF;
			}
			
			if (param)
				
				addChild(_flashImg);
			Tween24.serial(Tween24.tween(_flashImg, CommonDef.waitTime(flashTime, _skipFlg)).fadeIn(), Tween24.tween(_flashImg, CommonDef.waitTime(flashTime, _skipFlg)).fadeOut()).onComplete(flashEnd).play();
			
			function flashEnd():void
			{
				_flashImg.visible = false;
				removeChild(_flashImg);
				setLineCommand();
			}
		
		}
		
		protected function allLayer(command:Array, param:Object):void
		{
			var tween:Tween24 = null;
			var ary:Array = new Array();
			var i:int = 0;
			var time:Number = 0;
			var alpha:Number = 0;
			
			if (param.hasOwnProperty("time"))
			{
				time = param.time;
			}
			if (param.hasOwnProperty("alpha"))
			{
				alpha = param.alpha;
			}
			
			for (i = 0; i < _layer.length; i++)
			{
				if (time < 0)
				{
					ary.push(Tween24.prop(_layer[i]).alpha(alpha));
				}
				else
				{
					ary.push(Tween24.tween(_layer[i], CommonDef.waitTime(time, _skipFlg)).alpha(alpha));
				}
			}
			
			tween = Tween24.parallel(ary).onComplete(compLayerTween);
			tween.play();
		}
		
		protected function compLayerTween():void
		{
			var i:int = 0;
			for (i = 0; i < _layer.length; i++)
			{
				if (_layer[i].alpha <= 0)
				{
					_layer[i].visible = false;
				}
				else
				{
					_layer[i].visible = true;
				}
			}
			setLineCommand();
		}
		
		protected function removeItem(command:Array, param:Object):void
		{
			for (var i:int = 0; i < _displayObject.length; i++)
			{
				if (param.name === _displayObject[i].name)
				{
					if (_displayObject[i] != null)
					{
						
						_displayObject[i].removeEventListener(TouchEvent.TOUCH, objectTouch);
						
						if (_displayObject[i].parent != null)
						{
							_displayObject[i].parent.removeChild(_displayObject[i]);
						}
						_displayObject[i].dispose();
						_displayObject[i] = null;
						_displayObject.splice(i, 1);
					}
					break;
				}
			}
			
			setLineCommand();
		
		}
		
		protected function loadParticle(command:Array, param:Object):void
		{
			var i:int = 0;
			var pex:XML = null;
			var file:File = null;
			var url:String = null;
			var texName:String;
			var tex:Texture = null;
			
			pex = MainController.$.imgAsset.getXml(param.pex);
			tex =  MainController.$.imgAsset.getTexture(param.tex);
			
			
			if (pex == null)
			{
				MainController.$.view.errorMessageEve("パーティクルファイルがありません", _loadLine);
			}
			if (tex == null)
			{
				MainController.$.view.errorMessageEve("画像ファイルがありません", _loadLine);
			}
			playPex(tex, pex, param);
		}
		
		//-----------------------------------------------------------------
		//
		//
		//
		//-----------------------------------------------------------------
		protected function setActionMode(command:Array, param:Object):void
		{
			switch (command[1])
			{
			case "マップ": 
			case "map": 
				break;
			case "アイテム": 
			case "item": 
				break;
			}
		}
		
		//-----------------------------------------------------------------
		//
		// 表示オブジェクト処理
		//
		//-----------------------------------------------------------------
		
		/**アイテム表示*/
		protected function showItemFunc(command:Array, param:Object):void
		{
			_noTouch = true;
			var dispObj:DisplayObject;
			var twn:Array = new Array;
			var time:Number = 0;
			if (command[1])
			{
				time = Number(command[1]);
			}
			else
			{
				time = 1;
			}
			twn = new Array;
			
			for each (dispObj in _displayObject)
			{
				if (time <= 0)
				{
					twn.push(Tween24.prop(dispObj).fadeIn());
				}
				else
				{
					twn.push(Tween24.tween(dispObj, CommonDef.waitTime(time, _skipFlg)).fadeIn());
				}
			}
			var tween:Tween24 = Tween24.parallel(twn).onComplete(setLineCommand);
			_tween.push(tween);
			tween.play();
		}
		
		/**アイテム非表示*/
		protected function hideItemFunc(command:Array, param:Object):void
		{
			_noTouch = true;
			var dispObj:DisplayObject;
			var twn:Array = new Array;
			var time:Number = 0;
			if (command[1])
			{
				time = Number(command[1]);
			}
			else
			{
				time = 1;
			}
			twn = new Array;
			
			for each (dispObj in _displayObject)
			{
				if (time <= 0)
				{
					twn.push(Tween24.prop(dispObj).fadeOut());
				}
				else
				{
					twn.push(Tween24.tween(dispObj, CommonDef.waitTime(time, _skipFlg)).fadeOut());
				}
			}
			var tween:Tween24 = Tween24.parallel(twn).onComplete(setLineCommand);
			_tween.push(tween);
			tween.play();
		}
		
		protected function readyMoveFunc(command:Array, param:Object):void
		{
			var num:int = _tweenAry.length;
			_tweenAry[num] = new Array();
			_tweenNum = num;
			setLineCommand();
		}
		
		protected function setMoveFunc(command:Array, param:Object):void
		{
			var i:int = 0;
			var num:int = 0;
			var tween:Tween24;
			if (param.hasOwnProperty("layer"))
			{
				for (i = 0; i < _layer.length; i++)
				{
					if (_layer[i].name != null && _layer[i].name == param.layer)
					{
						tween = MsgDef.setTweenParam(_layer[i], param, _skipFlg);
						_tweenAry[_tweenNum].push(tween);
						break;
					}
				}
			}
			else
			{
				for (i = 0; i < _displayObject.length; i++)
				{
					if (_displayObject[i].name != null && _displayObject[i].name == param.name)
					{
						tween = MsgDef.setTweenParam(_displayObject[i], param, _skipFlg);
						_tweenAry[_tweenNum].push(tween);
						break;
					}
				}
			}
		}
		
		protected function startMoveFunc(command:Array, param:Object):void
		{
			if (!param.hasOwnProperty("wait"))
			{
				param.wait = "on";
			}
			
			var waitStr:String = param.wait;
			waitStr = waitStr.toLowerCase();
			
			if (waitStr === "on")
			{
				_moveFlg = true;
			}
			
			_noTouch = true;
			var tween:Tween24;
			switch (param.type)
			{
			default: 
			case "同時": 
				tween = Tween24.parallel(_tweenAry[_tweenNum]);
				break;
			case "連続": 
				tween = Tween24.serial(_tweenAry[_tweenNum]);
				break;
			}
			_tween.push(tween);
			tween.onComplete(compTween, _tweenNum, waitStr).play();
			
			if (waitStr === "off")
			{
				setLineCommand();
			}
		}
		
		protected function compTween(num:int, waitFlg:String):void
		{
			var i:int = 0;
			_tween[num].stop();
			_tween.splice(num, 1);
			for (i = 0; i < _tweenAry.length; )
			{
				_tweenAry.pop();
			}
			if (waitFlg === "on")
			{
				_moveFlg = false;
				setLineCommand();
			}
		
		}
		
		//-----------------------------------------------------------------
		//
		// レイヤー管理
		//
		//-----------------------------------------------------------------
		
		protected function addLayer(param:Object):void
		{
			var layer:CSprite = new CSprite();
			var level:int;
			
			// 名前
			if (param.hasOwnProperty("name"))
			{
				layer.name = param.name;
			}
			else
			{
				MainController.$.view.errorMessageEve("レイヤー名が設定されていません", _loadLine);
			}
			
			// 透明度
			if (param.hasOwnProperty("alpha"))
			{
				layer.alpha = param.alpha;
			}
			else
			{
				layer.alpha = 1;
			}
			
			// 可視
			if (layer.alpha > 0)
			{
				layer.visible = true;
			}
			else
			{
				layer.visible = false;
			}
			
			_layer.push(layer);
			// 階層指定
			if (param.hasOwnProperty("level"))
			{
				level = param.level;
				if (level >= this.numChildren)
				{
					level = this.numChildren - 1;
				}
				else if (level < 0)
				{
					level = 0;
				}
				
				addChildAt(layer, param.level);
			}
			// レイヤー名指定
			else if (param.hasOwnProperty("layername"))
			{
				level = this.getChildIndex(this.getChildByName(param.layername));
				if (param.hasOwnProperty("addlevel"))
				{
					level += param.addlevel + 1;
				}
				else
				{
					level += 1;
				}
				
				if (level >= this.numChildren)
				{
					level = this.numChildren - 1;
				}
				else if (level < 0)
				{
					level = 0;
				}
				
				addChildAt(layer, level);
			}
			else
			{
				addChild(layer);
			}
			// 会話ウィンドウを最上段に
			setTopLayer();
		}
		
		protected function selectLayer(param:Object):void
		{
			var i:int = 0;
			if (param.hasOwnProperty("name"))
			{
				for (i = 0; i < _layer.length; i++)
				{
					if (param.name === _layer[i].name)
					{
						_selectLayer = i;
						break;
					}
				}
			}
			else if (param.hasOwnProperty("number"))
			{
				_selectLayer = i;
			}
			else
			{
				_selectLayer = _layer.length - 1;
			}
			
			if (_selectLayer < 0)
			{
				_selectLayer = 0;
			}
			if (_selectLayer >= _layer.length)
			{
				_selectLayer = _layer.length - 1;
			}
		}
		
		/**レイヤー削除*/
		protected function deleteLayer(param:Object):void
		{
			var layer:CSprite = null;
			layer = getSliceLayer(param);
			deleteLayerObject(layer);
			removeChild(layer);
			layer.dispose();
			layer = null;
		}
		
		/**レイヤー上オブジェクト全消去*/
		protected function clearLayer(param:Object):void
		{
			var layer:CSprite = null;
			layer = getLayer(param);
			deleteLayerObject(layer);
		}
		
		/**指定レイヤー切り取り取得*/
		protected function getSliceLayer(param:Object):CSprite
		{
			var i:int = 0;
			var layer:CSprite = null;
			if (param.hasOwnProperty("name"))
			{
				for (i = 0; i < _layer.length; i++)
				{
					if (param.name === _layer[i].name)
					{
						layer = _layer.splice(i, 1)[0];
						break;
					}
				}
			}
			else if (param.hasOwnProperty("number"))
			{
				layer = _layer.splice(param.number, 1)[0];
			}
			else
			{
				layer = _layer.pop();
			}
			return layer;
		}
		
		/**指定レイヤー切り取り取得*/
		protected function getLayer(param:Object):CSprite
		{
			var i:int = 0;
			var layer:CSprite = null;
			if (param.hasOwnProperty("name"))
			{
				for (i = 0; i < _layer.length; i++)
				{
					if (param.name === _layer[i].name)
					{
						layer = _layer[i];
						break;
					}
				}
			}
			else if (param.hasOwnProperty("number"))
			{
				layer = _layer[i];
			}
			return layer;
		}
		
		/**レイヤー上オブジェクト全削除*/
		protected function deleteLayerObject(layer:CSprite):void
		{
			var i:int = 0;
			var obj:DisplayObject = null;
			// 同一レイヤーのオブジェクトのイベント削除
			if (layer != null)
			{
				for (i = 0; i < _displayObject.length; i++)
				{
					if (_displayObject[i].parent === layer)
					{
						//obj = _displayObject[i];
						obj = _displayObject.splice(i, 1)[0];
						obj.removeEventListener(TouchEvent.TOUCH, objectTouch);
						layer.removeChild(obj);
						obj.dispose();
						obj = null;
						i--;
					}
				}
			}
		}
		
		//-----------------------------------------------------------------
		//
		// オブジェクト消去
		//
		//-----------------------------------------------------------------
		
		protected function resetAll():void
		{
			resetDisplayObject();
			resetTweenList();
			resetLayer();
			initLayer();
			setLineCommand();
		}
		
		/**
		 * 表示オブジェクト初期化
		 */
		protected function resetDisplayObject():void
		{
			for (var i:int = 0; i < _displayObject.length; )
			{
				var obj:DisplayObject = _displayObject[i];
				if (obj != null)
				{
					
					obj.removeEventListener(TouchEvent.TOUCH, objectTouch);
					if (obj.parent != null)
					{
						obj.parent.removeChild(obj);
					}
					obj.dispose();
				}
				_displayObject.shift();
			}
		}
		
		/**
		 * 表示オブジェクト初期化
		 */
		protected function resetTweenList():void
		{
			var i:int = 0;
			for (i = 0; i < _tween.length; )
			{
				var tween:Tween24 = _tween[i];
				tween.stop();
				tween = null;
				_tween.shift();
			}
			
			for (i = 0; i < _tweenAry.length; )
			{
				var ary:Array = _tweenAry[i];
				ary = null;
				_tweenAry.shift();
			}
			_tweenNum = 0;
		}
		
		/**
		 * レイヤーリセット
		 */
		protected function resetLayer():void
		{
			var i:int = 0;
			var j:int = 0;
			for (i = 0; i < _layer.length; )
			{
				
				for (j = 0; j < _displayObject.length; j++)
				{
					if (_displayObject[j].parent === _layer[i])
					{
						_displayObject[j].removeEventListener(TouchEvent.TOUCH, objectTouch);
					}
				}
				
				if (_layer[i].parent != null)
				{
					_layer[i].parent.removeChild(_layer[i]);
				}
				_layer[i].dispose();
				_layer[i] = null;
				_layer.shift();
			}
			_selectLayer = 0;
		}
		
		/**
		 * レイヤー初期化
		 */
		protected function initLayer():void
		{
			_layer[0] = new CSprite();
			addChild(_layer[0]);
			// 会話ウィンドウを最上段に
			setTopLayer();
			_selectLayer = 0;
		}
		
		//-----------------------------------------------------------------
		//
		// 表示テキスト操作
		//
		//-----------------------------------------------------------------
		
		/**テキスト配置*/
		protected function setTextImg(command:Array, param:Object):void
		{
			var i:int = 0;
			var setImgSpr:CSprite = ImgDef.setTextSpr(param);
			
			if (param.hasOwnProperty("layer"))
			{
				for (i = 0; i < _layer.length; i++)
				{
					if (_layer[i].name === param.layer)
					{
						_layer[i].addChild(setImgSpr);
						break;
					}
				}
			}
			else
			{
				_layer[_selectLayer].addChild(setImgSpr);
			}
			_displayObject.push(setImgSpr);
		}
		
		/**テキスト文字変更*/
		protected function changeText(command:Array, param:Object):void
		{
			var i:int = 0;
			
			for (i = 0; i < _displayObject.length; i++)
			{
				if (_displayObject[i].name === param.name)
				{
					var spr:CSprite = _displayObject[i] as CSprite;
					
					if (spr != null && spr.getChildAt(0) is CTextArea)
					{
						var text:CTextArea = (_displayObject[i] as CSprite).getChildAt(0) as CTextArea;
						text.text = param.text;
					}
					break;
				}
			}
		}
		
		/**変数にインプットを設定*/
		protected function setTextValue(command:Array, param:Object):void
		{
			var i:int = 0;
			if (param.hasOwnProperty("name") && param.hasOwnProperty("target"))
			{
				for (i = 0; i < playerVariable.length; i++)
				{
					if (playerVariable[i] === param.name)
					{
						playerVariable[i].setString(getSprText(param.target));
						break;
					}
				}
			}
		}
		
		/**テキスト文字取得*/
		protected function getSprText(name:String):String
		{
			var i:int = 0;
			var getText:String = "";
			for (i = 0; i < _displayObject.length; i++)
			{
				if (_displayObject[i].name === name)
				{
					var spr:CSprite = _displayObject[i] as CSprite;
					
					if (spr != null && spr.getChildAt(0) is CTextArea)
					{
						var text:CTextArea = (_displayObject[i] as CSprite).getChildAt(0) as CTextArea;
						getText = text.text;
					}
					break;
				}
			}
			return getText;
		}
		
		//-----------------------------------------------------------------
		//
		// 読み込み完了
		//
		//-----------------------------------------------------------------
		
		protected function pexCompRegist(data:XML, param:Array):void
		{
			_pexNameList.push(param[0]);
			_pexList.push(data);
			
			setLineCommand();
		}
				
		/** パーティクル＆テクスチャ読み込み完了 */
		protected function pexTexComp(tex:Texture, data:Array, layer:String = null):void
		{
			var i:int = 0;
			if (tex == null)
			{
				tex = CommonDef.BACK_TEX;
			}
			
			var particles:ParticleSystem;
			particles = new PDParticleSystem(data[0], tex);
			
			if (_layer != null)
			{
				for (i = 0; i <= _layer.length; i++)
				{
					if (layer == null)
					{
						if (data[4] == _layer[i].name)
						{
							_layer[i].addChild(particles);
							break;
						}
					}
					else
					{
						if (layer == _layer[i].name)
						{
							_layer[i].addChild(particles);
							break;
						}
					}
				}
			}
			particles.start();
			particles.emitterX = data[1];
			particles.emitterY = data[2];
			Starling.juggler.add(particles);
			particles.visible = true;
			particles.alpha = 1;
			particles.name = data[3];
			_displayObject.push(particles);
			setLineCommand();
		}
		
		/** パーティクル開始 */
		protected function playPex(tex:Texture, pex:XML, param:Object):void
		{
			var i:int = 0;
			if (tex == null)
			{
				tex = CommonDef.BACK_TEX;
			}
			
			if (!param.hasOwnProperty("x"))
			{
				param.x = 0;
			}
			if (!param.hasOwnProperty("y"))
			{
				param.y = 0;
			}
			if (!param.hasOwnProperty("alpha"))
			{
				param.alpha = 1;
			}
			
			var particles:ParticleSystem;
			particles = new PDParticleSystem(pex, tex);
			
			if (param.hasOwnProperty("layer"))
			{
				if (_layer != null)
				{
					for (i = 0; i <= _layer.length; i++)
					{
						if (param.layer == _layer[i].name)
						{
							_layer[i].addChild(particles);
							break;
						}
					}
				}
			}
			else
			{
				_layer[_layer.length - 1].addChild(particles);
			}
			particles.start();
			particles.emitterX = param.x;
			particles.emitterY = param.y;
			Starling.juggler.add(particles);
			particles.alpha = param.alpha;
			
			if (particles.alpha > 0)
			{
				particles.visible = true;
			}
			else
			{
				particles.visible = false;
			}
			
			particles.name = param.name;
			_displayObject.push(particles);
			setLineCommand();
		}
		
		//-----------------------------------------------------------------
		//
		// マップ状態設定
		//
		//-----------------------------------------------------------------
		
		//空中設定
		protected function setSky(param:Object):void
		{
			if (MainController.$.view.battleMap == null)
			{
				MainController.$.view.errorMessageEve("マップを展開していません", _loadLine)
			}
			else
			{
				
				if (param.hasOwnProperty("state"))
				{
					if (param.state === "on")
					{
						MainController.$.view.battleMap.skyFlg = true;
					}
					else
					{
						MainController.$.view.battleMap.skyFlg = false;
					}
				}
				else
				{
					MainController.$.view.battleMap.skyFlg = true;
				}
			}
		
		}
		
		//-----------------------------------------------------------------
		//
		// ユニット操作
		//
		//-----------------------------------------------------------------
		
		protected function setUnitName(param:Object):void
		{
			MainController.$.model.PlayerUnitDataName(param.name).showName = param.setname;
		}
		
		//-----------------------------------------------------------------
		//
		// ローカル変数設定
		//
		//-----------------------------------------------------------------
		
		/**ライン内部文字計算*/
		protected function mathLineValue(line:String):String
		{
			var num:int = 0;
			var i:int = 0;
			var j:int = 0;
			var k:int = 0;
			var l:int = 0;
			var startPos:int = 0;
			var endPos:int = 0;
			var count:int = 0;
			var rep:String = "";
			var pRep:String = "";
			var answer:int = 0;
			var data:String = "";
			var ary:Array = new Array();
			for (num = 0; num < REPLACE_ARY.length; num++)
			{
				rep = "$" + REPLACE_ARY[num] + "(";
				pRep = "$" + REPLACE_P_ARY[num] + "(";
				
				line = line.replace(pRep, rep);
				while (line.indexOf(rep) >= 0)
				{
					count = 0;
					startPos = line.indexOf(rep) + rep.length;
					// 終わりカッコの検索
					for (i = startPos; i < line.length; i++)
					{
						var charStr:String = line.charAt(i);
						if (count == 0 && charStr === ")")
						{
							endPos = i;
							break;
						}
						else if (charStr === "(")
						{
							count++;
						}
						else if (charStr === ")")
						{
							count--;
						}
					}
					var searchStr:String = line.substring(startPos, endPos);
					
					switch (REPLACE_ARY[num])
					{
					case "math": 
						var mathStr:String = searchStr;
						//for (var key:String in playerVariable)
						//{
						for (k = 0; k < playerVariable.length; k++)
						{
							mathStr = mathStr.replace(playerVariable[k].name, playerVariable[k].getValue as String);
						}
						answer = CalcInfix.eval(mathStr);
						line = line.replace(rep + searchStr + ")", answer + "");
						break;
					case "name": 
						searchStr = searchStr.replace(/\s/g, "");
						ary = searchStr.split(",");
						data = MainController.$.model.PlayerUnitDataName(ary[0]).name;
						line = line.replace(rep + searchStr + ")", data + "");
						break;
					//ユニット
					case "unit": 
						searchStr = searchStr.replace(/\s/g, "");
						ary = searchStr.split(",");
						data = MainController.$.model.PlayerUnitDataName(ary[0])[ary[1]];
						line = line.replace(rep + searchStr + ")", data + "");
						break;
					//変数
					case "variable": 
						searchStr = searchStr.replace(/\s/g, "");
						ary = searchStr.split(",");
						
						for (k = 0; k < playerVariable.length; k++)
						{
							if (playerVariable[k].name === searchStr)
							{
								data = playerVariable[k].getValue() as String;
								break;
							}
						}
						
						line = line.replace(rep + searchStr + ")", data + "");
						break;
					//陣営数
					case "sidenum": 
						searchStr = searchStr.replace(/\s/g, "");
						ary = searchStr.split(",");
						for (k = 0; k < MainController.$.view.battleMap.sideState.length; k++)
						{
							if (searchStr === MainController.$.view.battleMap.sideState[k].name)
							{
								var unitCount:int = 0;
								for (l = 0; l <  MainController.$.view.battleMap.sideState[k].battleUnit.length; l++ )
								{
									if (MainController.$.view.battleMap.sideState[k].battleUnit[l].alive)
									{
										unitCount++;
									}
								}
								
								
								line = line.replace(rep + searchStr + ")", unitCount + "");
								break;
							}
						}
						
						break;
					}
				}
			}
			
			return line;
		}
		
		/** 変数設定 */
		protected function setVariable(command:Array, param:Object):void
		{
			var variable:PlayerVariable = new PlayerVariable(param.name);
			
			if (param.hasOwnProperty("list"))
			{
				if (param.list === "array" || param.list === "リスト" || param.list === "配列")
				{
					variable.setList();
						//_localVariable[param.name] = new Array();
				}
				else if (param.list === "select" || param.list === "選択")
				{
					variable.setSelectList();
						//_localVariable[param.name] = new Vector.<SelectCommandData>;
				}
			}
			else
			{
				variable.setValue(param.value);
				/*
				   if (isNaN(param.value))
				   {
				   variable.setNumber(param.value);
				   //_localVariable[param.name] = param.value;
				   }
				   else
				   {
				   variable.setNumber(param.value);
				   //_localVariable[param.name] = Number(param.value);
				   }
				 */
			}
			
			if (param.hasOwnProperty("type") && param.type === "global")
			{
				variable.setGlobal(true);
			}
			
			playerVariable.push(variable);
		}
		
		protected function pushVariable(command:Array, param:Object):void
		{
			var i:int = 0;
			var target:String = param.target;
			var variable:PlayerVariable = null;
			
			for (i = 0; i < playerVariable.length; i++)
			{
				if (target === playerVariable[i].name)
				{
					variable = playerVariable[i];
					break;
				}
			}
			
			if (playerVariable != null)
			{
				//リスト
				if (variable.type == PlayerVariable.TYPE_LIST)
				{
					variable.pushList(param.value);
				}
				//選択肢
				else if (variable.type == PlayerVariable.TYPE_SELECT)
				{
					variable.pushSelect(param);
				}
			}
		}
		
		/**数値加算*/
		protected function incrVariable(command:Array, param:Object):void
		{
			var i:int = 0;
			//var key:String = "";
			//for (key in playerVariable)
			//{
			for (i = 0; i < playerVariable.length; i++)
			{
				if (playerVariable[i].name === param.name)
				{
					playerVariable[i] += param.value;
					break;
				}
			}
		}
		
		// ＩＦ文
		protected function searchIf(command:Array, param:Object):void
		{
			var nextStr:String = "";
			var labelStr:String = "";
			var commandStr:String = command.shift();
			var mathString:String = "";
			
			//var key:Object = null;
			var i:int = 0;
			var j:int = 0;
			for (i = 0; i < command.length; i++)
			{
				command[i] = command[i].toLowerCase();
				if (command[i] === "then")
				{
					nextStr = command[i];
					break;
				}
				else if (command[i] == "goto")
				{
					nextStr = command[i];
					labelStr = command[i + 1];
					break;
				}
				else if (command[i] === "")
				{
					continue;
				}
				
				if (i > 0)
				{
					mathString += " ";
				}
				
				//for (key in playerVariable)
				//{
				
				for (j = 0; j < playerVariable.length; j++)
				{
					if (playerVariable[j].name === command[i])
					{
						command[i] = playerVariable[j];
						break;
					}
				}
				mathString += command[i];
			}
			
			var answer:int = CalcInfix.eval(mathString);
			
			switch (nextStr)
			{
			case "then":
				
				if (answer > 0)
				{
					_ifSearch[0].find = true;
					_ifSearch[0].start = false;
					setLineCommand()
				}
				else
				{
					_ifSearch[0].start = true;
					setLineCommand()
				}
				break;
			case "goto": 
				if (answer > 0)
				{
					// 一致したらラベル検索
					searchLoadLine(labelStr);
				}
				else
				{
					// 一致しなかったら次へ
					setLineCommand();
				}
				break;
			}
		
		}
		
		/**If文解除*/
		protected function clearIf():void
		{
			var i:int = 0;
			for (i = 0; i < _ifSearch.length; )
			{
				_ifSearch.pop();
			}
			_ifCount = 0;
		}
		
		/**スイッチ設定*/
		protected function setSwitch(command:Array, param:Object):void
		{
			var i:int = 0;
			for (i = 0; i < playerVariable.length; i++)
			{
				if (playerVariable[i].name === command[1])
				{
					var newSwitch:IfSearch = new IfSearch();
					newSwitch.switchString = playerVariable[i].getValue() as String;
					newSwitch.start = true;
					_ifSearch.unshift(newSwitch);
					break;
				}
			}
			setLineCommand();
		}
		
		/**ケース検索*/
		protected function searchCase(command:Array, param:Object):void
		{
			if (command[1] === _ifSearch[0].switchString || command[0] === "default")
			{
				_ifSearch[0].find = true;
				_ifSearch[0].start = false;
			}
			setLineCommand();
		
		}
		
		/**検索終了*/
		protected function switchBreak():void
		{
			_ifSearch[0].end = true;
		}
		
		//-----------------------------------------------------------------
		//
		// 選択肢
		//
		//-----------------------------------------------------------------
		/**選択肢ウィンドウ*/
		protected function selectCommand(command:Array, param:Object):void
		{
			var i:int = 0;
			if (_selectWindow != null)
			{
				_selectWindow.dispose();
				_selectWindow = null;
			}
			
			//選択肢ウィンドウ
			_selectWindow = new SelectWindow();
			
			if (param.hasOwnProperty("goto") && param.goto === "on")
			{
				_selectWindow.gotoFlg = true;
			}
			else
			{
				//該当変数名
				if (param.hasOwnProperty("target"))
				{
					_selectWindow.valiableName = param.target;
				}
			}
			
			// キー一覧
			var keyList:Vector.<SelectCommandData> = null;
			var key:String = "";
			if (param.hasOwnProperty("uselist"))
			{
				for (i = 0; i < playerVariable.length; i++)
				{
					if (playerVariable[i].name === param.uselist)
					{
						if (playerVariable[i].type == PlayerVariable.TYPE_SELECT)
						{
							keyList = playerVariable[i].getSelectList();
						}
						else
						{
							MainController.$.view.errorMessageEve("選択リストを使用していません", _loadLine);
						}
						break;
					}
					
				}
			}
			else
			{
				//for (var key:String in param)
				
				keyList = new Vector.<SelectCommandData>;
				for (i = 1; i < command.length; i++)
				{
					var ary:Array = command[i].split(":");
					key = ary[0];
					if (SelectWindow.judgeNoUse(key))
					{
						continue;
					}
					var item:SelectCommandData = new SelectCommandData();
					item.key = ary[0];
					item.value = ary[1];
					keyList.push(item);
				}
			}
			_selectWindow.setKeyList(keyList, selectAction);
			if (_topLayer != null)
			{
				_topLayer.dispose();
				_topLayer = null;
			}
			_topLayer = new CSprite();
			
			var img:CImage = new CImage(CommonDef.SELECT_TEX);
			img.width = CommonDef.WINDOW_W;
			img.height = CommonDef.WINDOW_H;
			img.textureSmoothing = TextureSmoothing.NONE;
			
			_selectWindow.x = (CommonDef.WINDOW_W - _selectWindow.width) / 2;
			_selectWindow.y = (CommonDef.WINDOW_H - _selectWindow.height) / 2;
			
			_topLayer.addChild(img);
			
			_topLayer.addChild(_selectWindow);
			addChild(_topLayer);
			
			selectTouchEvent(TOUCH_SELECT);
		}
		
		/**選択肢選択*/
		protected function selectAction(key:String, value:String):void
		{
			var i:int = 0;
			var flg:Boolean = false;
			_topLayer.removeChild(_selectWindow);
			removeChild(_topLayer);
			
			if (_selectWindow.gotoFlg)
			{
				clearIf();
				searchLoadLine(value);
			}
			else
			{
				for (i = 0; i < playerVariable.length; i++)
				{
					if (playerVariable[i].name === _selectWindow.valiableName)
					{
						playerVariable[i].setValue(value);
						flg = true;
						break;
					}
				}
				
				if (!flg)
				{
					var variable:PlayerVariable = new PlayerVariable(_selectWindow.valiableName);
					variable.setValue(value);
					playerVariable.push(variable);
				}
				setLineCommand();
			}
			_selectWindow.dispose();
			_selectWindow = null;
			_topLayer.dispose();
			_topLayer = null;
			
			selectTouchEvent(TOUCH_TALK);
		}
		
		//-----------------------------------------------------------------
		//
		// テロップウィンドウ作成
		//
		//-----------------------------------------------------------------
		protected function makeTelop(param:Object):void
		{
			if (_telop != null)
			{
				_talkArea.removeChild(_telop);
				_telop.dispose();
				_telop = null;
			}
			_telop = new TelopWindow(param);
		}
		
		protected function showTelop(param:Object):void
		{
			_talkMode = TALK_TELOP;
			_telop.alpha = 0;
			_telop.visible = true;
			_talkArea.addChild(_telop);
			setTopLayer();
			
			if (!param.hasOwnProperty("time"))
			{
				param.time = 0;
			}
			else
			{
				param.time = Number(param.time);
			}
			
			if (param.time <= 0)
			{
				_telop.alpha = 1;
				setLineCommand();
			}
			else
			{
				Tween24.tween(_telop, param.time).fadeIn().onComplete(compShowTelop).play();
			}
			
			function compShowTelop():void
			{
				_telop.alpha = 1;
				setLineCommand();
			}
		
		}
		
		protected function clearTelop(param:Object):void
		{
			_talkMode = TALK_MSG;
			
			if (!param.hasOwnProperty("time"))
			{
				param.time = 0;
			}
			else
			{
				param.time = Number(param.time);
			}
			
			if (param.time <= 0)
			{
				_telop.alpha = 0;
				_telop.visible = false;
				_talkArea.removeChild(_telop);
				setLineCommand();
			}
			else
			{
				Tween24.tween(_telop, param.time).fadeOut().onComplete(compClearTelop).play();
			}
			
			function compClearTelop():void
			{
				_telop.alpha = 0;
				_telop.visible = false;
				_talkArea.removeChild(_telop);
				setLineCommand();
			}
		
		}
		
		//-----------------------------------------------------------------
		//
		// クリックイベント追加
		//
		//-----------------------------------------------------------------
		
		protected function setClickEvent(command:Array, param:Object):void
		{
			if (param.hasOwnProperty("target"))
			{
				var i:int = 0;
				for (i = 0; i < _displayObject.length; i++)
				{
					if (_displayObject[i] is CSprite)
					{
						var img:CSprite = _displayObject[i] as CSprite;
						
						if (_displayObject[i].name === param.target)
						{
							if (param.hasOwnProperty("touch"))
							{
								img._touchLabel = param.touch + ":";
							}
							if (param.hasOwnProperty("move"))
							{
								img._moveLabel = param.move + ":";
							}
							img.removeEventListener(TouchEvent.TOUCH, objectTouch);
							img.addEventListener(TouchEvent.TOUCH, objectTouch);
							img.useHandCursor = true;
							img._touchFlg = true;
						}
					}
				}
			}
		}
		
		// タッチイベント実行
		public function objectTouch(e:TouchEvent):void
		{
			var target:CSprite = e.currentTarget as CSprite;
			var touch:Touch = e.getTouch(target);
			if (touch)
			{
				switch (touch.phase)
				{
				case TouchPhase.BEGAN: 
					if (target._touchLabel != null)
					{
						
						selectTouchEvent(TOUCH_TALK);
						
						_loadLine = _labelData[target._touchLabel];
						setLineCommand();
					}
					break;
				case TouchPhase.MOVED: 
					if (target._moveLabel != null)
					{
						selectTouchEvent(TOUCH_TALK);
						_loadLine = _labelData[target._moveLabel];
						setLineCommand();
					}
					break;
				}
			}
		}
		
		/**タッチイベントエリア選択*/
		protected function selectTouchEvent(type:int):void
		{
			trace("セットタッチ:" + _loadLine + "\n");
			var i:int = 0;
			var touchTalk:Boolean = false;
			var touchItem:Boolean = false;
			var touchSelect:Boolean = false;
			var touchBattleMap:Boolean = false;
			switch (type)
			{
			case TOUCH_TALK: 
				touchTalk = true;
				break;
			case TOUCH_MAP: 
				touchItem = true;
				touchBattleMap = true;
				break;
			case TOUCH_SELECT: 
				touchSelect = true;
				break;
			}
			
			if (_topLayer != null)
			{
				_topLayer.touchable = touchSelect;
			}
			
			_touchBtn.touchable = touchTalk;
			
			for (i = 0; i < _layer.length; i++)
			{
				_layer[i].touchable = touchItem;
			}
			
			for (i = 0; i < _displayObject.length; i++)
			{
				_displayObject[i].touchable = touchItem;
			}
			
			/** タッチマップ */
			if (MainController.$.view.battleMap != null)
			{
				MainController.$.view.battleMap.touchable = touchBattleMap;
			}
		
		}
		
		//-----------------------------------------------------------------
		//
		// クリック処理
		//
		//-----------------------------------------------------------------
		/**クリック時*/
		protected function touchBtnHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_touchBtn);
			//タッチしているか
			if (touch)
			{
				//クリック上げた時
				switch (touch.phase)
				{
				//ボタン離す
				case TouchPhase.ENDED: 
					break;
				//マウスオーバー
				case TouchPhase.HOVER: 
					break;
				case TouchPhase.STATIONARY: 
					break;
				//ドラッグ
				case TouchPhase.MOVED: 
					break;
				//押した瞬間
				case TouchPhase.BEGAN: 
					clickBtn();
					break;
				}
			}
			else
			{
				_skipFlg = false;
			}
		
		}
		
		protected function clickBtn():void
		{
			if (!_msgCloseFlg)
			{
				//ウィンドウ書き込み中は処理しない
				if (_moveFlg)
				{
					return;
				}
				if (_msgFlg || _noTouch || _moveFlg)
				{
					return;
				}
				nextLine();
			}
		}
		
		/**次のラインを読み込む*/
		protected function nextLine():void
		{
			setLineCommand();
		}
		
		/**出撃完了*/
		public function compOrganized():void
		{
			setLineCommand();
		}
		
		public function get eventList():Vector.<MapEventData>
		{
			return _eventList;
		}
		
		public function set eventList(value:Vector.<MapEventData>):void
		{
			_eventList = value;
		}
		
		public function get playerVariable():Vector.<PlayerVariable>
		{
			return MainController.$.model.playerParam.playerVariable;
		}
		
		protected function setTopLayer():void
		{
			// 会話ウィンドウを最上段に
			setChildIndex(_talkArea, this.numChildren - 1);
			setChildIndex(_touchBtn, this.numChildren - 1);
		}
	
	}
}