package parts.popwindow
{
	
	import feathers.controls.Button;
	import feathers.controls.Check;
	import feathers.controls.NumericStepper;
	import feathers.controls.Slider;
	import feathers.controls.TextArea;
	import feathers.controls.TextInput;
	import feathers.controls.ToggleButton;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	import feathers.core.ToggleGroup;
	import feathers.skins.ImageSkin;
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import map.canvas.TerrainTip;
	import map.pallet.PalletTip;
	import parts.pulldown.OnePullDownList;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import system.UserImage;
	import main.MainController;
	
	/**
	 * ...
	 * @author
	 */
	public class CreateAreaWindow extends Sprite
	{
		/**パレット背景*/
		private var m_back:Image = null;
		
		/**チップタイプボタンリスト*/
		private var m_typeBtnList:Vector.<ToggleButton> = null;
		private var m_typeToggleGroup:ToggleGroup = null;
		
		/**リセットボタン*/
		private var m_resetBtn:Button = null;
		/**クリップボタン*/
		private var m_clipBtn:Button = null;
		/**初期化中*/
		private var _initing:Boolean = false;
		
		/**キャラ名入力*/
		private var _nameText:TextArea = null;
		private var _nameInput:TextInput = null;
		/**勢力入力*/
		private var _sideText:TextArea = null;
		private var _sideInput:TextInput = null;
		/**レベル*/
		private var _levelText:TextArea = null;
		private var _levelStep:NumericStepper = null;
		/**強化値*/
		private var _strengthText:TextArea = null;
		private var _strengthStep:NumericStepper = null;
		
		/**加入チェック*/
		private var _joinText:TextArea = null;
		private var _joinCheck:Check = null;
		
		/**表示エリア*/
		private var _outputText:TextInput = null;
		
		private var _setImgList:Vector.<Image> = null;
		
		private var _clip:Clipboard = null;
		
		public function get back():Image
		{
			return m_back;
		}
		
		public function CreateAreaWindow()
		{
			_setImgList = new Vector.<Image>();
			
			var i:int = 0;
			super();
			_initing = true;
			m_back = new Image(UserImage.$.getSystemTex("tex_black"));
			m_back.name = "normalBack";
			m_back.alpha = 0.5;
			m_back.width = 400;
			m_back.height = 400;
			addChild(m_back);
			
			/////////////////////名前入力/////////////////
			_nameText = new TextArea();
			_nameText.styleName = "titleText";
			_nameText.text = "ユニット名";
			_nameText.x = 8;
			_nameText.y = 8;
			_nameText.width = 120;
			addChild(_nameText);
			
			//入力欄
			_nameInput = new TextInput();
			_nameInput.text = "キャラ名";
			_nameInput.textEditorFactory = function():ITextEditor
			{
				var stageTextTextEditor:StageTextTextEditor = new StageTextTextEditor();
				stageTextTextEditor.multiline = false;
				return stageTextTextEditor;
			}
			_nameInput.backgroundSkin = new Image(Texture.fromBitmap(new Bitmap(new BitmapData(80, 24, true, 0xFF7733FF))));
			_nameInput.x = 100;
			_nameInput.y = 8;
			_nameInput.width = 120;
			addChild(_nameInput);
			/////////////////////勢力入力/////////////////
			_sideText = new TextArea();
			_sideText.styleName = "titleText";
			_sideText.text = "所属";
			_sideText.x = 8;
			_sideText.y = 40;
			_sideText.width = 120;
			addChild(_sideText);
			
			//入力欄
			_sideInput = new TextInput();
			_sideInput.text = "味方";
			_sideInput.textEditorFactory = function():ITextEditor
			{
				var stageTextTextEditor:StageTextTextEditor = new StageTextTextEditor();
				stageTextTextEditor.multiline = false;
				return stageTextTextEditor;
			}
			_sideInput.backgroundSkin = new Image(Texture.fromBitmap(new Bitmap(new BitmapData(80, 24, true, 0xFF7733FF))));
			_sideInput.x = 100;
			_sideInput.y = 40;
			_sideInput.width = 120;
			addChild(_sideInput);
			
			/////////////////////レベル入力//////////////////
			_levelText = new TextArea();
			_levelText.styleName = "titleText";
			_levelText.text = "レベル";
			_levelText.x = 8;
			_levelText.y = 72;
			_levelText.width = 120;
			addChild(_levelText);
			
			_levelStep = new NumericStepper();
			_levelStep.x = 100;
			_levelStep.y = 72;
			_levelStep.maximum = 99;
			_levelStep.minimum = 1;
			_levelStep.step = 1;
			addChild(_levelStep);
			
			/////////////////////強化値入力/////////////////			
			_strengthText = new TextArea();
			_strengthText.styleName = "titleText";
			_strengthText.text = "強化値";
			_strengthText.x = 8;
			_strengthText.y = 104;
			_strengthText.width = 120;
			addChild(_strengthText);
			
			_strengthStep = new NumericStepper();
			_strengthStep.x = 100;
			_strengthStep.y = 104;
			_strengthStep.value = 0;
			_strengthStep.maximum = 99;
			_strengthStep.minimum = 0;
			_strengthStep.step = 1;
			addChild(_strengthStep);
			
			///////////////////////////////////////表示エリア//////////////////////////////////////////
			
			_outputText = new TextInput();
			_outputText.styleName = "fileInput";
			_outputText.text = "";
			_outputText.backgroundSkin = new Image(Texture.fromBitmap(new Bitmap(new BitmapData(80, 24, true, 0xFF7733FF))));
			_outputText.x = 8;
			_outputText.y = 136;
			_outputText.width = m_back.width - 16;
			_outputText.height = m_back.height - 152;
			
			addChild(_outputText);
			
			///////////////////////////////////////タイプ選択//////////////////////////////////////////
			
			m_typeBtnList = new Vector.<ToggleButton>();
			m_typeToggleGroup = new ToggleGroup();
			//m_typeToggleGroup.addEventListener(Event.CHANGE, selectLayer);
			var layerBtnTitle:Array = ["作成", "出撃"]
			
			for (i = 0; i < layerBtnTitle.length; i++)
			{
				var layerBtn:ToggleButton = new ToggleButton();
				layerBtn.label = layerBtnTitle[i];
				layerBtn.toggleGroup = m_typeToggleGroup;
				layerBtn.x = 272;
				layerBtn.y = 16 + 24 * i;
				layerBtn.width = 96;
				addChild(layerBtn);
				
				m_typeBtnList.push(layerBtn);
			}
			
			//読み込みボタン
			m_resetBtn = new Button();
			m_resetBtn.x = 272;
			m_resetBtn.y = 72;
			m_resetBtn.width = 96;
			m_resetBtn.label = "リセット";
			m_resetBtn.addEventListener(Event.TRIGGERED, function():void
			{
				_outputText.text = "";
				deleteImgList();
			});
			addChild(m_resetBtn);
			
			_clip = Clipboard.generalClipboard;
			
			//コピーボタン
			m_clipBtn = new Button();
			m_clipBtn.x = 272;
			m_clipBtn.y = 100;
			m_clipBtn.width = 96;
			m_clipBtn.label = "クリップ保存";
			m_clipBtn.addEventListener(Event.TRIGGERED, function():void
			{
				_clip.setData(ClipboardFormats.TEXT_FORMAT, _outputText.text);
			});
			addChild(m_clipBtn);
			
			m_typeBtnList[0].isSelected = true;
			
			_initing = false;
			_levelStep.value = 1;
		}
		
		//CreateUnit name:エネミー x:10 y:6 side:敵 strength:0
		//CreateUnit name:軽戦車 x:10 y:6 side:味方 join:0
		//LaunchUnit name:木之本桜 x:13 y:6
		public function setFlame(posX:int, posY:int):void
		{
			var str:String = "";
			switch (m_typeToggleGroup.selectedIndex)
			{
			case 0: 
				//コマンド名
				str += "CreateUnit ";
				//名前
				if (_nameInput.text.length > 0)
				{
					str += "name:" + _nameInput.text + " ";
				}
				else
				{
					return;
				}
				
				//位置
				str += "x:" + (posX + 1) + " ";
				str += "y:" + (posY + 1) + " ";
				
				//所属
				if (_sideInput.text.length > 0)
				{
					str += "side:" + _sideInput.text + " ";
				}
				else
				{
					return;
				}
				//レベル
				if (_levelStep.value > 0)
				{
					str += "level:" + _levelStep.value + " ";
				}
				else
				{
					return;
				}
				//強化値
				if (_strengthStep.value > 0)
				{
					str += "strength:" + _strengthStep.value + " ";
				}
				
				break;
			case 1: 
				//コマンド名
				str += "LaunchUnit ";
				//名前
				if (_nameInput.text.length > 0)
				{
					str += "name:" + _nameInput.text + " ";
				}
				else
				{
					return;
				}
				
				//位置
				str += "x:" + (posX + 1) + " ";
				str += "y:" + (posY + 1) + " ";
				break;
			}
			
			_outputText.text += str + "\n";
			
			var img:Image = new Image(UserImage.$.getSystemTex("select_frame"));
			img.x = posX * 32;
			img.y = posY * 32;
			MainController.$.view.canvas.addChild(img);
			
			_setImgList.push(img);
		}
		
		public function deleteImgList():void
		{
			var i:int = 0;
			for (i = 0; i < _setImgList.length; )
			{
				var img:Image = _setImgList.shift();
				img.removeFromParent(true);
				img = null;				
			}
		}
	
		public function showImgList(flg:Boolean):void
		{
			var i:int = 0;
			for (i = 0; i < _setImgList.length; i++)
			{
				_setImgList[i].visible = flg;		
			}
		}
		
		
	}
}