package parts.pulldown
{
	import a24.tween.Ease24;
	import a24.tween.Tween24;
	import feathers.controls.Button;
	import feathers.controls.Slider;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import main.MainController;
	
	/*
	 * @author ishikawa
	 */
	public class OnePullDownList extends Sprite
	{
		/**リスト名*/
		private var _listName:String;
		/**リスト一覧*/
		private var _pullList:Vector.<OnePullDownChildList> = null;
		/**ボタン*/
		private var _btn:Button = null;
		/**展開ボタン*/
		//private var _openBtn:Button = null;
		/**デフォルトスライダー*/
		private var _slider:Slider = null;
		/**コールバック関数*/
		private var _callBack:Function = null;
		/**コールバック変数*/
		private var _obj:Object = null;
		/**子要素開始横位置*/
		private var _pos_x:int = 0;
		/**子要素開始縦位置*/
		private var _pos_y:int = 0;
		/**ボタン横幅*/
		private var _width:int = 0;
		/**ボタン縦幅*/
		private var _height:int = 0;
		/**開始位置*/
		private var _child:Boolean = false;
		/**マスクディスプレイオブジェクト*/
		private var _container:Sprite = null;
		//背景コンテナ
		private var _backContainer:Sprite = null;
		private var _back:Image = null;
		/**マスク*/
		private var _mask:Quad;
		/**リストビュー*/
		private var _listView:ListBox = null;
		/**最大子要素数*/
		private const MAX_CHILD_NUM:int = 2;
		/**スライダー稼働状態*/
		private var _sliderActive:Boolean = false;
		/**子要素表示数*/
		private var m_showNum:int = 2;
		/**開く方向フラグ*/
		private var m_upper:Boolean = false;
		/**ラベル名*/
		private var m_labelName:String = "";
		/**展開時関数*/
		private var m_openFunc:Function = null;
		/**上開き位置*/
		private var m_upperPos:int = 0;
		
		/**コンストラクタ
		 * @param name ラベル名
		 * @param no 配列番号
		 * @param pos_x 子要素横開始位置
		 * @param pos_y 子要素縦開始位置
		 * @param 横幅
		 * @param 縦幅
		 * @param 入れ子の子か（一番上ならfalse）
		 * */
		public function OnePullDownList(name:String, pos_x:int = 0, pos_y:int = 0, width:int = 0, height:int = 0, showNum:int = MAX_CHILD_NUM, child:Boolean = false)
		{
			//リスト頭と尻尾の丸を入れ替える
			_listName = name;
			_btn = new Button();
			//_openBtn = new Button();
			_child = child;
			_btn.styleName = "TabList";
			//_openBtn.styleName = "openTab";
			_listView = new ListBox();
			_listView.visible = false;
			_pos_x = pos_x;
			_pos_y = pos_y;
			_width = width;
			_height = height;
			_btn.width = _width;
			_btn.height = _height;
			_pullList = new Vector.<OnePullDownChildList>;
			m_showNum = showNum;
			//this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			onAddedToStage();
			this.addEventListener(TouchEvent.TOUCH, touching);
			if (_child == false)
			{
				this._btn.addEventListener(TouchEvent.TOUCH, btnTouching);
				this._btn.addEventListener(Event.TRIGGERED, openHandler);
			}
			//_openBtn.height = _height + 2;
			//this._openBtn.addEventListener(TouchEvent.TOUCH, btnTouching);
		
		}
		
		public function set label(str:String):void
		{
			this.removeChild(_btn);
			_btn.removeChildren();
			_btn.dispose();
			_listName = str;
			
			m_labelName = _listName;
			_btn = new Button();
			_btn.styleName = "TabList";
			_btn.width = _width;
			_btn.height = _height;
			_btn.label = _listName;
			_btn.addEventListener(Event.TRIGGERED, pushHandler);
			_btn.addEventListener(Event.TRIGGERED, openHandler);
			_btn.addEventListener(TouchEvent.TOUCH, btnTouching);
			
			this.addChild(_btn);
			/*
			if (this.numChildren > 1)
			{
				this.setChildIndex(_openBtn, this.numChildren - 1);
			}
			*/
		}
		
		override public function dispose():void
		{
			_slider.removeChildren();
			_slider.dispose();
			_obj = null;
			for (var i:int = 0; i < _pullList.length; i++)
			{
				_pullList[i].dispose();
			}
			_btn.removeChildren();
			_btn.dispose();
			//_openBtn.dispose();
			
			_listView.removeChildren();
			_listView.dispose();
			super.dispose();
		}
		
		/**タッチイベント*/
		private function touching(event:TouchEvent):void
		{
			if (_pullList.length < m_showNum)
				return;
			var touch:Touch = event.getTouch(_listView.stage);
			//タッチしているか
			if (touch)
			{
				if (touch.isTouching(this))
				{
					//スライダー稼働
					_sliderActive = true;
				}
				else
				{
					//タッチしていなかったら動かせない
					_sliderActive = false;
				}
			}
		}
		
		/**タッチイベント*/
		private function btnTouching(event:TouchEvent):void
		{
			var btn:Button = event.target as Button;
			var touch:Touch = event.getTouch(btn.stage);
			//タッチしているか
			if (touch)
			{
				if (touch.phase == TouchPhase.HOVER)
				{
					if (touch.isTouching(btn))
					{
						_btn.dispatchEvent(new Event("listpush"));
						
						if (_child == false)
						{
							MainController.$.view.addEventListener(TouchEvent.TOUCH, _touch);
						}
						
					}
					else
					{
						if (_pullList.length > 0 && !_pullList[0].visible)
						{
							_btn.dispatchEvent(new Event("listreset"));
						}
					}
				}
			}
		}
		
		/**ステージ開始後
		 * @param e イベント
		 * */
		private function onAddedToStage():void
		{
			var num:int = 0;
			//デフォルトボタン
			_btn.label = _listName;
			_btn.addEventListener(Event.TRIGGERED, pushHandler);
			this.addChild(_btn);
			//展開ボタンが存在する場合
			/*
			if (this.getChildIndex(_openBtn) >= 0)
			{
				//ボタンを最前面に表示
				this.setChildIndex(_openBtn, this.numChildren - 1);
			}
			*/
			//マスクコンテナ
			_container = new Sprite();
			_backContainer = new Sprite();
			num = _pullList.length;
			
			if (_pullList.length > m_showNum)
			{
				num = _height * m_showNum;
			}
			else
			{
				num = _height * _pullList.length;
			}
			
			_back = new Image(Texture.fromBitmap(new Bitmap(new BitmapData(_width, num + 2, true, 0xFF000000))));
			_backContainer.addChild(_back);
			
			//一番上だった場合、マスクセット
			if (!this._child)
			{
				_mask = new Quad(_width + 16, _height * (m_showNum));
				_container.mask = _mask;
				_backContainer.mask = new Quad(_width, _height * (m_showNum) + 1);
			}
			//うえ開き
			if (m_upper == true)
			{
				_container.y = (m_showNum) * _height * -1;
				_backContainer.y = -(m_showNum * _height) - 1;
				_back.y = _height * (m_showNum + 1);
				_listView.y = _height * (m_showNum);
			}
			else
			{
				_container.y = _height;
				_backContainer.y = _height;
				_back.y = -(_height * (m_showNum + 1)) - 1;
				_listView.y = -(_height * (m_showNum));
			}
			//リストビューをコンテナの中に入れる
			
			_container.addChild(_listView);
			this.addChild(_backContainer);
			this.addChild(_container);
			
			//スライダー
			_slider = new Slider();
			_slider.styleName = "minivSlider";
			_slider.direction = Slider.DIRECTION_VERTICAL;
			_slider.x = _pos_x + _btn.width;
			
			_slider.addEventListener(TouchEvent.TOUCH, _touchSlider);
			
			//上開き
			if (m_upper == true)
			{
				_slider.y = m_showNum * _height * -1;
			}
			else
			{
				_slider.y = _pos_y;
			}
			_slider.height = _height * m_showNum;
			_slider.minimum = 0;
			if (_pullList.length > m_showNum)
			{
				_slider.maximum = (_pullList.length - m_showNum) * _height;
			}
			else
			{
				_slider.maximum = _height * m_showNum;
			}
			_slider.value = _slider.maximum;
			_slider.page = 1;
			_slider.step = 0.05;
			_slider.visible = false;
			_slider.addEventListener(Event.CHANGE, changeHandler);
			_container.addChild(_slider);
		}
		
		/**ボタン押下時処理*/
		private function pushHandler(event:Event):void
		{
			
			//コールバックがあれば、コールバックを実行
			if (_callBack != null)
			{
				if (_obj)
				{
					_callBack(_obj);
				}
				else
				{
					_callBack();
				}
			}
		}
		
		/**スライダー移動時*/
		private function changeHandler(evt:Event):void
		{
			var sliderf:Slider = evt.target as Slider;
			
			//スライダーに合わせて位置を変更
			_listView.y = -(sliderf.maximum - sliderf.value);
			//外側に出たリストを見えなくする
			closeOutSide();
		}
		
		/**
		 * グローバル座標取得
		 * @return Point グローバル座標
		 * */
		private function getGlobalPoint():Point
		{
			return localToGlobal(new Point(this.x, this.y));
		}
		
		/**ボタン使用可能・不可能*/
		public function set active(flg:Boolean):void
		{
			_btn.isEnabled = flg;
			//_openBtn.isEnabled = flg;
		}
		
		/**入れ子構造識別
		 * obj
		 *
		 * */
		public function checkPullDownList(obj:OnePullDownList):Boolean
		{
			
			//入れ子構造ならば
			if (obj.parent is ListBox && obj.parent.parent is Sprite && obj.parent.parent.parent is OnePullDownList)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * リスト展開イベント
		 * */
		private function openHandler(event:Event):void
		{
			//上開き位置設定
			if (m_upperPos > 0)
			{
				//trace("ポイント:" + localToGlobal(new Point(this.x, this.y)).y);
				if (localToGlobal(new Point(this.x, this.y)).y > m_upperPos)
				{
					m_upper = true;
				}
				else
				{
					m_upper = false;
				}
			}
			
			//うえ開き
			if (m_upper == true)
			{
				_container.y = (m_showNum) * _height * -1;
				_backContainer.y = -(m_showNum * _height) - 1;
				_back.y = _height * (m_showNum + 1);
				_listView.y = _height * (m_showNum);
			}
			else
			{
				_container.y = _height;
				_backContainer.y = _height;
				_back.y = -(_height * (m_showNum + 1)) - 1;
				_listView.y = -(_height * (m_showNum));
			}
			
			_btn.dispatchEvent(new Event("listpush"));

			//子要素すべてに対し
			for (var i:int = 0; i < _pullList.length; i++)
			{
				//見えなくなったら
				if (!_pullList[i].visible)
				{
				}
				else
				{
					//ボタンを最前面に表示
					this.setChildIndex(_btn, this.numChildren - 1);
					//ボタンを最前面に表示
					//this.setChildIndex(_openBtn, this.numChildren - 1);
				}
			}
			
			//自分の子要素を消去
			if (_pullList.length > 0 && _listView.visible)
			{
				if (m_upper == true)
				{
					_listView.y = _container.height - _height;
					_back.y = _container.height - _height;
					_slider.y = _slider.height;
				}
				else
				{
					_listView.y = -_container.height + _height;
					_back.y = -_container.height + _height;
					_slider.y = _slider.height * -1 + _pullList[0].height;
				}
				_listView.visible = false;
				closeList();
			}
			else
			{
				var pos:int = 0;
				var s_pos:int = 0;
				if (m_upper == true)
				{
					pos = _back.height - 1;
					s_pos = _slider.height;
				}
				else
				{
					pos = -(_back.height - 1);
					s_pos = _slider.height * -1 + _pullList[0].height;
				}
				for (var j:int = 0; j < _pullList.length; j++)
				{
					_pullList[j].visible = true;
				}
				_listView.visible = true;
				_slider.visible = true;
				_back.visible = true;
				//Tween24.parallel(Tween24.prop(_back).y(pos).alpha(1), Tween24.prop(_listView).y(pos).alpha(1), Tween24.prop(_slider).y(s_pos).alpha(1), Tween24.tween(_back, 0.2).y(0), Tween24.tween(_listView, 0.2).y(0), Tween24.tween(_slider, 0.2).y(0)).play();
				_listView.y = 0;
				_back.y = 0;
				_slider.y = 0;
				
				//スライダーを可視状態に
				if (_pullList.length > m_showNum)
				{
					_slider.value = _slider.maximum;
					_slider.visible = true;
				}
				else
				{
					_slider.visible = false;
				}
			}
			if (m_openFunc != null)
			{
				m_openFunc();
			}
		}
		
		/**
		 * 直下リスト全消去
		 * */
		public function closeList():void
		{
			_btn.dispatchEvent(new Event("listreset"));
			
			MainController.$.view.removeEventListener(TouchEvent.TOUCH, _touch);
			_slider.visible = false;
			_slider.value = _slider.maximum;
			//_back.y = -_container.height - 1;
			_back.visible = false;
			_listView.visible = false;
			
			for (var i:int = 0; i < _pullList.length; i++)
			{
				_pullList[i].visible = false;
			}
			
			if (m_upper == true)
			{
				
				_listView.y = _back.height - 1;
				_slider.y = _slider.height;
			}
			else
			{
				_listView.y = -(_back.height - 1);
				_slider.y = _slider.height * -1 + _pullList[0].height;
			}
		
		}
		
		/**
		 * 枠外に出たリストを消去
		 * */
		public function closeOutSide():void
		{
			for (var i:int = 0; i < _pullList.length; i++)
			{
				if (_pullList[i].y + _listView.y < _pos_y * -1 - _height || _pullList[i].y + _listView.y > (_height * m_showNum - 1) + _pos_y)
				{
					_pullList[i].visible = false;
				}
				else
				{
					_pullList[i].visible = true;
				}
			}
		}
		
		public function btnReset():void
		{
			for (var i:int = 0; i < _pullList.length; i++)
			{
				_pullList[i].btnReset();
			}
		}
		
		/**平行直下リスト全消去
		 * @param no 対象配列番号
		 * */
		private function closeChildList(no:int):void
		{
			for (var i:int = 0; i < _pullList.length; i++)
			{
				if (no == i)
					continue;
			}
		}
		
		/**リスト追加
		 * @param name ラベル名
		 * @param func コールバック関数
		 * @param obj 変数オブジェクト
		 *
		 * */
		public function addChildList(name:String, func:Function = null, obj:Object = null):void
		{
			/*
			if (this.getChildIndex(_openBtn) < 0)
			{
				_openBtn.addEventListener(Event.TRIGGERED, openHandler);
				_openBtn.x = _width - 10;
				_openBtn.y = 2;
				this.addChild(_openBtn);
			}
			*/
			var pullList:OnePullDownChildList = new OnePullDownChildList(name, _pullList.length, _width, 0, _width, _height, m_showNum, true);
			_listView.x = _pos_x;
			//pullList.alpha = 0;
			pullList.y = _height * _pullList.length;
			//pullList.visible = false;
			pullList.callBack(func, obj);
			_listView.addChild(pullList);
			_pullList.push(pullList);
			if (_pullList.length > m_showNum && _slider != null)
			{
				_slider.maximum = (_pullList.length - m_showNum) * _height;
				_slider.value = _slider.maximum;
			}
			//番号順に前面に持ってくる
			for (var i:int = _pullList.length - 1; i >= 0; i--)
			{
				_listView.setChildIndex(_pullList[i], _listView.numChildren - 1);
			}
			
			
			_slider.thumbProperties.height = Math.max(_slider.height - (_pullList.length * _height - _slider.height), 20);
			
		}
		
		/**コールバック設定
		 * @param func コールバック関数
		 * @param obj 変数オブジェクト
		 * */
		public function callBack(func:Function, obj:Object = null):void
		{
			if (obj)
			{
				_obj = obj;
			}
			_callBack = func;
		}
		
		/**コールバック変数設定
		 * @param obj 変数オブジェクト
		 * */
		public function callBackVariable(obj:Object):void
		{
			_obj = obj;
		}
		
		/**
		 * 子要素取得
		 * */
		public function get getChildList():Vector.<OnePullDownChildList>
		{
			return _pullList;
		}
		
		public function set upper(value:Boolean):void
		{
			m_upper = value;
		}
		
		public function get labelName():String
		{
			return m_labelName;
		}
		
		public function set openFunc(value:Function):void
		{
			m_openFunc = value;
		}
		
		public function set upperPos(value:int):void
		{
			m_upperPos = value;
		}
		
		public function get opened():Boolean
		{
			return _listView.visible;
		}
		
		private function _touch(_evt:TouchEvent):void
		{
			var evt:TouchEvent = _evt as TouchEvent;
			
			var touch:Touch = evt.getTouch(MainController.$.view);
			//-------------------------------------------------------------
			if (touch)
			{
				var point:Point = touch.getLocation(this);
				switch (touch.phase)
				{
					case TouchPhase.ENDED: 
					{
						if (this.hitTest(point))
						{
							
						}
						else
						{
							closeList();
						}
						break;
					}
				}
			}
		}
		
		private function _touchSlider(_evt:TouchEvent):void
		{
			var evt:TouchEvent = _evt as TouchEvent;
			
			var touch:Touch = evt.getTouch(MainController.$.view);
			//-------------------------------------------------------------
			if (touch)
			{
				var point:Point = touch.getLocation(_slider);
				switch (touch.phase)
				{
					case TouchPhase.ENDED: 
					{
						
						if (m_showNum == 0)
							return;
						var number:int = Math.abs(_slider.value) / _height;
						var mod:int = Math.abs(_slider.value) % _height;
						if (mod < _height / 2)
						{
							Tween24.tween(_slider, 0.3, Ease24._1_SineInOut, {value: (number) * _height}).play();
						}
						else
						{
							Tween24.tween(_slider, 0.3, Ease24._1_SineInOut, {value: (number + 1) * _height}).play();
						}
						
						break;
					}
				}
			}
		}
	
	}
}