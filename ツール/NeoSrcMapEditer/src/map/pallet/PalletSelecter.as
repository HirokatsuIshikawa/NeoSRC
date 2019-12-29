package map.pallet
{
	import feathers.controls.Button;
	import feathers.controls.Slider;
	import feathers.controls.TextInput;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import system.CommonDef;
	import system.UserImage;
	import view.MainController;
	import view.MainViewer;
	
	/**
	 * ...
	 * @author
	 */
	public class PalletSelecter extends Sprite
	{
		
		//最大リスト数
		private const MAX_SHOW:int = 10;
		
		//リスト範囲
		private var m_listArea:Sprite = null;
		//リスト中身
		private var m_listContena:Sprite = null;
		//ボタンリスト
		private var m_BtnList:Vector.<Button> = null;
		//背景
		private var m_back:Image = null;
		//スライダー
		private var m_slider:Slider = null;
		
		//入力欄
		private var m_input:TextInput = null;
		private var m_filertBtn:Button = null;
		private var m_filertResetBtn:Button = null;
		//コールバック
		private var m_callBack:Function = null;
		
		public function PalletSelecter()
		{
			super();
			m_back = new Image(UserImage.$.getSystemTex("tex_black"));
			m_back.alpha = 0.7;
			m_back.width = 160;
			m_back.height = 32 * Pallet.HEIGHT_TIP + 72;
			
			addChild(m_back);
			
			m_input = new TextInput();
			m_input.width = 140;
			m_input.x = 4;
			m_input.y = 24;
			addChild(m_input);
			
			m_filertBtn = new Button();
			m_filertBtn.label = "フィルター";
			m_filertBtn.width = 100;
			m_filertBtn.x = 24;
			m_filertBtn.y = 50;
			m_filertBtn.addEventListener(Event.TRIGGERED, filterAction);
			addChild(m_filertBtn);
			
			m_filertResetBtn = new Button();
			m_filertResetBtn.label = "リセット";
			m_filertResetBtn.width = 100;
			m_filertResetBtn.x = 24;
			m_filertResetBtn.y = 78;
			m_filertResetBtn.addEventListener(Event.TRIGGERED, filterResetAction);
			addChild(m_filertResetBtn);
			
			m_listArea = new Sprite();
			m_listArea.mask = new Quad(128, 24 * MAX_SHOW);// new Rectangle(0, 0, 96, 24 * MAX_SHOW);
			m_listArea.x = 4;
			m_listArea.y = 124;
			addChild(m_listArea);
			
			m_listContena = new Sprite();
			m_listArea.addChild(m_listContena);
			
			//スライダー
			m_slider = new Slider();
			//m_slider.visible = false;
			m_slider.direction = Slider.DIRECTION_VERTICAL;
			m_slider.x = 132;
			m_slider.y = 124;
			m_slider.height = MAX_SHOW * 24;
			m_slider.step = 0.1;
			m_slider.page = 0.5;
			m_slider.addEventListener(Event.CHANGE, tipAreaMove);
			m_slider.visible = false;
			addChild(m_slider);
		
		}
		
		public function resetList():void
		{
			
			m_listContena.removeChildren();
		}
		
		/**チップリスト表示*/
		public function setList(type:String, list:Vector.<String>, callBack:Function):void
		{
			m_callBack = callBack;
			m_listContena.removeChildren();
			m_BtnList = new Vector.<Button>();
			
			if (MainController.$.view.pallet != null)
			{
				if (type === "autotile")
				{
					MainController.$.view.pallet.autoTile = true;
					MainController.$.view.pallet.autoObj = false;
				}
				else if (type === "autoobj")
				{
					MainController.$.view.pallet.autoTile = false;
					MainController.$.view.pallet.autoObj = true;
					
				}
				else
				{
					MainController.$.view.pallet.autoTile = false;
					MainController.$.view.pallet.autoObj = false;
				}
			}
			
			for (var i:int = 0; i < list.length; i++)
			{
				var btn:Button = new Button();
				btn.width = 128;
				btn.height = 24;
				btn.label = list[i];
				btn.x = 0;
				btn.y = i * 24;
				btn.addEventListener(Event.TRIGGERED, setBtnAction(list[i], type));
				m_BtnList.push(btn);
				m_listContena.addChild(m_BtnList[i]);
			}
			//m_back.height = 48 + MAX_SHOW * 24;
			
			if (24 * list.length > m_listArea.mask.height)
			{
				m_slider.minimum = -(24 * list.length - m_listArea.mask.height);
				m_slider.maximum = 0;
				m_slider.value = 0;
				m_slider.visible = true;
				m_slider.thumbProperties.width = 24;
				m_slider.thumbProperties.height = Math.max(m_slider.height - (24 * list.length - m_slider.height), 20);
			}
			else
			{
				m_slider.value = 0;
				m_slider.visible = false;
			}
		}
		
		private function setBtnAction(name:String, type:String):Function
		{
			return function():void
			{
				BtnAction(name, type);
			}
		}
		
		private function BtnAction(name:String, type:String):void
		{
			MainController.$.view.pallet.useSpoit = false;
			m_callBack(name, type);
		}
		
		/**スライダーイベント*/
		private function tipAreaMove(e:Event):void
		{
			var slid:Slider = e.target as Slider;
			m_listContena.y = slid.value;
		}
		
		//フィルター掛け
		private function filterAction(e:Event):void
		{
			//オートタイル時
			if (MainController.$.view.pallet.autoTile == true)
			{
				MainController.$.view.setSelecterFilter(1, m_input.text);
			}
			//オートオブジェ
			else if (MainController.$.view.pallet.autoObj == true)
			{
				MainController.$.view.setSelecterFilter(2,m_input.text);
			}
			else
			{
				MainController.$.view.tileFilter(m_input.text);
			}		
		}
		
		//フィルターリセット
		private function filterResetAction(e:Event):void
		{
			m_input.text = "";
			filterAction(null);
		}
		
		//背景取得
		public function get back():Image
		{
			return m_back;
		}
	
	}

}