package scene.talk
{
	import a24.tween.Tween24;
	import common.CommonDef;
	import common.CommonSystem;
	import common.util.CharaDataUtil;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CSprite;
	import system.custom.customSprite.ImageBoard;
	import database.master.MasterCharaData;
	import database.user.FaceData;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import scene.main.MainController;
	import scene.talk.common.MsgDef;
	import scene.talk.message.MessageWindow;
	
	/**
	 * ...
	 * @author
	 */
	public class StandTalkView extends TalkViewBase
	{
		//-----------------------------------------------------------------
		// const
		//-----------------------------------------------------------------
		
		protected const MESSAGE_POS_W:Array = [30, 60, 90];
		protected const MESSAGE_POS_H:Array = [20, 184, 348];
		//-----------------------------------------------------------------
		// value
		//-----------------------------------------------------------------
		
		//-----------------------------------------------------------------
		// processor
		//-----------------------------------------------------------------
		
		//-----------------------------------------------------------------
		// component
		//-----------------------------------------------------------------
		/**メッセージウィンドウ*/
		private var _messageWindow:MessageWindow = null;
		
		/***/
		private var _setMsgNextPos:Number = 0;
		/**キャラクターリスト*/
		private var _charaList:Vector.<ImageBoard> = null;
		/** キャラ表示レイヤ */
		protected var _charaLayer:int = 0;
		/**キャラレイヤー名*/
		protected var _charaLayerName:String = "";
		
		/**
		 * コンストラクタ
		 *
		 */
		public function StandTalkView()
		{
			super();
			
			_skipTimer = new Timer(SKIP_TIME, 1);
			_skipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, skipOn);
			_skipTimer.stop();
			_skipTimer.reset();
			
			//メッセージウィンドウ
			_messageWindow = null;
			_msgCloseBtn = null;
			_charaList = new Vector.<ImageBoard>;
			_charaLayer = 0;
			addChild(_talkArea);
		}
		
		//-----------------------------------------------------------------
		//
		// 終了時処理
		//
		//-----------------------------------------------------------------
		override public function dispose():void
		{
			disposecharaList(_charaList);
			
			if (_skipTimer != null)
			{
				_skipTimer.stop();
				_skipTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, skipOn);
				_skipTimer = null;
			}
			
			if (_msgTimer != null)
			{
				_msgTimer.stop();
				_msgTimer.removeEventListener(TimerEvent.TIMER, this.writeMessage);
			}
			if (_messageWindow != null)
			{
				_messageWindow.dispose();
			}
			if (_msgCloseBtn != null)
			{
				_msgCloseBtn.removeEventListener(TouchEvent.TOUCH, msgCloseHandler);
				_msgCloseBtn.dispose();
			}
			
			super.dispose();
		}
		
		/**リスト解放*/
		public function disposecharaList(list:Vector.<ImageBoard>):void
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
		// コマンド
		//
		//-----------------------------------------------------------------
		override protected function playCommand(line:String, command:Array, param:Object):void
		{
			trace("line:" + line);
			//最初の文字列で分岐
			switch (command[0].toLowerCase())
			{
			//-----------------------------------------------------レイヤー-----------------------------------------------------
			case "charalayer": 
				//レイヤー選択
				charaLayerSet(param);
				setLineCommand();
				break;
			case "alllayer": 
				allLayer(command, param);
				break;
			//-----------------------------------------------------キャラクター---------------------------------------------------
			case "settalkwindow": //ウィンドウ設置
			case "setstandimg": //キャラ画像設置
			case "setstandimage": //
			case "setchara": //
				setTalkFunc(command, param);
				break;
			/**
			   case "movemsg":
			   case "movemessage": //メッセージウィンドウ移動
			   case "moveicon": //メッセージウィンドウ移動
			   case "movechara": //メッセージウィンドウ移動
			   moveChara(command, param);
			   break;
			 */
			case "removemgs": 
			case "removemessage": //メッセージウィンドウ破棄
			case "removeicon": //メッセージウィンドウ破棄
			case "removechara": //メッセージウィンドウ破棄
				removeChara(command, param);
				break;
			case "setmove": 
				setCharaMoveFunc(command, param);
				setLineCommand();
				break;
			//-----------------------------------------------------会話-----------------------------------------------------
			case "talk": 
				standTalkFunc(command, param);
				break;
			case "msgclear": //ウィンドウ初期化
			case "clearmsg": //ウィンドウ初期化
			case "clearmessage": //ウィンドウ初期化
				msgClearFunc(param);
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
			case "br": 
				setBreakLine();
				setLineCommand();
				break;
			case "cn": 
				setConnectLine();
				setLineCommand();
				break;
			//-----------------------------------------------------メッセージウィンドウ---------------------------------------------------
			case "showmsg": 
			case "showmessage": 
				showMsgWindow(param);
				break;
			case "hidemsg": 
			case "hidemessage": 
				hideMsgWindow(param);
				break;
			
			//-----------------------------------------------------イベント追加------------------------------------------------
			case "settouchevent": 
				setCharaClickEvent(command, param);
				setLineCommand();
				break;
			//-----------------------------------------------------未使用---------------------------------------------------
			case "talktype": //会話タイプ設定
				setLineCommand();
				break;
			default: // ベースのコマンド一覧から呼び出す
				super.playCommand(line, command, param);
				break;
			}
		}
		
		/**
		 * コマンド読み込み
		 * @param line 読み込みライン
		 */
		override protected function setLineMsg(line:String):void
		{
			
			if (!_connectLineFlg)
			{
				if (_messageWindow != null && _talkMode == TALK_MSG)
				{
					if (_messageWindow.textArea.text.length > 0)
					{
						_messageWindow.addText("<br>");
					}
				}
				else if (_telop != null && _talkMode == TALK_TELOP)
				{
					if (_telop.textArea.text.length > 0)
					{
						_telop.addText("<br>");
					}
				}
			}
			_connectLineFlg = false;
			super.setLineMsg(line);
			//タイマー
			_msgTimer = new Timer(CommonDef.waitTime(LINE_READ_TIME, _skipFlg));
			_msgTimer.addEventListener(TimerEvent.TIMER, writeMessage);
			_msgTimer.start();
		}
		
		/**改行追加*/
		protected function setBreakLine():void
		{
			if (_messageWindow != null && _talkMode == TALK_MSG)
			{
				_messageWindow.addText("<br>");
			}
			else if (_telop != null && _talkMode == TALK_TELOP)
			{
				_telop.addText("<br>");
			}
		}
		
		/**末尾改行削除*/
		protected function setConnectLine():void
		{
			_connectLineFlg = true;
		}
		
		//-----------------------------------------------------------------
		//
		// メッセージ書き込み
		//
		//-----------------------------------------------------------------
		/**ウィンドウにメッセージ書き込み*/
		protected function writeMessage(e:TimerEvent):void
		{
			//読み込めなくなったら処理停止
			if (_msgStrage.length <= 0)
			{
				_msgTimer.stop();
				_msgTimer.removeEventListener(TimerEvent.TIMER, this.writeMessage);
				setLineCommand();
			}
			else
			{
				var end:int = 0;
				var cutNum:int = 1;
				
				if (_skipFlg)
				{
					switch (_talkMode)
					{
					case TALK_MSG: 
						_messageWindow.addText(_msgStrage);
						break;
					case TALK_TELOP: 
						_telop.addText(_msgStrage);
						break;
					default: 
						MainController.$.view.errorMessageEve("会話の設定に不具合があります", _loadLine);
						break;
					}
					_msgStrage = "";
				}
				else
				{
					//タグは一気に読み込む
					if (_msgStrage.substr(0, 1) === "<")
					{
						end = _msgStrage.search(">");
						
						switch (_talkMode)
						{
						case TALK_MSG: 
							_messageWindow.addText(_msgStrage.substr(0, end + 1));
							break;
						case TALK_TELOP: 
							_telop.addText(_msgStrage.substr(0, end + 1));
							break;
						default: 
							MainController.$.view.errorMessageEve("会話の設定に不具合があります", _loadLine);
							break;
						}
						
						cutNum = end + 1;
					}
					//セルフタグは一気に読み込む
					else if (_msgStrage.substr(0, 1) === "[")
					{
						end = _msgStrage.search("]");
						var command:String = _msgStrage.substr(1, end + 1);
						
						switch (command)
						{
						default: 
							break;
						}
						cutNum = end + 1;
					}
					//文字列一括も一気に読み込む
					if (_msgStrage.substr(0, 1) === "\"")
					{
						end = _msgStrage.search("\"");
						_msgSubStorage = _msgStrage.substr(0, end + 1);
						cutNum = end + 1;
						//タイマー切り替え
						_msgTimer.stop();
						_msgTimer.removeEventListener(TimerEvent.TIMER, this.writeMessage);
						_msgTimer.addEventListener(TimerEvent.TIMER, this.writeSubMessage);
						_msgTimer.start();
					}
					else
					{
						
						//特に指定が無ければ１文字ずつ読み込む
						switch (_talkMode)
						{
						case TALK_MSG: 
							_messageWindow.addText(_msgStrage.substr(0, 1));
							if (_setMsgNextPos < _messageWindow.textArea.maxVerticalScrollPosition)
							{
								_setMsgNextPos = _messageWindow.textArea.maxVerticalScrollPosition;
								Tween24.tween(_messageWindow.textArea, CommonDef.waitTime(0.1, _skipFlg), null, {verticalScrollPosition: _messageWindow.textArea.maxVerticalScrollPosition}).play();
							}
							
							break;
						case TALK_TELOP: 
							_telop.addText(_msgStrage.substr(0, 1));
							if (_talkNextPos < _telop.textArea.maxVerticalScrollPosition)
							{
								_talkNextPos = _telop.textArea.maxVerticalScrollPosition;
								Tween24.tween(_telop.textArea, CommonDef.waitTime(0.1, _skipFlg), null, {verticalScrollPosition: _telop.textArea.maxVerticalScrollPosition}).play();
							}
							
							break;
						default: 
							MainController.$.view.errorMessageEve("会話の設定に不具合があります", _loadLine);
							break;
						}
						
						cutNum = 1;
					}
					_msgStrage = _msgStrage.substr(cutNum);
				}
			}
		}
		
		/**ウィンドウにメッセージ書き込み、文字列オンリー処理*/
		protected function writeSubMessage(e:TimerEvent):void
		{
			//読み込めなくなったら処理切り替え
			if (_msgSubStorage.length <= 0)
			{
				_msgTimer.stop();
				_msgTimer.removeEventListener(TimerEvent.TIMER, this.writeSubMessage);
				_msgTimer.addEventListener(TimerEvent.TIMER, this.writeMessage);
				_msgTimer.start();
			}
			else
			{
				var cutNum:int = 1;
				
				switch (_talkMode)
				{
				case TALK_MSG: 
					_messageWindow.addText(_msgSubStorage.substr(0, 1));
					if (_setMsgNextPos < _messageWindow.textArea.maxVerticalScrollPosition)
					{
						_setMsgNextPos = _messageWindow.textArea.maxVerticalScrollPosition;
						Tween24.tween(_messageWindow.textArea, CommonDef.waitTime(0.1, _skipFlg), null, {verticalScrollPosition: _messageWindow.textArea.maxVerticalScrollPosition}).play();
					}
					break;
				case TALK_TELOP: 
					_telop.addText(_msgSubStorage.substr(0, 1));
					if (_talkNextPos < _telop.textArea.maxVerticalScrollPosition)
					{
						_talkNextPos = _telop.textArea.maxVerticalScrollPosition;
						Tween24.tween(_telop.textArea, CommonDef.waitTime(0.1, _skipFlg), null, {verticalScrollPosition: _telop.textArea.maxVerticalScrollPosition}).play();
					}
					break;
				default: 
					MainController.$.view.errorMessageEve("会話の設定に不具合があります", _loadLine);
					break;
				}
				
				cutNum = 1;
				_msgSubStorage = _msgSubStorage.substr(cutNum);
			}
		}
		
		//-----------------------------------------------------------------
		//
		// メッセージ関連ボタン処理
		//
		//-----------------------------------------------------------------
		
		private function msgCloseHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_msgCloseBtn);
			//タッチしているか
			if (touch)
			{
				//クリック上げた時
				switch (touch.phase)
				{
				//ボタン離す
				case TouchPhase.ENDED: 
					_msgCloseBtn.color = 0xFFFFFF;
					msgCloseFunc();
					break;
				//マウスオーバー
				case TouchPhase.HOVER: 
					_msgCloseBtn.color = 0xAAAAAA;
					break;
				case TouchPhase.STATIONARY: 
					break;
				//ドラッグ
				case TouchPhase.MOVED: 
					break;
				//押した瞬間
				case TouchPhase.BEGAN: 
					break;
				}
			}
			else
			{
				_msgCloseBtn.color = 0xFFFFFF;
			}
		}
		
		override protected function touchBtnHandler(event:TouchEvent):void
		{
			super.touchBtnHandler(event);
			
			var touch:Touch = event.getTouch(_touchBtn);
			//タッチしているか
			if (touch)
			{
				//クリック上げた時
				switch (touch.phase)
				{
				//ボタン離す
				case TouchPhase.ENDED: 
					if (_msgCloseFlg)
					{
						msgOpenFunc();
					}
					_skipTimer.stop();
					_skipTimer.reset();
					_skipFlg = false;
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
					if (!_msgCloseFlg)
					{
						_skipTimer.stop();
						_skipTimer.reset();
						_skipTimer.start();
					}
					break;
				}
			}
			else
			{
				if (_skipTimer != null)
				{
					_skipTimer.stop();
					_skipTimer.reset();
				}
				_skipFlg = false;
			}
		
		}
		
		//スキップ開始
		protected function skipOn(timer:TimerEvent):void
		{
			_skipTimer.stop();
			_skipTimer.reset();
			_skipFlg = true;
			clickBtn();
		}
		
		/**メッセージ非表示*/
		private function msgCloseFunc():void
		{
			_messageWindow.visible = false;
			_msgCloseBtn.visible = false;
			_msgCloseFlg = true;
		}
		
		/**メッセージ表示*/
		private function msgOpenFunc():void
		{
			_messageWindow.visible = true;
			_msgCloseBtn.visible = true;
			_msgCloseFlg = false;
		}
		
		//-----------------------------------------------------------------
		//
		// 会話タイプ処理
		//
		//-----------------------------------------------------------------
		
		/**メッセージ初期化*/
		protected function msgInit():void
		{
			_messageWindow = new MessageWindow();
			_messageWindow.touchable = false;
			_messageWindow.visible = false;
			_messageWindow.alpha = 0;
			_messageWindow.x = (CommonDef.WINDOW_W - _messageWindow.width) / 2;
			_messageWindow.y = 360;
			
			_msgCloseBtn = new CImage(MainController.$.imgAsset.getTexture("btn_close"));
			_msgCloseBtn.visible = false;
			_msgCloseBtn.alpha = 0;
			_msgCloseBtn.x = 680;
			_msgCloseBtn.y = 352;
			_msgCloseBtn.width = 96;
			_msgCloseBtn.height = 32;
			addChild(_msgCloseBtn);
			
			_msgCloseBtn.addEventListener(TouchEvent.TOUCH, msgCloseHandler);
		
		}
		
		/**会話ウィンドウ表示*/
		private function showMsgWindow(param:Object):void
		{
			var time:Number = 0;
			if (param.hasOwnProperty("time"))
			{
				time = param.time;
			}
			
			// メッセージウィンドウ初期化
			if (_messageWindow == null)
			{
				/*
				   _messageWindow = new MessageWindow();
				   _messageWindow.touchable = false;
				   _messageWindow.visible = false;
				   _messageWindow.alpha = 0;
				   _messageWindow.x = (CommonDef.WINDOW_W - _messageWindow.width) / 2;
				   _messageWindow.y = 360;
				   _talkArea.addChild(_messageWindow);
				 */
				
				msgInit();
				
			}
			Tween24.parallel(Tween24.tween(_messageWindow, CommonDef.waitTime(time, _skipFlg), Tween24.ease.BackInOut).fadeIn(), Tween24.tween(_msgCloseBtn, CommonDef.waitTime(time, _skipFlg), Tween24.ease.BackInOut).fadeIn()).onComplete(function():void
			{
				setLineCommand();
			}).play();
		
		}
		
		private function hideMsgWindow(param:Object):void
		{
			_moveFlg = true;
			var time:Number = 0;
			if (param.hasOwnProperty("time"))
			{
				time = param.time;
			}
			
			if (_messageWindow != null)
			{
				
				Tween24.parallel(Tween24.tween(_messageWindow, CommonDef.waitTime(time, _skipFlg), Tween24.ease.BackInOut).fadeOut(), Tween24.tween(_msgCloseBtn, CommonDef.waitTime(time, _skipFlg), Tween24.ease.BackInOut).fadeOut()).onComplete(function():void
				{
					_moveFlg = false;
					setLineCommand();
				}).play();
			}
			else
			{
				_moveFlg = false;
				setLineCommand();
			}
		}
		
		/**
		 * 立ち絵会話処理
		 * @param command コマンド
		 * @param param パラメーターオブジェクト
		 */
		private function standTalkFunc(command:Array, param:Object):void
		{
			_setMsgNextPos = 0;
			
			// メッセージウィンドウ初期化
			if (_messageWindow == null)
			{
				
				msgInit();
				
				_messageWindow.setName(command[1]);
				_talkArea.addChild(_messageWindow);
				changeFace(command);
				Tween24.parallel(Tween24.tween(_messageWindow, CommonDef.waitTime(0.5, _skipFlg), Tween24.ease.BackInOut).fadeIn(), Tween24.tween(_msgCloseBtn, CommonDef.waitTime(0.5, _skipFlg), Tween24.ease.BackInOut).fadeIn()).onComplete(function():void
				{
					setLineCommand();
				}).play();
			}
			else
			{
				if (_messageWindow.visible == false || _messageWindow.alpha <= 0)
				{
					Tween24.parallel(Tween24.tween(_messageWindow, CommonDef.waitTime(0.5, _skipFlg), Tween24.ease.BackInOut).fadeIn(), Tween24.tween(_msgCloseBtn, CommonDef.waitTime(0.5, _skipFlg), Tween24.ease.BackInOut).fadeIn()).onComplete(function():void
					{
						talkAction();
					}).play();
				}
				else
				{
					talkAction();
				}
				
				function talkAction():void
				{
					_messageWindow.setName(command[1]);
					//　キャラ切り替え時名前変更
					if (_messageWindow.name != command[1])
					{
						_messageWindow.clearText();
					}
					
					changeFace(command);
					
					_talkArea.addChild(_messageWindow);
					setLineCommand();
				}
			}
		
		}
		
		/**表情変更*/
		protected function changeFace(command:Array):void
		{
			
			if (command[1] === "システム")
			{
				return;
			}
			
			var img:ImageBoard = null;
			var i:int = 0;
			var j:int = 0;
			var k:int = 0;
			var selectData:MasterCharaData = CharaDataUtil.getMasterCharaDataName(command[1]);
			//var imgData:FaceData = MainController.$.model.getCharaImgDataFromName(selectData.charaImgName);
			var imgData:FaceData = MainController.$.model.getCharaImgDataFromName(command[1]);
			var showList:Vector.<String> = new Vector.<String>;
			
			if (imgData != null)
			{
				//表情変更
				for (i = 0; i < _charaList.length; i++)
				{
					if (_charaList[i].charaName === imgData.name || _charaList[i].charaName === imgData.nickName)
					{
						img = _charaList[i];
						
						//初期状態でベーシック設定
						if (img.imgPartsList.length <= 0)
						{
							//ベーシックリスト設定
							for (i = 0; i < imgData.basicList.length; i++)
							{
								showList[i] = imgData.basicList[i];
							}
						}
						else
						{
							showList = img.imgPartsList;
						}
						
						// 表情入れ替え
						for (j = 2; j < command.length; j++)
						{
							var str:String = command[j];
							if (str.indexOf(":") >= 0)
							{
								continue;
							}
							
							//ベーシックリスト設定
							if (str === "デフォルト" || str.toLowerCase() === "default")
							{
								for (i = 0; i < imgData.basicList.length; i++)
								{
									showList[i] = imgData.basicList[i];
								}
							}
							
							//表情パーツ設定
							for (k = 0; k < imgData.imgList.length; k++)
							{
								if (str === imgData.imgList[k].name)
								{
									showList[imgData.imgList[k].layer] = imgData.imgList[k].name;
								}
							}
						}
						img.imgPartsList = showList;
						break;
					}
				}
				if (img != null)
				{
					img.imgClear();
					for (i = 0; i < showList.length; i++)
					{
						var faceImg:CImage = new CImage(MainController.$.imgAsset.getTexture(imgData.getFileName(showList[i])));
						img.addImage(faceImg, imgData.defaultType);
					}
				}
			}
		}
		
		/**
		 * 立ち絵セット
		 * @param	command
		 * @param	param
		 */
		protected function setTalkFunc(command:Array, param:Object):void
		{
			_moveFlg = true;
			var name:String = param.name;
			var i:int = 0;
			var j:int = 0;
			
			if (name != "システム")
			{
				var showList:Vector.<String> = new Vector.<String>;
				var img:ImageBoard = new ImageBoard();
				img.touchable = false;
				img.visible = false;
				
				img.alpha = 0;
				//var selectData:MasterCharaData = CharaDataUtil.getMasterCharaDataName(name);
				var imgData:FaceData = MainController.$.model.getCharaImgDataFromName(name);
				
				//画像セット
				img.setAdd(160, 160);
				
				for (i = 0; i < imgData.basicList.length; i++)
				{
					showList[i] = imgData.basicList[i];
				}
				
				// 表情入れ替え
				for (i = 1; i < command.length; i++)
				{
					var str:String = command[i];
					if (str.indexOf(":") >= 0)
					{
						continue;
					}
					
					for (j = 0; j < imgData.imgList.length; j++)
					{
						if (str === imgData.imgList[j].name)
						{
							showList[imgData.imgList[j].layer] = imgData.imgList[j].name;
							
						}
					}
				}
				
				img.imgPartsList = showList;
				
				for (i = 0; i < showList.length; i++)
				{
					//var faceImg:CImage = new CImage(TextureManager.loadTexture(imgData.imgUrl, imgData.getFileName(showList[i]), TextureManager.TYPE_CHARA));
					var faceImg:CImage = new CImage(MainController.$.imgAsset.getTexture(imgData.getFileName(showList[i])));
					img.addImage(faceImg, imgData.defaultType);
				}
				
				img.name = name;
				img.charaName = imgData.name;
				img.nickName = imgData.nickName;
				
				_charaList.push(img);
				_layer[_charaLayer].addChild(img);
				
				/**
				   if (param.hasOwnProperty(alpha))
				   {
				   img.alpha = param.alpha;
				   }
				 */
				
				if (param.hasOwnProperty("pos"))
				{
					img.x = param.pos * 232;
					if (img.height < CommonDef.WINDOW_H)
					{
						param.y = CommonDef.WINDOW_H - img.height - img.zeroPos;
					}
					else
					{
						param.y = -img.zeroPos;
					}
				}
				else if (param.hasOwnProperty("x") || param.hasOwnProperty("y"))
				{
					if (!param.hasOwnProperty("x"))
					{
						param.x = (CommonDef.WINDOW_W - img.width) / 2;
					}
					if (!param.hasOwnProperty("y"))
					{
						if (img.height < CommonDef.WINDOW_H)
						{
							param.y = CommonDef.WINDOW_H - img.height - img.zeroPos;
						}
						else
						{
							param.y = -img.zeroPos;
						}
					}
					img.x = param.x - img.width / 2;
					img.y = param.y;
				}
				else
				{
					img.x = (CommonDef.WINDOW_W - img.width) / 2;
					if (img.height < CommonDef.WINDOW_H)
					{
						img.y = CommonDef.WINDOW_H - img.height - img.zeroPos;
					}
					else
					{
						img.y = -img.zeroPos;
					}
				}
				
				var time:Number = 0;
				var setAlpha:Number = 1;
				if (param.hasOwnProperty("time"))
				{
					time = param.time;
				}
				
				if (param.hasOwnProperty("alpha"))
				{
					setAlpha = param.alpha;
				}
				
				if (setAlpha > 0)
				{
					img.visible = true;
				}
				
				if (time <= 0)
				{
					img.visible = true;
					img.alpha = setAlpha;
					setLineCommand();
				}
				else
				{
					Tween24.tween(img, CommonDef.waitTime(time, _skipFlg), Tween24.ease.BackInOut).alpha(setAlpha).onComplete(function():void
					{
						_moveFlg = false;
						setLineCommand();
					}).play();
				}
			}
			else
			{
				_moveFlg = false;
				setLineCommand();
			}
		}
		
		protected function setCharaMoveFunc(command:Array, param:Object):void
		{
			super.setMoveFunc(command, param);
			var num:int = 0;
			var tween:Tween24;
			for (var i:int = 0; i < _charaList.length; i++)
			{
				if (_charaList[i].name != null && (_charaList[i].charaName === param.chara || _charaList[i].nickName === param.chara))
				{
					tween = MsgDef.setTweenParam(_charaList[i], param, _skipFlg);
					_tweenAry[_tweenNum].push(tween);
					break;
				}
			}
		}
		
		/** メッセージクリア関数 */
		protected function msgClearFunc(param:Object):void
		{
			var allFlg:int = 0;
			
			if (param.hasOwnProperty("type"))
			{
				if (param.type === "all")
				{
					allFlg = 1;
				}
				else if (param.type === "normal")
				{
					allFlg = 0;
				}
			}
			
			if (_messageWindow != null)
			{
				if (allFlg == 0)
				{
					_messageWindow.clearText();
				}
				else
				{
					_messageWindow.deleteText();
				}
				_messageWindow.textArea.verticalScrollPosition = 0;
			}
			_setMsgNextPos = 0;
			_msgClearFlg = false;
			setLineCommand();
		}
		
		/** 会話キャラ変更 */
		protected function talkChangeFunc():void
		{
			_messageWindow.clearText();
			_messageWindow.textArea.verticalScrollPosition = 0;
			_msgClearFlg = false;
			
			_talkChangeFlg = false;
			
			var command:Array = new Array();
			var line:String = _textData[_loadLine];
			_loadLine++;
			command = line.split(" ");
			//顔画像状態で読み込み
			setLineCommand();
		}
		
		protected function moveChara(command:Array, param:Object):void
		{
			_noTouch = true;
			var tween:Tween24 = null;
			var pos:int = 0;
			
			if (param.hasOwnProperty("name"))
			{
				for (var i:int = 0; i < _charaList.length; i++)
				{
					if (_charaList[i].name === param.name)
					{
						pos = i;
						break;
					}
				}
			}
			else if (param.hasOwnProperty("pos"))
			{
				pos = param.pos;
			}
			
			tween = MsgDef.setTweenParam(_charaList[pos], param, _skipFlg);
			tween.onComplete(setLineCommand);
			tween.play();
		}
		
		protected function removeChara(command:Array, param:Object):void
		{
			for (var i:int = 0; i < _charaList.length; i++)
			{
				if (_charaList[i].name === param.name || _charaList[i].nickName === param.name)
				{
					var charaImg:ImageBoard = _charaList[i];
					if (charaImg != null)
					{
						if (charaImg.parent != null)
						{
							charaImg.parent.removeChild(charaImg);
						}
						
						charaImg.removeEventListener(TouchEvent.TOUCH, objectTouch);
						charaImg.dispose();
						charaImg = null;
					}
					_charaList.splice(i, 1);
				}
			}
			
			setLineCommand();
		}
		
		/** キャラ用レイヤー */
		protected function charaLayerSet(param:Object):void
		{
			var i:int = 0;
			if (param.hasOwnProperty("name"))
			{
				for (i = 0; i < _layer.length; i++)
				{
					if (param.name === _layer[i].name)
					{
						_charaLayer = i;
						_charaLayerName = param.name;
						break;
					}
				}
			}
			else if (param.hasOwnProperty("number"))
			{
				_charaLayer = i;
				if (_layer.length < i)
				{
					_charaLayerName = _layer[i].name;
				}
				else
				{
					_charaLayerName = _layer[_layer.length].name;
				}
			}
			else
			{
				_charaLayer = _layer.length - 1;
				if (_layer.length > 0)
				{
					_charaLayerName = _layer[_layer.length].name;
				}
			}
			
			if (_charaLayer < 0)
			{
				_charaLayer = 0;
			}
			if (_charaLayer >= _layer.length)
			{
				_charaLayer = _layer.length - 1;
			}
		}
		
		//-----------------------------------------------------------------
		//
		// クリックイベント追加
		//
		//-----------------------------------------------------------------
		
		protected function setCharaClickEvent(command:Array, param:Object):void
		{
			super.setClickEvent(command, param);
			if (param.hasOwnProperty("chara"))
			{
				var i:int = 0;
				for (i = 0; i < _charaList.length; i++)
				{
					if (_charaList[i] is ImageBoard)
					{
						var img:ImageBoard = _displayObject[i] as ImageBoard;
						
						if (_charaList[i].name === param.chara)
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
		
		override protected function addLayer(param:Object):void
		{
			super.addLayer(param);
			if (_msgCloseBtn != null)
			{
				setChildIndex(_msgCloseBtn, this.numChildren - 1);
			}
		}
		
		override protected function allLayer(command:Array, param:Object):void
		{
			var tween:Tween24 = null;
			var ary:Array = new Array();
			var charaFlg:Boolean = false;
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
			if (param.hasOwnProperty("chara"))
			{
				if (param.chara === "hide")
				{
					charaFlg = false;
				}
				else if (param.chara === "show")
				{
					charaFlg = true;
				}
				
			}
			
			for (i = 0; i < _layer.length; i++)
			{
				if (charaFlg && i == _charaLayer)
				{
					continue;
				}
				
				ary.push(Tween24.tween(_layer[i], CommonDef.waitTime(time, _skipFlg)).alpha(alpha));
			}
			
			tween = Tween24.parallel(ary).onComplete(compLayerTween);
			tween.play();
		}
		
		override protected function resetLayer():void
		{
			super.resetLayer();
			_charaLayer = 0;
			var i:int = 0;
			for (i = 0; i < _charaList.length; )
			{
				_charaList[i].dispose();
				var img:ImageBoard = _charaList.pop();
				img = null;
			}
		
		}
		
		/**レイヤー消去*/
		override protected function deleteLayer(param:Object):void
		{
			var i:int = 0;
			var layer:CSprite = null;
			layer = getSliceLayer(param);
			deleteLayerObject(layer);
			deleteLayerCharacter(layer);
			layer.parent.removeChild(layer);
			layer.dispose();
			layer = null;
			for (i = 0; i < _layer.length; i++)
			{
				if (_layer[i].name === _charaLayerName)
				{
					_charaLayer = i;
					break;
				}
			}
		
		}
		
		/**レイヤー上オブジェクト全消去*/
		override protected function clearLayer(param:Object):void
		{
			var layer:CSprite = null;
			layer = getLayer(param);
			deleteLayerObject(layer);
			deleteLayerCharacter(layer);
		}
		
		protected function deleteLayerCharacter(layer:CSprite):void
		{
			var i:int = 0;
			var obj:ImageBoard = null;
			// 同一レイヤーのオブジェクトのイベント削除
			if (layer != null)
			{
				for (i = 0; i < _charaList.length; i++)
				{
					if (_charaList[i].parent === layer)
					{
						//obj = _charaList[i];
						obj = _charaList.splice(i, 1)[0];
						obj.removeEventListener(TouchEvent.TOUCH, objectTouch);
						layer.removeChild(obj);
						obj.dispose();
						obj = null;
						i--;
					}
				}
			}
		}
		
		override protected function initLayer():void
		{
			super.initLayer();
			_charaLayer = 0;
			addChild(_talkArea);
		}
		
		override protected function resetAll():void
		{
			super.resetAll();
		}
		
		override protected function setTopLayer():void
		{
			super.setTopLayer();
			if (_msgCloseBtn != null)
			{
				setChildIndex(_msgCloseBtn, this.numChildren - 1);
			}
		}
	
	}
}