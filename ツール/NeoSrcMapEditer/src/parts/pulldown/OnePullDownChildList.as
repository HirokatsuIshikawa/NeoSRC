package parts.pulldown
{
	import feathers.controls.Button;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/*
	 * @author ishikawa
	 */
	public class OnePullDownChildList extends Sprite
	{
		/**リスト名*/
		private var _listName:String;
		/**番号*/
		private var _no:int;
		/**ボタン*/
		private var _btn:Button = null;
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
		/**マスク*/
		private var _mask:Quad;
		/**リストビュー*/
		//private var _listView:ListBox = null;
		/**最大子要素数*/
		private const MAX_CHILD_NUM:int = 2;
		/**子要素表示数*/
		private var m_showNum:int = 2;
		/**開く方向フラグ*/
		private var m_upper:Boolean = false;
		
		/**ラベル名*/
		private var m_labelName:String = "";
		
		/**コンストラクタ
		 * @param name ラベル名
		 * @param no 配列番号
		 * @param pos_x 子要素横開始位置
		 * @param pos_y 子要素縦開始位置
		 * @param 横幅
		 * @param 縦幅
		 * @param 入れ子の子か（一番上ならfalse）
		 * */
		public function OnePullDownChildList(name:String, no:int = 0, pos_x:int = 0, pos_y:int = 0, width:int = 0, height:int = 0, showNum:int = MAX_CHILD_NUM, child:Boolean = false)
		{
			_listName = name;
			_no = no;
			_btn = new Button();
			_child = child;
			_btn.styleName = "TabList";
			//_listView = new ListBox();
			_pos_x = pos_x;
			_pos_y = pos_y;
			this.x = 1;
			_width = width - 2;
			_height = height + 1;
			_btn.width = _width;
			_btn.height = _height;
			m_showNum = showNum;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
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
			this.addChild(_btn);
		}
		
		/**ステージ開始後
		 * @param e イベント
		 * */
		private function onAddedToStage(e:Event):void
		{
			//デフォルトボタン
			_btn.label = _listName;
			_btn.addEventListener(Event.TRIGGERED, pushHandler);
			this.addChild(_btn);
			//マスクコンテナ
			_container = new Sprite();
			//一番上だった場合、マスクセット
			if (!this._child)
			{
				_mask = new Quad(_width, _height * (m_showNum + 1));
				_container.mask = _mask;
			}
			//うえ開き
			if (m_upper == true)
			{
				_container.y = (m_showNum) * _height * -1;
			}
			//リストビューをコンテナの中に入れる
			//_container.addChild(_listView);
			this.addChild(_container);
		}
		
		/**ボタン押下時処理*/
		private function pushHandler(event:Event):void
		{
			(this.parent.parent.parent as OnePullDownList).btnReset();
			_btn.dispatchEvent(new Event("listpush"));
			
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
		
		/**ボタン色戻し*/
		public function btnReset():void
		{
			_btn.dispatchEvent(new Event("listreset"));
		}
		
		public function action():void
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
		
		public function set upper(value:Boolean):void
		{
			m_upper = value;
		}
		
		public function get labelName():String
		{
			return m_labelName;
		}
		
		public function get obj():Object
		{
			return _obj;
		}
		
		override public function dispose():void
		{
			_obj = null;
			_btn.removeChildren();
			//this.removeChildren();
			//_listView.removeChildren();
			//_listView.dispose();
			_btn.dispose();
			super.dispose();
		}
	}
}