package viewitem.parts.list
{
	import common.CommonDef;
	import system.custom.customSprite.CButton;
	import system.custom.customSprite.CImgButton;
	import system.custom.customSprite.CSprite;
	import feathers.controls.Button;
	import feathers.controls.Slider;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author
	 */
	public class ListSelecter extends CSprite
	{
		public static var ITEM_WIDTH:int = 200;
		public static var ITEM_HEIGHT:int = 32;
		
		protected var _bgmBtn:CImgButton = null;
		protected var _listArea:CSprite = null;
		protected var _listContena:CSprite = null;
		protected var _BtnList:Vector.<CButton> = null;
		protected var _back:Image = null;
		protected const MAX_SHOW:int = 3;
		protected var _slider:Slider = null;
		protected var _callBack:Function = null;
		protected var _custom:Boolean = false;
		
		public function ListSelecter(custom:Boolean = true, backSet:Boolean = true)
		{
			super();
			_custom = custom;
			if (backSet)
			{
				_back = new Image(CommonDef.BACK_TEX);
				_back.width = 148;
				_back.height = 24;
				addChild(_back);
			}
			
			_listArea = new CSprite();
			//_listArea.mask = CommonDef.maskRect(new Rectangle(0, 0, 128, 24 * MAX_SHOW));
			_listArea.mask =  new Quad(CommonDef.WINDOW_W - 256, ITEM_HEIGHT * MAX_SHOW);
			_listArea.x = 0;
			_listArea.y = 0;
			addChild(_listArea);
			
			_listContena = new CSprite();
			_listArea.addChild(_listContena);
			
			//スライダー
			_slider = new Slider();
			//_slider.visible = false;
			_slider.direction = Slider.DIRECTION_VERTICAL;
			_slider.x = 124;
			_slider.y = 0;
			_slider.height = MAX_SHOW * ITEM_HEIGHT;
			_slider.step = 0.1;
			_slider.page = 0.5;
			_slider.addEventListener(Event.CHANGE, tipAreaMove);
			_slider.visible = false;
			addChild(_slider);
			

		}
		
		/**チップリスト表示*/
		public function setList(list:Array, callBack:Function):void
		{
			_callBack = callBack;
			_listContena.removeChildren();
			_BtnList = new Vector.<CButton>();
			
			for (var i:int = 0; i < list.length; i++)
			{
				var btn:CButton = new CButton();
				if (!_custom)
				{
					btn.styleName = "systemBtn";
				}
				btn.width = ITEM_WIDTH;
				btn.height = ITEM_HEIGHT;
				btn.label = list[i];
				btn.x = 0;
				btn.y = i * ITEM_HEIGHT;
				btn.addEventListener(Event.TRIGGERED, setBtnAction(i));
				_BtnList.push(btn);
				_listContena.addChild(_BtnList[i]);
			}
			if (_back != null)
			{
				_back.height = ITEM_HEIGHT + MAX_SHOW * ITEM_HEIGHT;
			}
			
			if (ITEM_HEIGHT * list.length > ITEM_HEIGHT * MAX_SHOW)
			{
				_slider.minimum = -(ITEM_HEIGHT * (list.length - MAX_SHOW));
				_slider.maximum = 0;
				_slider.value = 0;
				_slider.visible = true;
			}
			else
			{
				_slider.visible = false;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			var i:int = 0;
			if (_BtnList != null)
			{
				for (i = 0; i < _BtnList.length; i++)
				{
					_BtnList[i].removeEventListener(Event.TRIGGERED, setBtnAction(i));
				}
				
				for (i = 0; i < _BtnList.length; )
				{
					_BtnList[i].dispose();
					_BtnList[i] = null;
					_BtnList.shift();
				}
				
			}
			
			if (_back != null)
			{
				_back.dispose();
				_back = null;
			}
			if (_listArea != null)
			{
				_listArea.dispose();
				_listArea = null;
			}
			if (_listContena != null)
			{
				_listContena.dispose();
				_listContena = null;
			}
			
			if (_slider != null)
			{
				_slider.dispose();
				_slider = null;
			}
			
			_callBack = null;
		
		}
		
		public function addList(name:String):void
		{
			var count:int = _BtnList.length;
			var btn:Button = new Button();
			
			btn.width = ITEM_WIDTH;
			btn.height = ITEM_HEIGHT;
			btn.label = name;
			btn.x = 0;
			btn.y = (count) * ITEM_HEIGHT;
			btn.addEventListener(Event.TRIGGERED, setBtnAction(count));
			
			_BtnList.push(btn);
			_listContena.addChild(_BtnList[count]);
		
		}
		
		protected function setBtnAction(num:int):Function
		{
			return function():void
			{
				BtnAction(num);
			}
		}
		
		public function get getBtnList():Vector.<CButton>
		{
			return _BtnList;
		}
		
		protected function BtnAction(num:int):void
		{
			if (_callBack != null)
			{
				_callBack(num);
			}
		}
		
		/**スライダーイベント*/
		protected function tipAreaMove(e:Event):void
		{
			var slid:Slider = e.target as Slider;
			_listContena.y = slid.value;
		}
	
	}

}