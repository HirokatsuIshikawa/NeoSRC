package scene.talk
{
	import a24.tween.Tween24;
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CImage;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import scene.main.MainController;
	import scene.talk.common.MsgDef;
	import scene.talk.message.FaceMessageWindow;
	
	/**
	 * ...
	 * @author
	 */
	public class IconTalkView extends TalkViewBase
	{
		//-----------------------------------------------------------------
		// const
		//-----------------------------------------------------------------
		//ウィンドウ位置
		protected const MESSAGE_POS_W:Array = [30, 60, 90];
		protected const MESSAGE_POS_H:Array = [20, 184, 348];
		//会話タイプ
		protected const TALK_TYPE_SINGLE:int = 1;
		protected const TALK_TYPE_TRIPLE:int = 2;
		//-----------------------------------------------------------------
		// value
		//-----------------------------------------------------------------
		/**現在喋っているキャラ*/
		private var _nowTalkChara:int = 0;
		/**現在の会話タイプ*/
		private var _nowTalkType:int = 0;
		/**メッセージ更新時の位置*/
		protected var _setNextPos:Vector.<Number>;
		
		//-----------------------------------------------------------------
		// processor
		//-----------------------------------------------------------------
		
		//-----------------------------------------------------------------
		// component
		//-----------------------------------------------------------------
		/**メッセージウィンドウ*/
		protected var _faceMessageWindow:Vector.<FaceMessageWindow> = null;
		
		/**
		 * コンストラクタ
		 *
		 */
		public function IconTalkView()
		{
			var i:int = 0;
			super();
			
			_skipTimer = new Timer(SKIP_TIME, 1);
			_skipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, skipOn);
			_skipTimer.stop();
			_skipTimer.reset();
			_nowTalkType = TALK_TYPE_SINGLE;
			
			//メッセージウィンドウ
			_faceMessageWindow = new Vector.<FaceMessageWindow>;
			_setNextPos = new Vector.<Number>;
		}
		
		override public function dispose():void
		{
			
			if (_msgCloseBtn != null)
			{
				_msgCloseBtn.removeEventListener(TouchEvent.TOUCH, msgCloseHandler);
				_msgCloseBtn.dispose();
			}
			
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
			
			CommonDef.disposeList([_faceMessageWindow]);
			
			super.dispose();
		}
		
		//-----------------------------------------------------------------
		//
		// コマンド
		//
		//-----------------------------------------------------------------
		override protected function playCommand(line:String, command:Array, param:Object):void
		{
			//最初の文字列で分岐
			switch (command[0].toLowerCase())
			{
			//-----------------------------------------------------会話-----------------------------------------------------
			case "talk": //会話立ち絵設定
				talkFunc(command, param);
				break;
			case "talktype": //会話タイプ設定
				setTalkType(command[1]);
				break;
			case "msgclear": //ウィンドウ初期化
				msgClearFunc();
				break;
			case "settalkwindow": //ウィンドウ設置
			case "setstandimg": //キャラ画像設置
			case "setstandimage": //
				setTalkFunc(command, param);
				break;
			case "movemsg": 
			case "movemessage": //メッセージウィンドウ移動
			case "moveicon": //メッセージウィンドウ移動
				moveMessageWindow(command, param);
				break;
			case "removemgs": 
			case "removemessage": //メッセージウィンドウ破棄
			case "removeicon": //メッセージウィンドウ破棄
				removeMessageWindow(command, param);
				break;
			//-----------------------------------------------------未使用-----------------------------------------------------
			case "showmsg": 
			case "showmessage": 
			case "hidemsg": 
			case "hidemessage": 
				break;
			
			//-----------------------------------------------------ベースクラスのリストを使用---------------------------------------------------
			default: 
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
			if (_faceMessageWindow[_nowTalkChara].textArea.text.length > 0)
			{
				_faceMessageWindow[_nowTalkChara].addText("<br>");
			}
			super.setLineMsg(line);
			//タイマー
			_msgTimer = new Timer(CommonDef.waitTime(LINE_READ_TIME, _skipFlg));
			_msgTimer.addEventListener(TimerEvent.TIMER, writeMessage);
			_msgTimer.start();
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
				_msgTimer.removeEventListener(TimerEvent.TIMER, writeMessage);
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
						_faceMessageWindow[_nowTalkChara].addText(_msgStrage);
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
							_faceMessageWindow[_nowTalkChara].addText(_msgStrage.substr(0, end + 1));
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
						//_faceMessageWindow[_nowTalkChara].addText(_msgStrage.substr(0, end + 1));
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
						_msgTimer.removeEventListener(TimerEvent.TIMER, writeMessage);
						_msgTimer.addEventListener(TimerEvent.TIMER, writeSubMessage);
						_msgTimer.start();
						
					}
					else
					{
						//特に指定が無ければ１文字ずつ読み込む
						
						//特に指定が無ければ１文字ずつ読み込む
						switch (_talkMode)
						{
						case TALK_MSG: 
							_faceMessageWindow[_nowTalkChara].addText(_msgStrage.substr(0, 1));
							if (_setNextPos[_nowTalkChara] < _faceMessageWindow[_nowTalkChara].textArea.maxVerticalScrollPosition)
							{
								_setNextPos[_nowTalkChara] = _faceMessageWindow[_nowTalkChara].textArea.maxVerticalScrollPosition;
								Tween24.tween(_faceMessageWindow[_nowTalkChara].textArea, CommonDef.waitTime(0.1, _skipFlg), null, {verticalScrollPosition: _faceMessageWindow[_nowTalkChara].textArea.maxVerticalScrollPosition}).play();
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
				_msgTimer.removeEventListener(TimerEvent.TIMER, writeSubMessage);
				_msgTimer.addEventListener(TimerEvent.TIMER, writeMessage);
				_msgTimer.start();
			}
			else
			{
				var cutNum:int = 1;
				
				switch (_talkMode)
				{
				case TALK_MSG: 
					_faceMessageWindow[_nowTalkChara].addText(_msgSubStorage.substr(0, 1));
					if (_setNextPos[_nowTalkChara] < _faceMessageWindow[_nowTalkChara].textArea.maxVerticalScrollPosition)
					{
						_setNextPos[_nowTalkChara] = _faceMessageWindow[_nowTalkChara].textArea.maxVerticalScrollPosition;
						Tween24.tween(_faceMessageWindow[_nowTalkChara].textArea, CommonDef.waitTime(0.1, _skipFlg), null, {verticalScrollPosition: _faceMessageWindow[_nowTalkChara].textArea.maxVerticalScrollPosition}).play();
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
		
		protected function moveMessageWindow(command:Array, param:Object):void
		{
			_noTouch = true;
			var tween:Tween24 = null;
			var pos:int = 0;
			
			if (param.hasOwnProperty("name"))
			{
				for (var i:int = 0; i < _faceMessageWindow.length; i++)
				{
					if (_faceMessageWindow[i].charaName === param.name)
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
			
			tween = MsgDef.setTweenParam(_faceMessageWindow[pos], param, _skipFlg);
			tween.onComplete(setLineCommand);
			tween.play();
		}
		
		protected function removeMessageWindow(command:Array, param:Object):void
		{
			for (var i:int = 0; i < _faceMessageWindow.length; i++)
			{
				if (_faceMessageWindow[i].name === param.name)
				{
					var window:FaceMessageWindow = _faceMessageWindow[i];
					if (window != null)
					{
						if (window.parent != null)
						{
							window.parent.removeChild(window);
						}
						window.dispose();
					}
					_faceMessageWindow.slice(i, 1);
				}
			}
			
			setLineCommand();
		}
		
		//-----------------------------------------------------------------
		//
		// 会話タイプ処理
		//
		//-----------------------------------------------------------------
		
		/**
		 * 会話処理
		 * @param command コマンド
		 * @param param パラメーターオブジェクト
		 */
		protected function talkFunc(command:Array, param:Object):void
		{
			
			switch (_nowTalkType)
			{
			case TALK_TYPE_SINGLE: 
				singleTalkFunc(command, param);
				break;
			case TALK_TYPE_TRIPLE: 
				tripleTalkFunc(command, param);
				break;
			}
		}
		
		/**
		 * 会話ウィンドウセット処理
		 * @param	command
		 * @param	param
		 */
		
		protected function setTalkFunc(command:Array, param:Object):void
		{
			switch (_nowTalkType)
			{
			case TALK_TYPE_SINGLE: 
				break;
			case TALK_TYPE_TRIPLE: 
				setTripleTalkWindow(command, param);
				break;
			}
		}
		
		/**
		 * 三段会話ウィンドウセット
		 * @param	command
		 * @param	param
		 */
		protected function setTripleTalkWindow(command:Array, param:Object):void
		{
			var i:int = _faceMessageWindow.length;
			
			_nowTalkChara = i;
			
			_setNextPos[i] = 0;
			_faceMessageWindow[i] = new FaceMessageWindow();
			_faceMessageWindow[i].touchable = false;
			_faceMessageWindow[i].visible = false;
			
			_faceMessageWindow[i].setImage(param.name, command);
			_faceMessageWindow[i].alpha = 0;
			
			if (param.hasOwnProperty("pos"))
			{
				_faceMessageWindow[i].x = MESSAGE_POS_W[param.pos];
				_faceMessageWindow[i].y = MESSAGE_POS_H[param.pos];
			}
			else if (param.hasOwnProperty("x") || param.hasOwnProperty("y"))
			{
				if (!param.hasOwnProperty("x"))
				{
					param.x = (CommonDef.WINDOW_W - _faceMessageWindow[i].width) / 2;
				}
				if (!param.hasOwnProperty("y"))
				{
					param.y = MESSAGE_POS_H[i];
				}
				
				_faceMessageWindow[i].x = param.x;
				_faceMessageWindow[i].y = param.y;
			}
			else
			{
				_faceMessageWindow[i].x = (CommonDef.WINDOW_W - _faceMessageWindow[i].width) / 2;
				_faceMessageWindow[i].y = 300;
			}
			_talkArea.addChild(_faceMessageWindow[i]);
			Tween24.tween(_faceMessageWindow[i], CommonDef.waitTime(0.3, _skipFlg), Tween24.ease.BackInOut).fadeIn().onComplete(function():void
			{
				setLineCommand();
			}).play();
		
		}
		
		/**
		 * 三段会話処理
		 * @param command コマンド
		 * @param param パラメーターオブジェクト
		 */
		protected function singleTalkFunc(command:Array, param:Object):void
		{
			var i:int = 0;
			var setcomp:Boolean = false;
			
			if (_faceMessageWindow.length > 0 && command[1] == _faceMessageWindow[i].charaName)
			{
				
				if (_faceMessageWindow[_nowTalkChara].charaName != command[i])
				{
					_faceMessageWindow[i].clearText();
				}
				
				_faceMessageWindow[i].setImage(command[1], command);
				_nowTalkChara = i;
				setLineCommand();
				setcomp = true;
			}
			
			//　既存の物に該当しない場合
			if (!setcomp)
			{
				_setNextPos[i] = 0;
				_faceMessageWindow[i] = new FaceMessageWindow();
				_faceMessageWindow[i].touchable = false;
				_faceMessageWindow[i].visible = false;
				
				_nowTalkChara = i;
				_faceMessageWindow[i].setImage(command[1], command);
				_faceMessageWindow[i].alpha = 0;
				
				_faceMessageWindow[i].x = (CommonDef.WINDOW_W - _faceMessageWindow[i].width) / 2;
				_faceMessageWindow[i].y = 300;
				
				_talkArea.addChild(_faceMessageWindow[i]);
				
				Tween24.tween(_faceMessageWindow[i], CommonDef.waitTime(0.5, _skipFlg), Tween24.ease.BackInOut).fadeIn().onComplete(function():void
				{
					setLineCommand();
				}).play();
				
			}
		}
		
		/**
		 * 三段会話処理
		 * @param command コマンド
		 * @param param パラメーターオブジェクト
		 */
		protected function tripleTalkFunc(command:Array, param:Object):void
		{
			var i:int = 0;
			var setcomp:Boolean = false;
			//顔画像状態で読み込み
			//var faceBase:ImageBoard = MainController.$.model.getCharaBaseImg(command[1], MainModel.IMG_BOARD_FACE);
			for (i = 0; i < _faceMessageWindow.length; i++)
			{
				if (command[1] === _faceMessageWindow[i].charaName)
				{
					if (_faceMessageWindow[_nowTalkChara].charaName != command[i])
					{
						_faceMessageWindow[i].clearText();
					}
					
					_faceMessageWindow[i].setImage(command[1], command);
					_nowTalkChara = i;
					setLineCommand();
					setcomp = true;
					break;
				}
			}
			
			//　既存の物に該当しない場合
			if (!setcomp)
			{
				for (i = 0; i < MESSAGE_POS_H.length; i++)
				{
					if (_faceMessageWindow[i] == null || _faceMessageWindow[i].charaName == null || _faceMessageWindow[i].charaName === "")
					{
						_faceMessageWindow[i] = new FaceMessageWindow();
						_faceMessageWindow[i].touchable = false;
						_faceMessageWindow[i].visible = false;
						
						_nowTalkChara = i;
						_faceMessageWindow[i].setImage(command[1], command);
						_faceMessageWindow[i].alpha = 0;
						_talkArea.addChild(_faceMessageWindow[i]);
						Tween24.tween(_faceMessageWindow[i], CommonDef.waitTime(0.5, _skipFlg), Tween24.ease.BackInOut).fadeIn().onComplete(function():void
						{
							setLineCommand();
						}).play();
						
						break;
					}
				}
			}
		
		}
		
		/**オブジェクト消去*/
		override protected function resetAll():void
		{
			super.resetAll();
			resetMessageWindow();
		}
		
		/**
		 * メッセージウィンドウ初期化
		 */
		protected function resetMessageWindow():void
		{
			var i:int = 0;
			for (i = 0; i < _faceMessageWindow.length; )
			{
				var msg:FaceMessageWindow = _faceMessageWindow[i];
				if (msg != null)
				{
					if (msg.parent != null)
					{
						msg.parent.removeChild(msg);
					}
					msg.dispose()
				}
				_faceMessageWindow.shift();
			}
		}
		
		/** メッセージクリア関数 */
		protected function msgClearFunc():void
		{
			_faceMessageWindow[_nowTalkChara].clearText();
			_faceMessageWindow[_nowTalkChara].textArea.verticalScrollPosition = 0;
			_setNextPos[_nowTalkChara] = 0;
			_msgClearFlg = false;
			setLineCommand();
		}
		
		/** 会話キャラ変更 */
		protected function talkChangeFunc():void
		{
			_faceMessageWindow[_nowTalkChara].clearText();
			_faceMessageWindow[_nowTalkChara].textArea.verticalScrollPosition = 0;
			_setNextPos[_nowTalkChara] = 0;
			_msgClearFlg = false;
			
			_talkChangeFlg = false;
			
			var command:Array = new Array();
			var line:String = _textData[_loadLine];
			_loadLine++;
			command = line.split(" ");
			//顔画像状態で読み込み
			_faceMessageWindow[_nowTalkChara].setImage(command[1], command);
			setLineCommand();
		}
		
		/** 会話タイプセット */
		protected function setTalkType(type:String):void
		{
			switch (type.toLowerCase())
			{
			case "シングル": 
			case "single": 
				_nowTalkType = TALK_TYPE_SINGLE;
				break;
			case "三段": 
			case "トリプル": 
			case "triple": 
				_nowTalkType = TALK_TYPE_TRIPLE;
				break;
			}
			setLineCommand();
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
				_skipTimer.stop();
				_skipTimer.reset();
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
			var i:int = 0;
			for (i = 0; i < _faceMessageWindow.length; i++)
			{
				_faceMessageWindow[i].visible = false;
			}
			_msgCloseBtn.visible = false;
			_msgCloseFlg = true;
		}
		
		/**メッセージ表示*/
		private function msgOpenFunc():void
		{
			var i:int = 0;
			for (i = 0; i < _faceMessageWindow.length; i++)
			{
				_faceMessageWindow[i].visible = true;
			}
			_msgCloseBtn.visible = true;
			_msgCloseFlg = false;
		}
		
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
					_msgCloseBtn.color = 0x4444FF;
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
		
		override protected function addLayer(param:Object):void
		{
			super.addLayer(param);
			
			if (_msgCloseBtn == null)
			{
				_msgCloseBtn = new CImage(MainController.$.imgAsset.getTexture("btn_close"));
				_msgCloseBtn.visible = false;
				_msgCloseBtn.alpha = 0;
				_msgCloseBtn.x = 840;
				_msgCloseBtn.y = 0;
				_msgCloseBtn.width = 96;
				_msgCloseBtn.height = 96;
				
				_msgCloseBtn.addEventListener(TouchEvent.TOUCH, msgCloseHandler);
			}
			
			if (_msgCloseBtn != null)
			{
				setChildIndex(_msgCloseBtn, this.numChildren - 1);
			}
		}
	}
}