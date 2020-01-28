package scene.talk.window
{
	import common.CommonDef;
	import system.custom.customSprite.CButton;
	import system.custom.customSprite.CSprite;
	import feathers.controls.Button;
	import flash.geom.Rectangle;
	import starling.display.Quad;
	import starling.events.Event;
	import viewitem.parts.list.ListSelecter;
	import scene.talk.classdata.SelectCommandData;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class SelectWindow extends ListSelecter
	{
		public static const LIST_HEIGHT:int = 48;
		
		public static const MAX_SELECT:int = 8;
		
		public static const NO_USE_KEY:Array = ["target", "goto", "width"];
		
		private var _gotoFlg:Boolean = false;
		
		private var _valiableName:String = "";
		
		public function SelectWindow()
		{
			super(true, false);
			
			_listArea.mask = new Quad(512, LIST_HEIGHT * MAX_SELECT);
			_slider.x = 512;
			_slider.y = 0;
		}
		
		/**リストセット*/
		public function setKeyList(list:Vector.<SelectCommandData>, callBack:Function):void
		{
			_callBack = callBack;
			_listContena.removeChildren();
			_BtnList = new Vector.<CButton>();
			
			for (var i:int = 0; i < list.length; i++)
			{
				var btn:CButton = new CButton(36);
				if (!_custom)
				{
					btn.styleName = "systemBtn";
				}
				btn.width = 512;
				btn.height = LIST_HEIGHT;
				btn.label = list[i].key;
				btn.key = list[i].key;
				btn.value = list[i].value;
				btn.x = 0;
				btn.y = i * LIST_HEIGHT;
				btn.addEventListener(Event.TRIGGERED, selectBtnAction);
				_BtnList.push(btn);
				_listContena.addChild(_BtnList[i]);
			}
			
			if (LIST_HEIGHT * list.length > LIST_HEIGHT * MAX_SELECT)
			{
				_slider.minimum = -(LIST_HEIGHT * (list.length - MAX_SELECT));
				_slider.maximum = 0;
				_slider.value = 0;
				_slider.height = list.length * LIST_HEIGHT;
				_slider.visible = true;
			}
			else
			{
				_slider.visible = false;
			}
		}
		
		/**未使用コマンド判定*/
		public static function judgeNoUse(key:String):Boolean
		{
			var result:Boolean = false;
			var i:int = 0;
			for (i = 0; i < NO_USE_KEY.length; i++)
			{
				if (key === NO_USE_KEY[i])
				{
					result = true;
					break;
				}
			}
			
			return result;
		}
		
		/**ボタン実行*/
		protected function selectBtnAction(e:Event):void
		{
			var btn:CButton = e.currentTarget as CButton;
			if (_callBack != null)
			{
				_callBack(btn.key, btn.value);
			}
		}
		
		override public function dispose():void
		{
			var i:int = 0;
			if (_BtnList != null)
			{
				for (i = 0; i < _BtnList.length; )
				{
					_BtnList[i].removeEventListener(Event.TRIGGERED, selectBtnAction);
					_BtnList[i].dispose();
					_BtnList[i] = null;
					_BtnList.shift();
				}
				
			}
			super.dispose();
		}
		
		public function get gotoFlg():Boolean 
		{
			return _gotoFlg;
		}
		
		public function set gotoFlg(value:Boolean):void 
		{
			_gotoFlg = value;
		}
		
		public function get valiableName():String 
		{
			return _valiableName;
		}
		
		public function set valiableName(value:String):void 
		{
			_valiableName = value;
		}
		
	
	}

}